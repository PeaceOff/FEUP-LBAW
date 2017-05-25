--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: final; Type: SCHEMA; Schema: -; Owner: lbaw1665
--

CREATE SCHEMA final;


ALTER SCHEMA final OWNER TO lbaw1665;

SET search_path = final, pg_catalog;

--
-- Name: delete_collaborates(); Type: FUNCTION; Schema: final; Owner: lbaw1665
--

CREATE FUNCTION delete_collaborates() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

  folderID numeric;
  collab_number numeric;
  f_tasks task%rowtype;

BEGIN

   folderID=(SELECT folder.id FROM folder_project, folder WHERE folder.username=OLD.username AND folder_project.folder_id = folder.id AND folder_project.project_id = OLD.project_id);

   DELETE FROM folder_project WHERE project_id = OLD.project_id AND folder_id = folderID;

   FOR f_tasks IN
   SELECT * FROM task
   WHERE project_id = OLD.project_id
   LOOP

      BEGIN
         DELETE FROM assigned WHERE task_id=f_tasks.id AND username = OLD.username; 
      END;

   END LOOP;
   

   IF EXISTS (SELECT 1 FROM statistics WHERE username = OLD.username) THEN

      collab_number := (SELECT collab_proj_number - 1 FROM statistics WHERE username = OLD.username);
     
      UPDATE statistics SET collab_proj_number = collab_number WHERE username = OLD.username;

   END IF;


   RETURN OLD;

END$$;


ALTER FUNCTION final.delete_collaborates() OWNER TO lbaw1665;

--
-- Name: delete_comments(); Type: FUNCTION; Schema: final; Owner: lbaw1665
--

CREATE FUNCTION delete_comments() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

   DELETE FROM comment

      WHERE post_id = OLD.id;

   RETURN OLD;

END;$$;


ALTER FUNCTION final.delete_comments() OWNER TO lbaw1665;

--
-- Name: FUNCTION delete_comments(); Type: COMMENT; Schema: final; Owner: lbaw1665
--

COMMENT ON FUNCTION delete_comments() IS 'Funcao que apaga um comentario de um post';


--
-- Name: delete_folder(); Type: FUNCTION; Schema: final; Owner: lbaw1665
--

CREATE FUNCTION delete_folder() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

  default_folder_id numeric;

BEGIN

    default_folder_id = (SELECT id FROM folder WHERE username = OLD.username AND name = 'DEFAULT');

  
    UPDATE folder_project SET folder_id = default_folder_id 
         WHERE folder_id = OLD.id;
         

    RETURN OLD;

END;$$;


ALTER FUNCTION final.delete_folder() OWNER TO lbaw1665;

--
-- Name: FUNCTION delete_folder(); Type: COMMENT; Schema: final; Owner: lbaw1665
--

COMMENT ON FUNCTION delete_folder() IS 'Funcao que apaga uma pasta';


--
-- Name: delete_folder_default(); Type: FUNCTION; Schema: final; Owner: lbaw1665
--

CREATE FUNCTION delete_folder_default() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

   IF OLD.name = 'DEFAULT'

   THEN RETURN NULL;

   ELSE RETURN OLD;

   END IF;

END;$$;


ALTER FUNCTION final.delete_folder_default() OWNER TO lbaw1665;

--
-- Name: FUNCTION delete_folder_default(); Type: COMMENT; Schema: final; Owner: lbaw1665
--

COMMENT ON FUNCTION delete_folder_default() IS 'Funcao que nao deixa apagar a folder default do utilizador';


--
-- Name: delete_project_func(); Type: FUNCTION; Schema: final; Owner: lbaw1665
--

CREATE FUNCTION delete_project_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE 

    proj_number numeric;


BEGIN


    IF EXISTS (SELECT 1 FROM statistics WHERE username = OLD.manager) THEN

      proj_number = (SELECT own_proj_number - 1 FROM statistics WHERE username = OLD.manager);
     
      UPDATE statistics SET own_proj_number = proj_number WHERE username = OLD.manager;

    END IF;



   DELETE FROM collaborates

      WHERE OLD.id = project_id;

   DELETE FROM topic

      WHERE project_id = OLD.id;

   DELETE FROM document

      WHERE project_id = OLD.id;

   DELETE FROM folder_project

      WHERE project_id = OLD.id;

   DELETE FROM notification

      WHERE project_id = OLD.id;

   DELETE FROM task

      WHERE project_id = OLD.id;

   RETURN OLD;

END$$;


ALTER FUNCTION final.delete_project_func() OWNER TO lbaw1665;

--
-- Name: delete_task(); Type: FUNCTION; Schema: final; Owner: lbaw1665
--

CREATE FUNCTION delete_task() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

 r_assigned assigned%rowtype;
 unfinished_tasks numeric;

BEGIN
    FOR r_assigned IN SELECT *

               FROM assigned

               WHERE task_id = OLD.id

      LOOP

       IF EXISTS (SELECT 1 FROM statistics WHERE username = r_assigned.username) THEN

         unfinished_tasks = (SELECT task_unfinished_number - 1 FROM statistics WHERE username = r_assigned.username);
     
         UPDATE statistics SET task_unfinished_number = unfinished_tasks WHERE username = r_assigned.username;

       END IF;

   END LOOP;


   DELETE FROM topic WHERE task_id = OLD.id;

   DELETE FROM assigned WHERE task_id = OLD.id;
  

   RETURN OLD;

END$$;


ALTER FUNCTION final.delete_task() OWNER TO lbaw1665;

--
-- Name: delete_topic(); Type: FUNCTION; Schema: final; Owner: lbaw1665
--

CREATE FUNCTION delete_topic() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

   DELETE FROM post WHERE post.topic_id = OLD.id;

   RETURN OLD;

END$$;


ALTER FUNCTION final.delete_topic() OWNER TO lbaw1665;

--
-- Name: insert_collaborates(); Type: FUNCTION; Schema: final; Owner: lbaw1665
--

CREATE FUNCTION insert_collaborates() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

  folderID numeric;
  collab_number numeric;

BEGIN

  folderID = (SELECT id FROM folder WHERE name = 'DEFAULT' AND username = NEW.username);

  INSERT INTO folder_project VALUES (NEW.project_id,folderID);

 
  IF EXISTS (SELECT 1 FROM statistics WHERE username = NEW.username) THEN

      collab_number := (SELECT collab_proj_number + 1 FROM statistics WHERE username = NEW.username);
     
      UPDATE statistics SET collab_proj_number = collab_number WHERE username = NEW.username;

  ELSE 
        
      INSERT INTO statistics VALUES (NEW.username,1,1,0,0);

  END IF;


  RETURN NEW;

END;$$;


ALTER FUNCTION final.insert_collaborates() OWNER TO lbaw1665;

--
-- Name: FUNCTION insert_collaborates(); Type: COMMENT; Schema: final; Owner: lbaw1665
--

COMMENT ON FUNCTION insert_collaborates() IS 'Funcao que adiciona um projecto a pasta de default do utilizador quando este e adicionado como colaborador do projeto, e atualiza as estatisticas do utilizador em relacao aos colaboradores';


--
-- Name: insert_comment(); Type: FUNCTION; Schema: final; Owner: lbaw1665
--

CREATE FUNCTION insert_comment() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

   r_collab collaborates%rowtype;

   temp_string TEXT;

   topic__id NUMERIC;

   project__id NUMERIC;

BEGIN

   topic__id := (SELECT topic_id FROM post WHERE NEW.post_id=id);

   IF (SELECT type FROM topic WHERE id = topic__id) = 'project' THEN

     project__id:= (SELECT project.id FROM topic, project WHERE topic.id = topic__id AND project.id = topic.project_id);

   ELSE

     project__id:= (SELECT project.id FROM topic, project,task WHERE topic.id = topic__id AND topic.task_id = task.id AND project.id = task.project_id);

   END IF;

  IF NOT EXISTS (SELECT 1 FROM collaborates WHERE username = NEW.commenter AND project__id = collaborates.project_id) THEN

      RETURN NULL;

   END IF;


   IF NEW.commenter != (SELECT poster FROM post WHERE id = NEW.post_id) THEN

      temp_string := 'User |' || NEW.commenter || '| has commented on your post in topic |' || (SELECT title FROM topic WHERE id = topic__id) || '| from project |' || (SELECT name FROM project WHERE id = project__id) || '|';

      INSERT INTO notification (description, date, project_id, notificated, type, associated)

         VALUES(temp_string, CURRENT_DATE, project__id, (SELECT poster FROM post WHERE NEW.post_id = id), 'Information' ,NEW.commenter);

   END IF;

   RETURN NEW;

END$$;


ALTER FUNCTION final.insert_comment() OWNER TO lbaw1665;

--
-- Name: insert_document(); Type: FUNCTION; Schema: final; Owner: lbaw1665
--

CREATE FUNCTION insert_document() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

   r_collab collaborates%rowtype;

   temp_string TEXT;

BEGIN

   temp_string := 'ADDED DOCUMENT:' || (SELECT name FROM project WHERE id = NEW.project_id) || '/' || NEW.name;

   FOR r_collab IN SELECT *

               FROM collaborates

               WHERE project_id = NEW.project_id

   LOOP

         INSERT INTO notification (description, date, project_id, notificated, type, associated)

            VALUES(temp_string, CURRENT_DATE, NEW.project_id, r_collab.username, 'Information' , NULL);

   END LOOP;

   RETURN NEW;

END$$;


ALTER FUNCTION final.insert_document() OWNER TO lbaw1665;

--
-- Name: FUNCTION insert_document(); Type: COMMENT; Schema: final; Owner: lbaw1665
--

COMMENT ON FUNCTION insert_document() IS 'Sends notification when the project is updated';


--
-- Name: insert_folder(); Type: FUNCTION; Schema: final; Owner: lbaw1665
--

CREATE FUNCTION insert_folder() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

 
  IF EXISTS (SELECT 1 FROM folder WHERE name = NEW.name AND username = NEW.username) THEN

     RAISE EXCEPTION 'joao'; 

  END IF;

  RETURN NEW;

END;$$;


ALTER FUNCTION final.insert_folder() OWNER TO lbaw1665;

--
-- Name: insert_post(); Type: FUNCTION; Schema: final; Owner: lbaw1665
--

CREATE FUNCTION insert_post() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

   r_collab collaborates%rowtype;

   temp_string TEXT;

   project__id NUMERIC;

BEGIN

   IF (SELECT type FROM topic WHERE id = NEW.topic_id) = 'project' THEN

     project__id:= (SELECT project.id FROM topic, project WHERE topic.id = NEW.topic_id AND project.id = topic.project_id);

   ELSE

     project__id:= (SELECT project.id FROM topic, project,task WHERE topic.id = NEW.topic_id AND topic.task_id = task.id AND project.id = task.project_id);

   END IF;

  IF NOT EXISTS (SELECT 1 FROM collaborates WHERE username = NEW.poster AND project__id = collaborates.project_id) THEN

      RETURN NULL;

  END IF;

   temp_string := 'Added post on project |' || (SELECT name FROM project WHERE id = project__id)|| '| named |' ||(SELECT title FROM topic WHERE id = NEW.topic_id) ||  '|' ;

   FOR r_collab IN SELECT *

               FROM collaborates

               WHERE project_id = project__id

   LOOP
      IF NEW.poster != r_collab.username THEN
         INSERT INTO notification (description, date, project_id, notificated, type, associated)
            VALUES(temp_string, CURRENT_DATE, project__id, r_collab.username, 'Information' , NEW.poster);

      END IF;

   END LOOP;

   RETURN NEW;

END

$$;


ALTER FUNCTION final.insert_post() OWNER TO lbaw1665;

--
-- Name: insert_project(); Type: FUNCTION; Schema: final; Owner: lbaw1665
--

CREATE FUNCTION insert_project() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

   proj_number numeric;

BEGIN

    IF EXISTS (SELECT 1 FROM statistics WHERE username = NEW.manager) THEN

      proj_number := (SELECT own_proj_number + 1 FROM statistics WHERE username = NEW.manager);
     
      UPDATE statistics SET own_proj_number = proj_number WHERE username = NEW.manager;
 
    ELSE 
        
      INSERT INTO statistics VALUES (NEW.manager,1,0,0,0);
  
    END IF;



    INSERT INTO collaborates

       VALUES (NEW.id,NEW.manager);


    RETURN NEW;

END;

$$;


ALTER FUNCTION final.insert_project() OWNER TO lbaw1665;

--
-- Name: FUNCTION insert_project(); Type: COMMENT; Schema: final; Owner: lbaw1665
--

COMMENT ON FUNCTION insert_project() IS 'Trigger para inserir o manager de um projecto como colaborador e atualizar estatisticas. ';


--
-- Name: insert_project_folder(); Type: FUNCTION; Schema: final; Owner: lbaw1665
--

CREATE FUNCTION insert_project_folder() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

 userN character varying;

BEGIN

  userN = (SELECT username FROM folder WHERE folder.id = NEW.folder_id) AS username;

  IF EXISTS(SELECT 1 FROM (SELECT username FROM collaborates

            WHERE collaborates.project_id = NEW.project_id) AS users

            WHERE userN = users.username) THEN

      RETURN NEW;

  ELSE RETURN NULL;

  END IF;

END;$$;


ALTER FUNCTION final.insert_project_folder() OWNER TO lbaw1665;

--
-- Name: FUNCTION insert_project_folder(); Type: COMMENT; Schema: final; Owner: lbaw1665
--

COMMENT ON FUNCTION insert_project_folder() IS 'Verifica se o utilizador da pasta colabora no projeto';


--
-- Name: insert_task(); Type: FUNCTION; Schema: final; Owner: lbaw1665
--

CREATE FUNCTION insert_task() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

   r_collab collaborates%rowtype;

   message TEXT;

   unfinished_tasks numeric;

BEGIN

   IF NOT EXISTS (SELECT 1 FROM collaborates WHERE username = NEW.owner AND NEW.project_id = collaborates.project_id) THEN

      RETURN NULL;

   END IF;

   message := 'User ' || NEW.owner || ' added task ' || NEW.name || ' to ' || (SELECT name FROM project WHERE id = NEW.project_id);

   FOR r_collab IN SELECT *

               FROM collaborates

               WHERE project_id = NEW.project_id

   LOOP

      IF NEW.owner != r_collab.username THEN

         INSERT INTO notification (description, date, project_id, notificated, type, associated)

            VALUES(message , CURRENT_DATE, NEW.project_id, r_collab.username, 'Information' , NEW.owner);

      END IF;

   END LOOP;


    



   RETURN NEW;

END;$$;


ALTER FUNCTION final.insert_task() OWNER TO lbaw1665;

--
-- Name: insert_task_create_topic(); Type: FUNCTION; Schema: final; Owner: lbaw1665
--

CREATE FUNCTION insert_task_create_topic() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
  INSERT INTO topic(title,project_id,task_id,type) VALUES(NEW.name,NEW.project_id,NEW.id,'task');
  RETURN NEW;
END;$$;


ALTER FUNCTION final.insert_task_create_topic() OWNER TO lbaw1665;

--
-- Name: FUNCTION insert_task_create_topic(); Type: COMMENT; Schema: final; Owner: lbaw1665
--

COMMENT ON FUNCTION insert_task_create_topic() IS 'Creates a topic for a task when a new task is inserted';


--
-- Name: insert_update_assigned(); Type: FUNCTION; Schema: final; Owner: lbaw1665
--

CREATE FUNCTION insert_update_assigned() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

 unfinished_tasks numeric;

 message TEXT;

 r_proj project%rowtype;


BEGIN

   IF

      EXISTS(

         SELECT project_id

            FROM

               collaborates

            WHERE

               username = NEW.username

               AND project_id IN (SELECT project_id

                                     FROM task WHERE id = NEW.task_id)) THEN

    SELECT * FROM INTO r_proj project WHERE id = (SELECT project_id FROM task WHERE id = NEW.task_id);
    message := 'You have been assigned to task ' || (SELECT name FROM task WHERE id = NEW.task_id) || ' in project ' || r_proj.name;

    INSERT INTO notification (description, date, project_id, notificated, type, associated)

            VALUES(message , CURRENT_DATE, r_proj.id , NEW.username, 'Information' , NULL);

 

    IF EXISTS (SELECT 1 FROM statistics WHERE username = NEW.username) THEN

      unfinished_tasks = (SELECT task_unfinished_number + 1 FROM statistics WHERE username = NEW.username);
     
      UPDATE statistics SET task_unfinished_number = unfinished_tasks WHERE username = NEW.username;

    END IF;

    RETURN NEW;

   END IF;

   RETURN NULL;

END$$;


ALTER FUNCTION final.insert_update_assigned() OWNER TO lbaw1665;

--
-- Name: insert_user(); Type: FUNCTION; Schema: final; Owner: lbaw1665
--

CREATE FUNCTION insert_user() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

   INSERT INTO folder(name,username)

   VALUES ('DEFAULT',NEW.username);

   RETURN NEW;

END;$$;


ALTER FUNCTION final.insert_user() OWNER TO lbaw1665;

--
-- Name: FUNCTION insert_user(); Type: COMMENT; Schema: final; Owner: lbaw1665
--

COMMENT ON FUNCTION insert_user() IS 'Funcao para criar a pasta DEFAULT a um novo user';


--
-- Name: update_task(); Type: FUNCTION; Schema: final; Owner: lbaw1665
--

CREATE FUNCTION update_task() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

   r_collab collaborates%rowtype;

   temp_string TEXT;

BEGIN

   temp_string := 'Task from project |' || (SELECT name FROM project WHERE id = NEW.project_id) || '| with name |' || NEW.name || '| has changed category to |' || NEW.category || '|';

   FOR r_collab IN SELECT *

               FROM collaborates

               WHERE project_id = NEW.project_id

   LOOP

      IF NEW.owner != r_collab.username THEN

         INSERT INTO notification (description, date, project_id, notificated, type, associated)

            VALUES(temp_string, CURRENT_DATE, NEW.project_id, r_collab.username, 'Information' , NULL);

      END IF;

   END LOOP;

   RETURN NEW;

END$$;


ALTER FUNCTION final.update_task() OWNER TO lbaw1665;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: assigned; Type: TABLE; Schema: final; Owner: lbaw1665; Tablespace: 
--

CREATE TABLE assigned (
    username character varying NOT NULL,
    task_id numeric NOT NULL
);


ALTER TABLE assigned OWNER TO lbaw1665;

--
-- Name: category; Type: TABLE; Schema: final; Owner: lbaw1665; Tablespace: 
--

CREATE TABLE category (
    name character varying NOT NULL
);


ALTER TABLE category OWNER TO lbaw1665;

--
-- Name: collaborates; Type: TABLE; Schema: final; Owner: lbaw1665; Tablespace: 
--

CREATE TABLE collaborates (
    project_id numeric NOT NULL,
    username character varying NOT NULL
);


ALTER TABLE collaborates OWNER TO lbaw1665;

--
-- Name: comment_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1665
--

CREATE SEQUENCE comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE comment_id_seq OWNER TO lbaw1665;

--
-- Name: comment; Type: TABLE; Schema: final; Owner: lbaw1665; Tablespace: 
--

CREATE TABLE comment (
    message character varying NOT NULL,
    date timestamp without time zone,
    post_id numeric NOT NULL,
    commenter character varying NOT NULL,
    id numeric DEFAULT nextval('comment_id_seq'::regclass) NOT NULL
);


ALTER TABLE comment OWNER TO lbaw1665;

--
-- Name: document_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1665
--

CREATE SEQUENCE document_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE document_id_seq OWNER TO lbaw1665;

--
-- Name: document; Type: TABLE; Schema: final; Owner: lbaw1665; Tablespace: 
--

CREATE TABLE document (
    name character varying NOT NULL,
    description character varying,
    type character varying NOT NULL,
    path character varying,
    project_id numeric NOT NULL,
    id numeric DEFAULT nextval('document_id_seq'::regclass) NOT NULL,
    CONSTRAINT "definedType" CHECK ((((type)::text = 'Document'::text) OR ((type)::text = 'Link'::text)))
);


ALTER TABLE document OWNER TO lbaw1665;

--
-- Name: folder_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1665
--

CREATE SEQUENCE folder_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE folder_id_seq OWNER TO lbaw1665;

--
-- Name: folder; Type: TABLE; Schema: final; Owner: lbaw1665; Tablespace: 
--

CREATE TABLE folder (
    name character varying NOT NULL,
    username character varying NOT NULL,
    id numeric DEFAULT nextval('folder_id_seq'::regclass) NOT NULL
);


ALTER TABLE folder OWNER TO lbaw1665;

--
-- Name: folder_project; Type: TABLE; Schema: final; Owner: lbaw1665; Tablespace: 
--

CREATE TABLE folder_project (
    project_id numeric NOT NULL,
    folder_id numeric NOT NULL
);


ALTER TABLE folder_project OWNER TO lbaw1665;

--
-- Name: notification_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1665
--

CREATE SEQUENCE notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE notification_id_seq OWNER TO lbaw1665;

--
-- Name: notification; Type: TABLE; Schema: final; Owner: lbaw1665; Tablespace: 
--

CREATE TABLE notification (
    description character varying NOT NULL,
    date date NOT NULL,
    project_id integer NOT NULL,
    id numeric DEFAULT nextval('notification_id_seq'::regclass) NOT NULL,
    notificated character varying NOT NULL,
    type character varying NOT NULL,
    associated character varying,
    CONSTRAINT "definedType" CHECK ((((type)::text = 'Invite'::text) OR ((type)::text = 'Information'::text)))
);


ALTER TABLE notification OWNER TO lbaw1665;

--
-- Name: post_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1665
--

CREATE SEQUENCE post_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE post_id_seq OWNER TO lbaw1665;

--
-- Name: post; Type: TABLE; Schema: final; Owner: lbaw1665; Tablespace: 
--

CREATE TABLE post (
    content character varying,
    date timestamp without time zone,
    topic_id numeric NOT NULL,
    poster character varying NOT NULL,
    id numeric DEFAULT nextval('post_id_seq'::regclass) NOT NULL
);


ALTER TABLE post OWNER TO lbaw1665;

--
-- Name: project_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1665
--

CREATE SEQUENCE project_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE project_id_seq OWNER TO lbaw1665;

--
-- Name: project; Type: TABLE; Schema: final; Owner: lbaw1665; Tablespace: 
--

CREATE TABLE project (
    name character varying NOT NULL,
    description text,
    deadline date,
    manager character varying NOT NULL,
    id numeric DEFAULT nextval('project_id_seq'::regclass) NOT NULL,
    start date DEFAULT ('now'::text)::date
);


ALTER TABLE project OWNER TO lbaw1665;

--
-- Name: topic_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1665
--

CREATE SEQUENCE topic_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE topic_id_seq OWNER TO lbaw1665;

--
-- Name: topic; Type: TABLE; Schema: final; Owner: lbaw1665; Tablespace: 
--

CREATE TABLE topic (
    id numeric DEFAULT nextval('topic_id_seq'::regclass) NOT NULL,
    title character varying NOT NULL,
    project_id numeric,
    task_id numeric,
    type character varying NOT NULL
);


ALTER TABLE topic OWNER TO lbaw1665;

--
-- Name: search_fields; Type: VIEW; Schema: final; Owner: lbaw1665
--

CREATE VIEW search_fields AS
 SELECT project.description,
    topic.title,
    collaborates.username,
    post.content,
    comment.message
   FROM project,
    topic,
    collaborates,
    post,
    comment
  WHERE ((((topic.project_id = project.id) AND (project.id = collaborates.project_id)) AND (post.topic_id = topic.id)) AND (comment.post_id = topic.id));


ALTER TABLE search_fields OWNER TO lbaw1665;

--
-- Name: statistics; Type: TABLE; Schema: final; Owner: lbaw1665; Tablespace: 
--

CREATE TABLE statistics (
    username character varying NOT NULL,
    own_proj_number numeric NOT NULL,
    collab_proj_number numeric NOT NULL,
    task_finished_number numeric NOT NULL,
    task_unfinished_number numeric NOT NULL
);


ALTER TABLE statistics OWNER TO lbaw1665;

--
-- Name: task_id_seq; Type: SEQUENCE; Schema: final; Owner: lbaw1665
--

CREATE SEQUENCE task_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE task_id_seq OWNER TO lbaw1665;

--
-- Name: task; Type: TABLE; Schema: final; Owner: lbaw1665; Tablespace: 
--

CREATE TABLE task (
    name character varying NOT NULL,
    description text,
    deadline date,
    id numeric DEFAULT nextval('task_id_seq'::regclass) NOT NULL,
    owner character varying NOT NULL,
    project_id numeric NOT NULL,
    category character varying NOT NULL
);


ALTER TABLE task OWNER TO lbaw1665;

--
-- Name: user; Type: TABLE; Schema: final; Owner: lbaw1665; Tablespace: 
--

CREATE TABLE "user" (
    username character varying NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL,
    name character varying
);


ALTER TABLE "user" OWNER TO lbaw1665;

--
-- Name: view_project_collabs; Type: VIEW; Schema: final; Owner: lbaw1665
--

CREATE VIEW view_project_collabs AS
 SELECT project.name,
    project.description,
    project.deadline,
    project.manager,
    project.id,
    collaborates.project_id,
    collaborates.username
   FROM project,
    collaborates
  WHERE (collaborates.project_id = project.id);


ALTER TABLE view_project_collabs OWNER TO lbaw1665;

--
-- Name: view_project_folder; Type: VIEW; Schema: final; Owner: lbaw1665
--

CREATE VIEW view_project_folder AS
 SELECT project.id AS project_id,
    project.name AS project_name,
    folder.id AS folder_id,
    folder.name AS folder_name,
    folder.username AS owner
   FROM project,
    folder_project,
    folder
  WHERE ((project.id = folder_project.project_id) AND (folder_project.folder_id = folder.id));


ALTER TABLE view_project_folder OWNER TO lbaw1665;

--
-- Data for Name: assigned; Type: TABLE DATA; Schema: final; Owner: lbaw1665
--

INSERT INTO assigned VALUES ('teste1234', 5);
INSERT INTO assigned VALUES ('teste1234', 9);
INSERT INTO assigned VALUES ('teste', 16);
INSERT INTO assigned VALUES ('teste', 17);
INSERT INTO assigned VALUES ('teste', 14);
INSERT INTO assigned VALUES ('marcelo', 10);
INSERT INTO assigned VALUES ('teste1234', 18);
INSERT INTO assigned VALUES ('up201404332@fe.up.pt', 33);
INSERT INTO assigned VALUES ('pepito', 30);


--
-- Data for Name: category; Type: TABLE DATA; Schema: final; Owner: lbaw1665
--

INSERT INTO category VALUES ('To-Do');
INSERT INTO category VALUES ('Doing');
INSERT INTO category VALUES ('Done');


--
-- Data for Name: collaborates; Type: TABLE DATA; Schema: final; Owner: lbaw1665
--

INSERT INTO collaborates VALUES (74, 'marcelo');
INSERT INTO collaborates VALUES (2, 'marcelo');
INSERT INTO collaborates VALUES (22, 'teste');
INSERT INTO collaborates VALUES (4, 'marcelo');
INSERT INTO collaborates VALUES (7, 'teste');
INSERT INTO collaborates VALUES (75, 'up201404189');
INSERT INTO collaborates VALUES (11, 'jmartins');
INSERT INTO collaborates VALUES (13, 'teste');
INSERT INTO collaborates VALUES (14, 'teste');
INSERT INTO collaborates VALUES (4, 'teste');
INSERT INTO collaborates VALUES (4, 'teste1234');
INSERT INTO collaborates VALUES (76, 'batatumarrebitado20');
INSERT INTO collaborates VALUES (77, 'ff');
INSERT INTO collaborates VALUES (7, 'marcelo');
INSERT INTO collaborates VALUES (78, 'super');
INSERT INTO collaborates VALUES (78, 'marcelo');
INSERT INTO collaborates VALUES (79, 'up201404332@fe.up.pt');
INSERT INTO collaborates VALUES (80, 'up201404189@fe.up.pt');
INSERT INTO collaborates VALUES (81, 'lluismmartins7@gmail.com');
INSERT INTO collaborates VALUES (82, 'marcelo');
INSERT INTO collaborates VALUES (58, 'tt');
INSERT INTO collaborates VALUES (61, 'oi1');
INSERT INTO collaborates VALUES (61, 'oi');
INSERT INTO collaborates VALUES (65, 'oi');
INSERT INTO collaborates VALUES (18, 'teste1234');
INSERT INTO collaborates VALUES (7, 'teste1234');
INSERT INTO collaborates VALUES (22, 'teste1234');
INSERT INTO collaborates VALUES (69, 'pepito');
INSERT INTO collaborates VALUES (13, 'pepito');
INSERT INTO collaborates VALUES (17, 'teste1234');
INSERT INTO collaborates VALUES (71, 'up201405846');
INSERT INTO collaborates VALUES (73, 'up201404332');
INSERT INTO collaborates VALUES (14, 'up201404332');


--
-- Data for Name: comment; Type: TABLE DATA; Schema: final; Owner: lbaw1665
--

INSERT INTO comment VALUES ('Mesmo Belo <3', '2017-04-30 18:12:24.211397', 75, 'teste', 288);


--
-- Name: comment_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1665
--

SELECT pg_catalog.setval('comment_id_seq', 305, true);


--
-- Data for Name: document; Type: TABLE DATA; Schema: final; Owner: lbaw1665
--

INSERT INTO document VALUES ('Tanks.gif', 'Description', 'Document', '/opt/lbaw/lbaw1665/public_html/final//uploads/7/Tanks.gif', 7, 14);
INSERT INTO document VALUES ('pkp.gif', 'Description', 'Document', '/opt/lbaw/lbaw1665/public_html/final//uploads/7/pkp.gif', 7, 15);
INSERT INTO document VALUES ('sleepy.gif', 'Description', 'Document', '/opt/lbaw/lbaw1665/public_html/final//uploads/7/sleepy.gif', 7, 16);
INSERT INTO document VALUES ('q2GQ923.gif', 'Description', 'Document', '/opt/lbaw/lbaw1665/public_html/final//uploads/7/q2GQ923.gif', 7, 17);
INSERT INTO document VALUES ('sleepy.gif', 'Description', 'Document', '/opt/lbaw/lbaw1665/public_html/final//uploads/7/sleepy.gif', 7, 18);
INSERT INTO document VALUES ('A9.txt', 'Description', 'Document', '/opt/lbaw/lbaw1665/public_html/final//uploads/74/A9.txt', 74, 21);
INSERT INTO document VALUES ('A9.txt', 'Description', 'Document', '/opt/lbaw/lbaw1665/public_html/final//uploads/4/A9.txt', 4, 28);
INSERT INTO document VALUES ('', '', 'Link', 'www.youtubas.com', 76, 40);
INSERT INTO document VALUES ('charmander1.gif', 'Description', 'Document', '/opt/lbaw/lbaw1665/public_html/final//uploads/76/charmander1.gif', 76, 41);
INSERT INTO document VALUES ('hm.......jpg', 'Description', 'Document', '/opt/lbaw/lbaw1665/public_html/final//uploads/76/hm.......jpg', 76, 42);
INSERT INTO document VALUES ('', '', 'Link', 'https://www.facebook.com/', 4, 43);
INSERT INTO document VALUES ('', '', 'Link', 'http://www.facebook.com/', 4, 44);


--
-- Name: document_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1665
--

SELECT pg_catalog.setval('document_id_seq', 44, true);


--
-- Data for Name: folder; Type: TABLE DATA; Schema: final; Owner: lbaw1665
--

INSERT INTO folder VALUES ('DEFAULT', 'jmartins', 2);
INSERT INTO folder VALUES ('DEFAULT', 'marcelo', 3);
INSERT INTO folder VALUES ('DEFAULT', 'teste', 4);
INSERT INTO folder VALUES ('DEFAULT', 'teste1234', 5);
INSERT INTO folder VALUES ('Batata', 'teste1234', 7);
INSERT INTO folder VALUES ('Batata', 'teste1234', 8);
INSERT INTO folder VALUES ('DEFAULT', 'jmartins', 12);
INSERT INTO folder VALUES ('ola', 'marcelo', 14);
INSERT INTO folder VALUES ('AMIZADE', 'marcelo', 15);
INSERT INTO folder VALUES ('DEFAULT', 'oi', 23);
INSERT INTO folder VALUES ('DEFAULT', 'tt', 29);
INSERT INTO folder VALUES ('DEFAULT', 'ralo', 30);
INSERT INTO folder VALUES ('DEFAULT', 'oi1', 31);
INSERT INTO folder VALUES ('DEFAULT', 'david', 32);
INSERT INTO folder VALUES ('DEFAULT', 'pepito', 33);
INSERT INTO folder VALUES ('DEFAULT', 'up201404332', 35);
INSERT INTO folder VALUES ('Batata', 'up201404332', 36);
INSERT INTO folder VALUES ('DEFAULT', 'up201405846', 37);
INSERT INTO folder VALUES ('DEFAULT', 'up201404189', 38);
INSERT INTO folder VALUES ('DEFAULT', 'batatumarrebitado20', 41);
INSERT INTO folder VALUES ('DEFAULT', 'ff', 42);
INSERT INTO folder VALUES ('PIGS', 'ff', 43);
INSERT INTO folder VALUES ('DEFAULT', 'upup201404332@fe.up.pt', 44);
INSERT INTO folder VALUES ('DEFAULT', 'up201404332@fe.up.pt', 45);
INSERT INTO folder VALUES ('DEFAULT', 'lluismmartins7@gmail.com', 46);
INSERT INTO folder VALUES ('DEFAULT', 'super', 47);
INSERT INTO folder VALUES ('Batata', 'up201404332@fe.up.pt', 48);
INSERT INTO folder VALUES ('DEFAULT', 'up201404189@fe.up.pt', 49);
INSERT INTO folder VALUES ('', 'marcelo', 50);
INSERT INTO folder VALUES ('hello', 'marcelo', 51);


--
-- Name: folder_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1665
--

SELECT pg_catalog.setval('folder_id_seq', 51, true);


--
-- Data for Name: folder_project; Type: TABLE DATA; Schema: final; Owner: lbaw1665
--

INSERT INTO folder_project VALUES (7, 5);
INSERT INTO folder_project VALUES (7, 4);
INSERT INTO folder_project VALUES (69, 33);
INSERT INTO folder_project VALUES (13, 4);
INSERT INTO folder_project VALUES (13, 33);
INSERT INTO folder_project VALUES (71, 37);
INSERT INTO folder_project VALUES (73, 35);
INSERT INTO folder_project VALUES (14, 4);
INSERT INTO folder_project VALUES (14, 35);
INSERT INTO folder_project VALUES (74, 3);
INSERT INTO folder_project VALUES (18, 5);
INSERT INTO folder_project VALUES (75, 38);
INSERT INTO folder_project VALUES (22, 4);
INSERT INTO folder_project VALUES (4, 4);
INSERT INTO folder_project VALUES (4, 15);
INSERT INTO folder_project VALUES (4, 5);
INSERT INTO folder_project VALUES (76, 41);
INSERT INTO folder_project VALUES (77, 42);
INSERT INTO folder_project VALUES (7, 3);
INSERT INTO folder_project VALUES (78, 47);
INSERT INTO folder_project VALUES (78, 3);
INSERT INTO folder_project VALUES (80, 49);
INSERT INTO folder_project VALUES (81, 46);
INSERT INTO folder_project VALUES (2, 3);
INSERT INTO folder_project VALUES (82, 3);
INSERT INTO folder_project VALUES (79, 45);
INSERT INTO folder_project VALUES (11, 2);
INSERT INTO folder_project VALUES (17, 5);
INSERT INTO folder_project VALUES (58, 29);
INSERT INTO folder_project VALUES (22, 5);
INSERT INTO folder_project VALUES (61, 31);
INSERT INTO folder_project VALUES (61, 23);
INSERT INTO folder_project VALUES (65, 23);


--
-- Data for Name: notification; Type: TABLE DATA; Schema: final; Owner: lbaw1665
--

INSERT INTO notification VALUES ('ADDED POST:Danone/Bem Vindo', '2017-04-28', 7, 8643, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('ADDED DOCUMENT:Bolachas e Bolachas/', '2001-12-13', 73, 10958, 'up201404332', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED POST:Danone/Bem Vindo', '2017-04-28', 7, 8652, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('User teste added task Fernando Mendes to Danone', '2017-05-18', 7, 11723, 'marcelo', 'Information', 'teste');
INSERT INTO notification VALUES ('ADDED POST:Danone/Bem Vindo', '2017-04-28', 7, 8662, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 10965, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('User teste added task Fernando Mendes to Danone', '2017-05-18', 7, 11724, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 10973, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED POST:Danone/Batatas', '2017-04-28', 7, 8683, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 10981, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Bolachas e Bolachas/', '2001-12-13', 73, 11532, 'up201404332', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED POST:Danone/Boas', '2017-04-28', 7, 8693, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 10989, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED POST:Danone/Boas', '2017-04-28', 7, 8699, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11557, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 373, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 10997, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED POST:Danone/Eheh', '2017-04-28', 7, 8709, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11558, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 376, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11005, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/O david é xiruu Changed Category To:Doing', '2017-04-28', 7, 237, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |newComers|', '2017-05-04', 7, 11582, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11013, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |GG|', '2017-04-29', 7, 8729, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('Added post on project |Danone| named |newComers|', '2017-05-04', 7, 11583, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11021, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |jose|', '2017-04-29', 7, 8769, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 412, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 415, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 418, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 421, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 424, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 427, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 430, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 433, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 436, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 439, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 442, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 445, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 448, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 451, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 454, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 457, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 460, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 463, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 466, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 469, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 472, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 475, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 478, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 481, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 484, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 487, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 490, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('jmartinsCOMMENTED ON YOUR POST AT:Danone/Suave', '2001-12-13', 7, 216, 'jmartins', 'Information', 'jmartins');
INSERT INTO notification VALUES ('jmartinsCOMMENTED ON YOUR POST AT:Danone/Suave', '2001-12-13', 7, 217, 'jmartins', 'Information', 'jmartins');
INSERT INTO notification VALUES ('jmartinsCOMMENTED ON YOUR POST AT:Danone/Suave', '2001-12-13', 7, 219, 'jmartins', 'Information', 'jmartins');
INSERT INTO notification VALUES ('Added post on project |Bacalhaus Constipados| named |Enchidos|', '2017-04-30', 22, 10959, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('ADDED POST:Danone/Bem Vindo', '2017-04-28', 7, 8654, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('User teste added task Quim das Remisturas to Danone', '2017-05-18', 7, 11725, 'marcelo', 'Information', 'teste');
INSERT INTO notification VALUES ('ADDED POST:Danone/Batatas', '2017-04-28', 7, 8664, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 10967, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED POST:Danone/Batatas', '2017-04-28', 7, 8670, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('User teste added task Quim das Remisturas to Danone', '2017-05-18', 7, 11726, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 10975, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED POST:Danone/Batatas', '2017-04-28', 7, 8685, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 10983, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |Nando Pessoa|', '2017-05-04', 7, 11533, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 10991, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |Nando Pessoa|', '2017-05-04', 7, 11534, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('ADDED POST:Danone/Eheh', '2017-04-28', 7, 8705, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 10999, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11559, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11007, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11560, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('Added post on project |Danone| named |GG|', '2017-04-29', 7, 8724, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11015, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('You have been assigned to task Já Caguei!! in project Danone', '2017-05-04', 7, 11584, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11023, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |Cenas|', '2017-04-29', 7, 8741, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11029, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |jose|', '2017-04-29', 7, 8754, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('Added post on project |Danone| named |jose|', '2017-04-29', 7, 8770, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 525, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 527, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 529, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 531, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 533, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 535, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 537, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 539, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 541, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 543, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 545, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 547, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 549, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 551, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 552, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 553, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 554, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 555, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 556, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 557, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 558, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 559, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 560, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 561, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 562, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 563, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 564, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 565, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 566, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 567, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 568, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 569, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 570, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 571, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('User teste added task Ave Maria to Danone', '2017-05-18', 7, 11727, 'marcelo', 'Information', 'teste');
INSERT INTO notification VALUES ('ADDED DOCUMENT:Danone//tmp/phpgAx3T5', '2001-12-13', 7, 11467, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED POST:Danone/Bem Vindo', '2017-04-28', 7, 8656, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('ADDED POST:Danone/Batatas', '2017-04-28', 7, 8666, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 375, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 378, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 381, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 384, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 387, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 390, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 393, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 396, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 399, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 402, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 417, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 420, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 423, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 426, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 429, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 432, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 435, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 438, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 441, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 444, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 447, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 450, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 453, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 456, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 459, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 462, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 465, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 468, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 471, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 474, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 477, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 480, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 483, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 486, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 489, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 492, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 494, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 496, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 498, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 500, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 502, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 504, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 506, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 508, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 510, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 512, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 514, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 516, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 518, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 520, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 522, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 524, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 526, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 528, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 530, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 532, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 534, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 536, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 538, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 540, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 542, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 544, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 546, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 548, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 550, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 572, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 573, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 574, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 575, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 576, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 577, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 578, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 579, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 580, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 581, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 582, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 583, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 584, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 585, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 586, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 587, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 588, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 589, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 590, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 591, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 592, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 593, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 594, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 595, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 596, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 597, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 598, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 599, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 600, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 601, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 602, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 603, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 604, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 605, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 606, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 607, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 608, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED POST:Danone/Bem Vindo', '2017-04-28', 7, 8648, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 10961, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED POST:Danone/Bem Vindo', '2017-04-28', 7, 8658, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('ADDED DOCUMENT:Danone//tmp/phpgAx3T5', '2001-12-13', 7, 11468, 'up201405846', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 10969, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('User teste added task Ave Maria to Danone', '2017-05-18', 7, 11728, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 10977, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Danone//tmp/phpt9Lo86', '2001-12-13', 7, 11470, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 10985, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Danone//tmp/phpt9Lo86', '2001-12-13', 7, 11471, 'up201405846', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 10993, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11001, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11009, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on projectDanone named GG', '2017-04-29', 7, 8720, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('Added post on project |Danone| named |Nando Pessoa|', '2017-05-04', 7, 11535, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Added post on project |Danone| named |GG|', '2017-04-29', 7, 8726, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11017, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |GG|', '2017-04-29', 7, 8732, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('Added post on project |Danone| named |Nando Pessoa|', '2017-05-04', 7, 11536, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('Added post on project |Danone| named |testando|', '2017-04-29', 7, 8737, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11025, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11561, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11562, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('Added post on project |Danone| named |jose|', '2017-04-29', 7, 8767, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('ADDED POST:Danone/Bem Vindo', '2017-04-28', 7, 8650, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('ADDED POST:Danone/Bem Vindo', '2017-04-28', 7, 8660, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 10963, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Danone//tmp/php214NXH', '2001-12-13', 7, 11473, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 10971, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Danone//tmp/php214NXH', '2001-12-13', 7, 11474, 'up201405846', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED POST:Danone/Batatas', '2017-04-28', 7, 8681, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 10979, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 10987, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED POST:Danone/Boas', '2017-04-28', 7, 8697, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('ADDED DOCUMENT:Danone//tmp/phpslmPHk', '2001-12-13', 7, 11476, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 10995, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Danone//tmp/phpslmPHk', '2001-12-13', 7, 11477, 'up201405846', 'Information', NULL);
INSERT INTO notification VALUES ('User teste added task 25 de MAIO to Danone', '2017-05-25', 7, 11733, 'marcelo', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11003, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('User teste added task 25 de MAIO to Danone', '2017-05-25', 7, 11734, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11011, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |Nando Pessoa|', '2017-05-04', 7, 11537, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11019, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |Nando Pessoa|', '2017-05-04', 7, 11538, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11027, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11563, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11031, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11564, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 676, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 677, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 678, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 679, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 680, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 681, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 682, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 683, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 684, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 685, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 686, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 687, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 688, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 689, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 690, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 691, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 692, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 693, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 694, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 695, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:To-Do', '2017-04-28', 7, 696, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('TASK:Danone/Já Caguei!! Changed Category To:Doing', '2017-04-28', 7, 697, 'jmartins', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED POST:Danone/Suavezito', '2017-04-28', 7, 698, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11033, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |jose|', '2017-04-29', 7, 8768, 'jmartins', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11035, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11037, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11039, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('User teste added task O MEU NOME E TONE to Danone', '2017-05-18', 7, 11731, 'marcelo', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11041, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Danone//tmp/php2vzO3k', '2001-12-13', 7, 11479, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11043, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Danone//tmp/php2vzO3k', '2001-12-13', 7, 11480, 'up201405846', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11045, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('User teste added task O MEU NOME E TONE to Danone', '2017-05-18', 7, 11732, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11047, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Danone//tmp/phpOEViqj', '2001-12-13', 7, 11482, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11049, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Danone//tmp/phpOEViqj', '2001-12-13', 7, 11483, 'up201405846', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11051, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:testinho/', '2017-05-25', 4, 11735, 'marcelo', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11053, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:testinho/', '2017-05-25', 4, 11736, 'teste', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11055, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |testando|', '2017-05-04', 7, 11539, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11057, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |testando|', '2017-05-04', 7, 11540, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11059, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11565, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11061, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11566, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11063, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:testinho/', '2017-05-25', 4, 11737, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11065, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11067, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11069, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11071, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11073, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11075, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11077, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11079, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11081, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11083, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11085, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11087, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:testinho/', '2017-05-25', 4, 11738, 'marcelo', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11089, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Danone/q2GQ923.gif', '2001-12-13', 7, 11485, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11091, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Danone/q2GQ923.gif', '2001-12-13', 7, 11486, 'up201405846', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11093, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:testinho/', '2017-05-25', 4, 11739, 'teste', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11095, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Danone/Tanks.gif', '2001-12-13', 7, 11488, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11097, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Danone/Tanks.gif', '2001-12-13', 7, 11489, 'up201405846', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11099, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:testinho/', '2017-05-25', 4, 11740, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11101, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11103, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Bolachas e Bolachas/get-pip.py', '2001-12-13', 73, 11524, 'up201404332', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11105, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |testando|', '2017-05-04', 7, 11541, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11107, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |testando|', '2017-05-04', 7, 11542, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11109, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11111, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11113, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11115, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |Bom Dia|', '2017-05-18', 7, 11602, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11117, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11119, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11121, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11123, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11125, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11127, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11129, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11131, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11133, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('User marcelo added task nkn to testinho', '2017-05-25', 4, 11741, 'teste', 'Information', 'marcelo');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11135, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Danone/pkp.gif', '2001-12-13', 7, 11491, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11137, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Danone/pkp.gif', '2001-12-13', 7, 11492, 'up201405846', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11139, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('User marcelo added task nkn to testinho', '2017-05-25', 4, 11742, 'teste1234', 'Information', 'marcelo');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11141, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Danone/sleepy.gif', '2001-12-13', 7, 11494, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11143, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Danone/sleepy.gif', '2001-12-13', 7, 11495, 'up201405846', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11145, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11147, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11149, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Bolachas e Bolachas/get-pip.py', '2001-12-13', 73, 11525, 'up201404332', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11151, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |testando|', '2017-05-04', 7, 11543, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11153, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |testando|', '2017-05-04', 7, 11544, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11155, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11568, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11157, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11569, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11159, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11161, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11163, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |Bom Dia|', '2017-05-18', 7, 11603, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11165, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11167, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11169, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11171, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11173, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11175, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11177, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11179, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11181, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11183, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Danone/q2GQ923.gif', '2001-12-13', 7, 11497, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11185, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Danone/q2GQ923.gif', '2001-12-13', 7, 11498, 'up201405846', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11187, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11189, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Danone/sleepy.gif', '2001-12-13', 7, 11500, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11191, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Danone/sleepy.gif', '2001-12-13', 7, 11501, 'up201405846', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11193, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Bolachas e Bolachas/', '2001-12-13', 73, 11526, 'up201404332', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11195, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11545, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11197, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11546, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11199, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11570, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11201, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11571, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11203, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('User teste added task sadasd to stat3', '2017-05-04', 13, 11590, 'pepito', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11205, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11207, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11209, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11211, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11213, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11215, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11217, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11219, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11221, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11223, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11225, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11227, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11229, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11231, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Bolachas e Bolachas/get-pip.py', '2001-12-13', 73, 11527, 'up201404332', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11233, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11547, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11235, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11548, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11237, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |testando|', '2017-05-04', 7, 11572, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11239, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |testando|', '2017-05-04', 7, 11573, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11241, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('User teste added task sad to stat3', '2017-05-04', 13, 11591, 'pepito', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11243, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11245, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11247, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11249, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11251, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11253, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11255, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11257, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11259, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11261, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11263, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11265, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11267, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11269, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11271, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11273, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11275, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11277, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11279, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Bolachas e Bolachas/', '2001-12-13', 73, 11528, 'up201404332', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11281, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11549, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11283, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11550, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11285, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11574, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11287, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11575, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11289, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('You have been assigned to task sadasd in project stat3', '2017-05-04', 13, 11592, 'pepito', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11291, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11293, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11295, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11297, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11299, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11301, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11303, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11305, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |To-Do|', '2017-05-18', 7, 11693, 'marcelo', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11307, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |To-Do|', '2017-05-18', 7, 11694, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11309, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11311, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11313, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11315, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11317, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11319, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11321, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11323, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Bolachas e Bolachas/get-pip.py', '2001-12-13', 73, 11529, 'up201404332', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11325, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11551, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11327, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11552, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11329, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |newComers|', '2017-05-04', 7, 11576, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11331, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |newComers|', '2017-05-04', 7, 11577, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11333, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11335, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Doing|', '2017-04-30', 22, 11337, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Done|', '2017-04-30', 22, 11339, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |Doing|', '2017-04-30', 22, 11341, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11343, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11345, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11347, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11349, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |To-Do|', '2017-05-18', 7, 11695, 'marcelo', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11351, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |To-Do|', '2017-05-18', 7, 11696, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11353, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11355, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11357, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11359, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11361, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11363, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11365, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11367, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11369, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11371, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Bolachas e Bolachas/', '2001-12-13', 73, 11530, 'up201404332', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11373, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11553, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11375, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11554, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11377, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |newComers|', '2017-05-04', 7, 11578, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11379, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |newComers|', '2017-05-04', 7, 11579, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11381, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11383, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11385, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11387, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11389, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11391, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11393, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11395, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11397, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11399, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11401, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11403, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11405, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11407, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11409, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11411, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11413, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11415, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11417, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11419, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('ADDED DOCUMENT:Bolachas e Bolachas/get-pip.py', '2001-12-13', 73, 11531, 'up201404332', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11421, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11555, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11423, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |novo|', '2017-05-04', 7, 11556, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11425, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |newComers|', '2017-05-04', 7, 11580, 'teste1234', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11427, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Added post on project |Danone| named |newComers|', '2017-05-04', 7, 11581, 'up201405846', 'Information', 'teste');
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11429, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11431, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11433, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11435, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11437, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11439, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11441, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11443, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11445, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11447, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11449, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11451, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11453, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11455, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11457, 'teste1234', 'Information', NULL);
INSERT INTO notification VALUES ('Task from project |Bacalhaus Constipados| with name |O david é xiruu| has changed category to |To-Do|', '2017-04-30', 22, 11459, 'teste1234', 'Information', NULL);


--
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1665
--

SELECT pg_catalog.setval('notification_id_seq', 11742, true);


--
-- Data for Name: post; Type: TABLE DATA; Schema: final; Owner: lbaw1665
--

INSERT INTO post VALUES ('A task de fazer coco', '2017-05-18 10:06:42.248108', 45, 'teste', 103);
INSERT INTO post VALUES ('A task de fazer xixi', '2017-05-18 10:06:47.078162', 45, 'teste', 104);
INSERT INTO post VALUES ('Este ''e um Post Belo! <3', '2017-04-30 18:12:17.652379', 37, 'teste', 75);


--
-- Name: post_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1665
--

SELECT pg_catalog.setval('post_id_seq', 104, true);


--
-- Data for Name: project; Type: TABLE DATA; Schema: final; Owner: lbaw1665
--

INSERT INTO project VALUES ('Bacalhaus Constipados', 'AHAHAHAHA', '2017-04-28', 'teste1234', 22, '2017-04-29');
INSERT INTO project VALUES ('Danone', 'Testing teste the project adding teste', '2017-05-06', 'teste', 7, '2017-04-29');
INSERT INTO project VALUES ('stat3', 'dasdsa', NULL, 'teste', 13, '2017-04-29');
INSERT INTO project VALUES ('SADADSDSSADADSDSSADADSDSSADADSDS', 'SADADSDSSADADSDSSADADSDSSADADSDSSADADSDSSADADSDS', '2017-04-27', 'teste1234', 17, '2017-04-29');
INSERT INTO project VALUES ('Teste2', 'Batata2', '2017-04-28', 'teste1234', 18, '2017-04-29');
INSERT INTO project VALUES ('stat2', '453275324535', '2017-03-29', 'jmartins', 11, '2017-04-29');
INSERT INTO project VALUES ('dsa', 'd', '2017-04-05', 'tt', 58, '2017-04-29');
INSERT INTO project VALUES ('panados', 'as', '2017-04-29', 'oi1', 61, '2017-04-29');
INSERT INTO project VALUES ('Milheiros', 'Vamos todos jogar com o canelas neste belo dia de abril
', '2017-04-30', 'up201405846', 71, '2017-04-12');
INSERT INTO project VALUES ('das', 'd', '2017-04-29', 'oi', 65, '2017-04-29');
INSERT INTO project VALUES ('panados', 'asdsadasdsda', '2017-04-29', 'pepito', 69, '2017-04-29');
INSERT INTO project VALUES ('Bolachas e Bolachas', 'Bolachas e Bolachas Bolachas e Bolachas Bolachas e Bolachas Bolachas e Bolachas Bolachas e Bolachas', '2017-05-11', 'up201404332', 73, '2017-04-12');
INSERT INTO project VALUES ('BoasPessoal', 'Projeto para dar boas ao pessoal', '2017-06-10', 'teste', 14, '2017-04-29');
INSERT INTO project VALUES ('mais', 'fucntio', '2017-05-06', 'marcelo', 74, '2017-04-30');
INSERT INTO project VALUES ('ola', 'oi
', '2017-05-04', 'up201404189', 75, '2017-05-04');
INSERT INTO project VALUES ('testinho', 'ola', '2017-05-05', 'marcelo', 4, '2017-04-29');
INSERT INTO project VALUES ('Oi', 'teste', '2017-05-18', 'batatumarrebitado20', 76, '2017-05-16');
INSERT INTO project VALUES ('KILL THE KING', 'Game of THRONES', '2017-08-18', 'ff', 77, '2017-05-16');
INSERT INTO project VALUES ('Invite', 'iuppppuuuuuuuuuuuuuuuuuuiiiiii', '2017-06-06', 'super', 78, '2017-05-18');
INSERT INTO project VALUES ('Teste', 'oi
', '2017-05-18', 'up201404189@fe.up.pt', 80, '2017-05-18');
INSERT INTO project VALUES ('oi', 'asd
', '2017-05-18', 'lluismmartins7@gmail.com', 81, '2017-05-18');
INSERT INTO project VALUES ('Mobile App', 'finalmente', NULL, 'marcelo', 2, '2017-04-29');
INSERT INTO project VALUES ('as', 'adadkaldakçldals', '2017-05-25', 'marcelo', 82, '2017-05-25');
INSERT INTO project VALUES ('Joao', 'EraUmaVez123213
', '2017-05-18', 'up201404332@fe.up.pt', 79, '2017-05-18');


--
-- Name: project_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1665
--

SELECT pg_catalog.setval('project_id_seq', 82, true);


--
-- Data for Name: statistics; Type: TABLE DATA; Schema: final; Owner: lbaw1665
--

INSERT INTO statistics VALUES ('up201404189', 1, 1, 0, 0);
INSERT INTO statistics VALUES ('pepito', 1, 2, 0, 1);
INSERT INTO statistics VALUES ('oi1', 1, 1, 0, 0);
INSERT INTO statistics VALUES ('teste', 2, 1, 0, 7);
INSERT INTO statistics VALUES ('teste1234', 3, 4, 0, 4);
INSERT INTO statistics VALUES ('batatumarrebitado20', 1, 1, 0, 0);
INSERT INTO statistics VALUES ('jmartins', -1, -2, 0, 6);
INSERT INTO statistics VALUES ('ff', 1, 1, 0, 0);
INSERT INTO statistics VALUES ('up201405846', 2, 1, 0, 0);
INSERT INTO statistics VALUES ('super', 1, 1, 0, 0);
INSERT INTO statistics VALUES ('tt', 2, 1, 0, 0);
INSERT INTO statistics VALUES ('ralo', 0, 0, 0, 0);
INSERT INTO statistics VALUES ('oi', -3, 2, 0, 0);
INSERT INTO statistics VALUES ('up201404189@fe.up.pt', 1, 1, 0, 0);
INSERT INTO statistics VALUES ('up201404332@fe.up.pt', 1, 1, 0, 11);
INSERT INTO statistics VALUES ('lluismmartins7@gmail.com', 1, 1, 0, 0);
INSERT INTO statistics VALUES ('marcelo', 2, 5, 0, 11);
INSERT INTO statistics VALUES ('up201404332', 1, 2, 0, 0);


--
-- Data for Name: task; Type: TABLE DATA; Schema: final; Owner: lbaw1665
--

INSERT INTO task VALUES ('hehe', 'lindinho', '2017-04-27', 7, 'marcelo', 4, 'To-Do');
INSERT INTO task VALUES ('das', 'das', '2017-04-28', 26, 'jmartins', 7, 'Done');
INSERT INTO task VALUES ('Já Caguei!!', 'Hoje , após o almoço, fiz <h1> cocó</h1>. Estou feliz e sinto-me mais leve!', '2017-04-28', 18, 'teste', 7, 'Doing');
INSERT INTO task VALUES ('ola', ' teste update', '2017-05-05', 8, 'marcelo', 2, 'Doing');
INSERT INTO task VALUES ('Task1', '12312312312312312312312312312', '2017-04-27', 5, 'teste1234', 17, 'Doing');
INSERT INTO task VALUES ('Reclamar', 'Reclamar que não faço cocó já lá vão 5 dias', '2017-05-06', 12, 'teste', 7, 'Done');
INSERT INTO task VALUES ('Provar um iogurte', 'Provar um iogurte', '2017-05-05', 4, 'teste', 7, 'Done');
INSERT INTO task VALUES ('batatas', 'ola', '2017-04-28', 17, 'jmartins', 7, 'Done');
INSERT INTO task VALUES ('Teste333', 'BOLACHA
', '2017-05-03', 9, 'teste1234', 17, 'To-Do');
INSERT INTO task VALUES ('BATATATATAT', 'BATATATATATBATATA
Ola

Ola

TATATBATATATATATBATATATATAT', '2017-04-27', 11, 'teste1234', 17, 'To-Do');
INSERT INTO task VALUES ('para o joaozinho', ';)', '2017-04-28', 25, 'jmartins', 7, 'Doing');
INSERT INTO task VALUES ('O david é xiruu', 'asd', '2017-04-28', 27, 'oi', 22, 'To-Do');
INSERT INTO task VALUES ('ola', 'quero isto para amanha :p', '2017-05-01', 28, 'marcelo', 4, 'To-Do');
INSERT INTO task VALUES ('ola', 'dammm', '2017-05-01', 29, 'marcelo', 74, 'Doing');
INSERT INTO task VALUES ('ola', 'lindinho', '2017-05-04', 10, 'marcelo', 4, 'Done');
INSERT INTO task VALUES ('sadasd', 'sad', '2017-05-04', 30, 'teste', 13, 'To-Do');
INSERT INTO task VALUES ('sad', 'sadas', '2017-05-04', 31, 'teste', 13, 'To-Do');
INSERT INTO task VALUES ('10/10', 'qweqwe', '2017-06-03', 32, 'batatumarrebitado20', 76, 'To-Do');
INSERT INTO task VALUES ('oi', '', '2017-05-18', 34, 'up201404189@fe.up.pt', 80, 'To-Do');
INSERT INTO task VALUES ('Ola', 'ola
', '2017-05-18', 33, 'up201404332@fe.up.pt', 79, 'Doing');
INSERT INTO task VALUES ('O david é xiruu', ':wink:', '2017-04-28', 14, 'teste', 7, 'Doing');
INSERT INTO task VALUES ('Fernando Mendes', 'Qual o preco desta montra final', '2017-05-31', 43, 'teste', 7, 'To-Do');
INSERT INTO task VALUES ('Quim das Remisturas', 'Ehehehe', '2017-06-10', 44, 'teste', 7, 'To-Do');
INSERT INTO task VALUES ('Ave Maria', 'Ole', '2017-06-10', 45, 'teste', 7, 'To-Do');
INSERT INTO task VALUES ('O MEU NOME E TONE', 'daodaskopi', NULL, 47, 'teste', 7, 'To-Do');
INSERT INTO task VALUES ('25 de MAIO', 'Neste dia, choveu', NULL, 48, 'teste', 7, 'Doing');
INSERT INTO task VALUES ('nkn', '', '2017-05-25', 49, 'marcelo', 4, 'Doing');
INSERT INTO task VALUES ('oi', 'afdfas
', '2017-05-25', 50, 'lluismmartins7@gmail.com', 81, 'To-Do');
INSERT INTO task VALUES ('quintino aires', 'sda', '2017-03-29', 22, 'jmartins', 7, 'To-Do');
INSERT INTO task VALUES ('xiro', 'ads', '2017-04-28', 24, 'jmartins', 7, 'To-Do');
INSERT INTO task VALUES ('t1', 'oi ;)
', '2017-04-28', 16, 'jmartins', 7, 'To-Do');
INSERT INTO task VALUES ('ralo', 'dasdasd', '2017-05-25', 51, 'lluismmartins7@gmail.com', 81, 'To-Do');


--
-- Name: task_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1665
--

SELECT pg_catalog.setval('task_id_seq', 51, true);


--
-- Data for Name: topic; Type: TABLE DATA; Schema: final; Owner: lbaw1665
--

INSERT INTO topic VALUES (37, 'Enchidos', 22, NULL, 'project');
INSERT INTO topic VALUES (45, 'To-Do', 7, NULL, 'project');
INSERT INTO topic VALUES (51, 'O MEU NOME E TONE', NULL, 47, 'task');
INSERT INTO topic VALUES (52, '25 de MAIO', 7, 48, 'task');
INSERT INTO topic VALUES (53, 'nkn', 4, 49, 'task');
INSERT INTO topic VALUES (54, 'oi', 81, 50, 'task');
INSERT INTO topic VALUES (55, 'ralo', 81, 51, 'task');


--
-- Name: topic_id_seq; Type: SEQUENCE SET; Schema: final; Owner: lbaw1665
--

SELECT pg_catalog.setval('topic_id_seq', 55, true);


--
-- Data for Name: user; Type: TABLE DATA; Schema: final; Owner: lbaw1665
--

INSERT INTO "user" VALUES ('jmartins', 'jmartins@jmartins', '$2y$10$jA.NX0IZD84/OZPoVoKpfuC0sgeB2VIT8zJeGSS59MR3v.wT4JFCW', NULL);
INSERT INTO "user" VALUES ('marcelo', 'pount@sapo.pt', '$2y$10$HCoC7s5yKO.6mY15GlAOxOIEpKa5wk81BGMzCvqpEzChpHlq2avp2', NULL);
INSERT INTO "user" VALUES ('teste', 'teste@teste.teste', '$2y$10$NlOQmedOysYNSs4xUE3nbuBofBkWjg1NZzixipiMaLj5TOJJWkEga', NULL);
INSERT INTO "user" VALUES ('teste1234', 'teste1234@teste1234', '$2y$10$5XFt1h8CWI61QTDxXzm4weN78r8WAWzlB2r6b1xIpfW85U1f5gVqe', NULL);
INSERT INTO "user" VALUES ('oi', 'oi@oi', '$2y$10$xZf4eWG84v74n8e0kL/tse3fhHN0Qbw/dtMTvdllTL8QO.q/6OiK2', NULL);
INSERT INTO "user" VALUES ('tt', 'w@w', '$2y$10$DH3.5Y4fH0y4R0nhbNkQBOCQHhGtDXIPDagrZ2LN5/P.mh3zFTlf.', NULL);
INSERT INTO "user" VALUES ('ralo', 'a@a', '$2y$10$LQG9.wNgKckVe3IxfVqDHuyhNibE8pql5o6Gvo33wkTXXRfeccUBi', NULL);
INSERT INTO "user" VALUES ('oi1', 'O@O', '$2y$10$rDWlb4fJM3gYQ7wipDGQf.jfI4gNhvEfE1xM1bqnbVGDQkXgwlgzS', NULL);
INSERT INTO "user" VALUES ('david', 'david@email.internet', '$2y$10$yO1tw2VqLAd8ZP8SOcf0tuAj/FWuYZdgaXafmJDK5t23.TDrL8drO', NULL);
INSERT INTO "user" VALUES ('pepito', 'p@p', '$2y$10$ySZRQJADcai9Q/S3OHbSXuTQRx8hDIF2WKoCXc2LD7r5Se2ru27ze', NULL);
INSERT INTO "user" VALUES ('up201404332', 'pw', 'pw', NULL);
INSERT INTO "user" VALUES ('up201405846', 'up201405846@up201405846', 'pw', NULL);
INSERT INTO "user" VALUES ('up201404189', 'up201404189@up201404189', 'pw', NULL);
INSERT INTO "user" VALUES ('batatumarrebitado20', 'lol@lol.lol', '$2y$10$uPyCdUIoIm/unOuCVyPx1euorhTq4BF5uvOLrQtxrcb/NVyXNkSnC', NULL);
INSERT INTO "user" VALUES ('ff', '123123@1123.wd', '$2y$10$tUrOkmuyz3mi4MFNlVz.q.Un/.6.ScvYk1NwK1/qB5BSHDkbNq3wK', NULL);
INSERT INTO "user" VALUES ('upup201404332@fe.up.pt', 'upup201404332@fe.up.pt@upup201404332@fe.up.pt', 'pw', NULL);
INSERT INTO "user" VALUES ('up201404332@fe.up.pt', 'up201404332@fe.up.pt@up201404332@fe.up.pt', 'pw', NULL);
INSERT INTO "user" VALUES ('lluismmartins7@gmail.com', 'lluismmartins7@gmail.com', 'pw', 'José Martins');
INSERT INTO "user" VALUES ('super', 'super@nice.com', '$2y$10$eNt66U3Rdxag/wFdesbUgu5z9OFMUsQoIHCxQbpfRXuFtGGyu4wI.', 'super');
INSERT INTO "user" VALUES ('up201404189@fe.up.pt', 'up201404189@fe.up.pt', 'pw', 'Jos&eacute; Luis Pacheco Martins');


--
-- Name: User_email_key; Type: CONSTRAINT; Schema: final; Owner: lbaw1665; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT "User_email_key" UNIQUE (email);


--
-- Name: User_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1665; Tablespace: 
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (username);


--
-- Name: assigned_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1665; Tablespace: 
--

ALTER TABLE ONLY assigned
    ADD CONSTRAINT assigned_pkey PRIMARY KEY (username, task_id);


--
-- Name: category_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1665; Tablespace: 
--

ALTER TABLE ONLY category
    ADD CONSTRAINT category_pkey PRIMARY KEY (name);


--
-- Name: collaborators_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1665; Tablespace: 
--

ALTER TABLE ONLY collaborates
    ADD CONSTRAINT collaborators_pkey PRIMARY KEY (project_id, username);


--
-- Name: comment_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1665; Tablespace: 
--

ALTER TABLE ONLY comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (id);


--
-- Name: document_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1665; Tablespace: 
--

ALTER TABLE ONLY document
    ADD CONSTRAINT document_pkey PRIMARY KEY (id);


--
-- Name: folder_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1665; Tablespace: 
--

ALTER TABLE ONLY folder
    ADD CONSTRAINT folder_pkey PRIMARY KEY (id);


--
-- Name: folder_project_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1665; Tablespace: 
--

ALTER TABLE ONLY folder_project
    ADD CONSTRAINT folder_project_pkey PRIMARY KEY (project_id, folder_id);


--
-- Name: notification_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1665; Tablespace: 
--

ALTER TABLE ONLY notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- Name: post_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1665; Tablespace: 
--

ALTER TABLE ONLY post
    ADD CONSTRAINT post_pkey PRIMARY KEY (id);


--
-- Name: project_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1665; Tablespace: 
--

ALTER TABLE ONLY project
    ADD CONSTRAINT project_pkey PRIMARY KEY (id);


--
-- Name: statistics_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1665; Tablespace: 
--

ALTER TABLE ONLY statistics
    ADD CONSTRAINT statistics_pkey PRIMARY KEY (username);


--
-- Name: task_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1665; Tablespace: 
--

ALTER TABLE ONLY task
    ADD CONSTRAINT task_pkey PRIMARY KEY (id);


--
-- Name: topic_pkey; Type: CONSTRAINT; Schema: final; Owner: lbaw1665; Tablespace: 
--

ALTER TABLE ONLY topic
    ADD CONSTRAINT topic_pkey PRIMARY KEY (id);


CREATE INDEX idx_post_content ON post USING gin(to_tsvector('english',content));
CREATE INDEX idx_task_description ON task USING gist(to_tsvector('english',description));
CREATE INDEX idx_topic_title ON topic USING gin(to_tsvector('english',title));
CREATE INDEX idx_task_name ON task USING gin(to_tsvector('english',name));

--
-- Name: index_commenter_date; Type: INDEX; Schema: final; Owner: lbaw1665; Tablespace: 
--

CREATE INDEX index_commenter_date ON comment USING btree (date);


--
-- Name: index_notification_date; Type: INDEX; Schema: final; Owner: lbaw1665; Tablespace: 
--

CREATE INDEX index_notification_date ON notification USING btree (date);

ALTER TABLE notification CLUSTER ON index_notification_date;


--
-- Name: index_post_date; Type: INDEX; Schema: final; Owner: lbaw1665; Tablespace: 
--

CREATE INDEX index_post_date ON post USING btree (date);


--
-- Name: index_task_deadline; Type: INDEX; Schema: final; Owner: lbaw1665; Tablespace: 
--

CREATE INDEX index_task_deadline ON task USING btree (deadline);

ALTER TABLE task CLUSTER ON index_task_deadline;


--
-- Name: On_Delete; Type: TRIGGER; Schema: final; Owner: lbaw1665
--

CREATE TRIGGER "On_Delete" BEFORE DELETE ON folder FOR EACH ROW EXECUTE PROCEDURE delete_folder();


--
-- Name: On_Delete_Default; Type: TRIGGER; Schema: final; Owner: lbaw1665
--

CREATE TRIGGER "On_Delete_Default" BEFORE DELETE ON folder FOR EACH ROW EXECUTE PROCEDURE delete_folder_default();


--
-- Name: On_Insert; Type: TRIGGER; Schema: final; Owner: lbaw1665
--

CREATE TRIGGER "On_Insert" AFTER INSERT ON "user" FOR EACH ROW EXECUTE PROCEDURE insert_user();


--
-- Name: On_Insert; Type: TRIGGER; Schema: final; Owner: lbaw1665
--

CREATE TRIGGER "On_Insert" BEFORE INSERT ON folder_project FOR EACH ROW EXECUTE PROCEDURE insert_project_folder();


--
-- Name: On_Insert; Type: TRIGGER; Schema: final; Owner: lbaw1665
--

CREATE TRIGGER "On_Insert" AFTER INSERT ON collaborates FOR EACH ROW EXECUTE PROCEDURE insert_collaborates();


--
-- Name: On_Insert; Type: TRIGGER; Schema: final; Owner: lbaw1665
--

CREATE TRIGGER "On_Insert" BEFORE INSERT ON folder FOR EACH ROW EXECUTE PROCEDURE insert_folder();


--
-- Name: insert; Type: TRIGGER; Schema: final; Owner: lbaw1665
--

CREATE TRIGGER insert AFTER INSERT ON project FOR EACH ROW EXECUTE PROCEDURE insert_project();


--
-- Name: trigger_assigned_insert_update; Type: TRIGGER; Schema: final; Owner: lbaw1665
--

CREATE TRIGGER trigger_assigned_insert_update BEFORE INSERT OR UPDATE ON assigned FOR EACH ROW EXECUTE PROCEDURE insert_update_assigned();


--
-- Name: trigger_collaborates_delete; Type: TRIGGER; Schema: final; Owner: lbaw1665
--

CREATE TRIGGER trigger_collaborates_delete BEFORE DELETE ON collaborates FOR EACH ROW EXECUTE PROCEDURE delete_collaborates();


--
-- Name: trigger_comment_insert; Type: TRIGGER; Schema: final; Owner: lbaw1665
--

CREATE TRIGGER trigger_comment_insert BEFORE INSERT ON comment FOR EACH ROW EXECUTE PROCEDURE insert_comment();


--
-- Name: trigger_create_topic_on_insert; Type: TRIGGER; Schema: final; Owner: lbaw1665
--

CREATE TRIGGER trigger_create_topic_on_insert AFTER INSERT ON task FOR EACH ROW EXECUTE PROCEDURE insert_task_create_topic();


--
-- Name: trigger_document_insert; Type: TRIGGER; Schema: final; Owner: lbaw1665
--

CREATE TRIGGER trigger_document_insert BEFORE INSERT ON document FOR EACH ROW EXECUTE PROCEDURE insert_document();


--
-- Name: trigger_post_delete; Type: TRIGGER; Schema: final; Owner: lbaw1665
--

CREATE TRIGGER trigger_post_delete BEFORE DELETE ON post FOR EACH ROW EXECUTE PROCEDURE delete_comments();


--
-- Name: trigger_post_insert; Type: TRIGGER; Schema: final; Owner: lbaw1665
--

CREATE TRIGGER trigger_post_insert BEFORE INSERT ON post FOR EACH ROW EXECUTE PROCEDURE insert_post();


--
-- Name: trigger_project_delete; Type: TRIGGER; Schema: final; Owner: lbaw1665
--

CREATE TRIGGER trigger_project_delete BEFORE DELETE ON project FOR EACH ROW EXECUTE PROCEDURE delete_project_func();


--
-- Name: trigger_task_delete; Type: TRIGGER; Schema: final; Owner: lbaw1665
--

CREATE TRIGGER trigger_task_delete BEFORE DELETE ON task FOR EACH ROW EXECUTE PROCEDURE delete_task();


--
-- Name: trigger_task_insert; Type: TRIGGER; Schema: final; Owner: lbaw1665
--

CREATE TRIGGER trigger_task_insert BEFORE INSERT ON task FOR EACH ROW EXECUTE PROCEDURE insert_task();


--
-- Name: trigger_task_update; Type: TRIGGER; Schema: final; Owner: lbaw1665
--

CREATE TRIGGER trigger_task_update BEFORE UPDATE ON task FOR EACH ROW EXECUTE PROCEDURE update_task();


--
-- Name: trigger_topic_delete; Type: TRIGGER; Schema: final; Owner: lbaw1665
--

CREATE TRIGGER trigger_topic_delete BEFORE DELETE ON topic FOR EACH ROW EXECUTE PROCEDURE delete_topic();


--
-- Name: assigned_task_id_fkey; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1665
--

ALTER TABLE ONLY assigned
    ADD CONSTRAINT assigned_task_id_fkey FOREIGN KEY (task_id) REFERENCES task(id);


--
-- Name: assigned_username_fkey; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1665
--

ALTER TABLE ONLY assigned
    ADD CONSTRAINT assigned_username_fkey FOREIGN KEY (username) REFERENCES "user"(username);


--
-- Name: collaborates_project_id_fkey; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1665
--

ALTER TABLE ONLY collaborates
    ADD CONSTRAINT collaborates_project_id_fkey FOREIGN KEY (project_id) REFERENCES project(id);


--
-- Name: collaborators_username_fkey; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1665
--

ALTER TABLE ONLY collaborates
    ADD CONSTRAINT collaborators_username_fkey FOREIGN KEY (username) REFERENCES "user"(username);


--
-- Name: comment_commenter_fkey; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1665
--

ALTER TABLE ONLY comment
    ADD CONSTRAINT comment_commenter_fkey FOREIGN KEY (commenter) REFERENCES "user"(username);


--
-- Name: comment_post_id_fkey; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1665
--

ALTER TABLE ONLY comment
    ADD CONSTRAINT comment_post_id_fkey FOREIGN KEY (post_id) REFERENCES post(id);


--
-- Name: document_project_id_fkey; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1665
--

ALTER TABLE ONLY document
    ADD CONSTRAINT document_project_id_fkey FOREIGN KEY (project_id) REFERENCES project(id);


--
-- Name: folder_project_folder_id_fkey; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1665
--

ALTER TABLE ONLY folder_project
    ADD CONSTRAINT folder_project_folder_id_fkey FOREIGN KEY (folder_id) REFERENCES folder(id);


--
-- Name: folder_project_project_id_fkey; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1665
--

ALTER TABLE ONLY folder_project
    ADD CONSTRAINT folder_project_project_id_fkey FOREIGN KEY (project_id) REFERENCES project(id);


--
-- Name: folder_username_fkey; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1665
--

ALTER TABLE ONLY folder
    ADD CONSTRAINT folder_username_fkey FOREIGN KEY (username) REFERENCES "user"(username);


--
-- Name: notification_associated_fkey; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1665
--

ALTER TABLE ONLY notification
    ADD CONSTRAINT notification_associated_fkey FOREIGN KEY (associated) REFERENCES "user"(username);


--
-- Name: notification_notificated_fkey; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1665
--

ALTER TABLE ONLY notification
    ADD CONSTRAINT notification_notificated_fkey FOREIGN KEY (notificated) REFERENCES "user"(username);


--
-- Name: notification_project_id_fkey; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1665
--

ALTER TABLE ONLY notification
    ADD CONSTRAINT notification_project_id_fkey FOREIGN KEY (project_id) REFERENCES project(id);


--
-- Name: post_poster_fkey; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1665
--

ALTER TABLE ONLY post
    ADD CONSTRAINT post_poster_fkey FOREIGN KEY (poster) REFERENCES "user"(username);


--
-- Name: post_topic_id_fkey; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1665
--

ALTER TABLE ONLY post
    ADD CONSTRAINT post_topic_id_fkey FOREIGN KEY (topic_id) REFERENCES topic(id);


--
-- Name: project_manager_fkey; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1665
--

ALTER TABLE ONLY project
    ADD CONSTRAINT project_manager_fkey FOREIGN KEY (manager) REFERENCES "user"(username);


--
-- Name: statistics_user_id_fkey; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1665
--

ALTER TABLE ONLY statistics
    ADD CONSTRAINT statistics_user_id_fkey FOREIGN KEY (username) REFERENCES "user"(username);


--
-- Name: task_category_fkey; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1665
--

ALTER TABLE ONLY task
    ADD CONSTRAINT task_category_fkey FOREIGN KEY (category) REFERENCES category(name);


--
-- Name: task_owner_fkey; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1665
--

ALTER TABLE ONLY task
    ADD CONSTRAINT task_owner_fkey FOREIGN KEY (owner) REFERENCES "user"(username);


--
-- Name: task_project_id_fkey; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1665
--

ALTER TABLE ONLY task
    ADD CONSTRAINT task_project_id_fkey FOREIGN KEY (project_id) REFERENCES project(id);


--
-- Name: topic_project_id_fkey; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1665
--

ALTER TABLE ONLY topic
    ADD CONSTRAINT topic_project_id_fkey FOREIGN KEY (project_id) REFERENCES project(id);


--
-- Name: topic_task_id_fkey; Type: FK CONSTRAINT; Schema: final; Owner: lbaw1665
--

ALTER TABLE ONLY topic
    ADD CONSTRAINT topic_task_id_fkey FOREIGN KEY (task_id) REFERENCES task(id);


--
-- Name: final; Type: ACL; Schema: -; Owner: lbaw1665
--

REVOKE ALL ON SCHEMA final FROM PUBLIC;
REVOKE ALL ON SCHEMA final FROM lbaw1665;
GRANT ALL ON SCHEMA final TO lbaw1665;


--
-- PostgreSQL database dump complete
--

