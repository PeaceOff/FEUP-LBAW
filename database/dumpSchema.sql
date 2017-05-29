--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = final, pg_catalog;

ALTER TABLE ONLY final.topic DROP CONSTRAINT topic_task_id_fkey;
ALTER TABLE ONLY final.topic DROP CONSTRAINT topic_project_id_fkey;
ALTER TABLE ONLY final.task DROP CONSTRAINT task_project_id_fkey;
ALTER TABLE ONLY final.task DROP CONSTRAINT task_owner_fkey;
ALTER TABLE ONLY final.task DROP CONSTRAINT task_category_fkey;
ALTER TABLE ONLY final.statistics DROP CONSTRAINT statistics_user_id_fkey;
ALTER TABLE ONLY final.project DROP CONSTRAINT project_manager_fkey;
ALTER TABLE ONLY final.post DROP CONSTRAINT post_topic_id_fkey;
ALTER TABLE ONLY final.post DROP CONSTRAINT post_poster_fkey;
ALTER TABLE ONLY final.notification DROP CONSTRAINT notification_project_id_fkey;
ALTER TABLE ONLY final.notification DROP CONSTRAINT notification_notificated_fkey;
ALTER TABLE ONLY final.notification DROP CONSTRAINT notification_associated_fkey;
ALTER TABLE ONLY final.folder DROP CONSTRAINT folder_username_fkey;
ALTER TABLE ONLY final.folder_project DROP CONSTRAINT folder_project_project_id_fkey;
ALTER TABLE ONLY final.folder_project DROP CONSTRAINT folder_project_folder_id_fkey;
ALTER TABLE ONLY final.document DROP CONSTRAINT document_project_id_fkey;
ALTER TABLE ONLY final.comment DROP CONSTRAINT comment_post_id_fkey;
ALTER TABLE ONLY final.comment DROP CONSTRAINT comment_commenter_fkey;
ALTER TABLE ONLY final.collaborates DROP CONSTRAINT collaborators_username_fkey;
ALTER TABLE ONLY final.collaborates DROP CONSTRAINT collaborates_project_id_fkey;
ALTER TABLE ONLY final.assigned DROP CONSTRAINT assigned_username_fkey;
ALTER TABLE ONLY final.assigned DROP CONSTRAINT assigned_task_id_fkey;
DROP TRIGGER trigger_topic_delete ON final.topic;
DROP TRIGGER trigger_task_update ON final.task;
DROP TRIGGER trigger_task_insert ON final.task;
DROP TRIGGER trigger_task_delete ON final.task;
DROP TRIGGER trigger_project_delete ON final.project;
DROP TRIGGER trigger_post_insert ON final.post;
DROP TRIGGER trigger_post_delete ON final.post;
DROP TRIGGER trigger_document_insert ON final.document;
DROP TRIGGER trigger_create_topic_on_insert ON final.task;
DROP TRIGGER trigger_comment_insert ON final.comment;
DROP TRIGGER trigger_collaborates_delete ON final.collaborates;
DROP TRIGGER trigger_assigned_insert_update ON final.assigned;
DROP TRIGGER trigger_assigned_delete ON final.assigned;
DROP TRIGGER insert ON final.project;
DROP TRIGGER "On_Insert" ON final.folder;
DROP TRIGGER "On_Insert" ON final.collaborates;
DROP TRIGGER "On_Insert" ON final.folder_project;
DROP TRIGGER "On_Insert" ON final."user";
DROP TRIGGER "On_Delete_Default" ON final.folder;
DROP TRIGGER "On_Delete" ON final.folder;
DROP INDEX final.index_task_deadline;
DROP INDEX final.index_post_date;
DROP INDEX final.index_notification_date;
DROP INDEX final.index_commenter_date;
DROP INDEX final.idx_topic_title;
DROP INDEX final.idx_task_name;
DROP INDEX final.idx_task_description;
DROP INDEX final.idx_post_content;
ALTER TABLE ONLY final.topic DROP CONSTRAINT topic_pkey;
ALTER TABLE ONLY final.task DROP CONSTRAINT task_pkey;
ALTER TABLE ONLY final.statistics DROP CONSTRAINT statistics_pkey;
ALTER TABLE ONLY final.project DROP CONSTRAINT project_pkey;
ALTER TABLE ONLY final.post DROP CONSTRAINT post_pkey;
ALTER TABLE ONLY final.notification DROP CONSTRAINT notification_pkey;
ALTER TABLE ONLY final.folder_project DROP CONSTRAINT folder_project_pkey;
ALTER TABLE ONLY final.folder DROP CONSTRAINT folder_pkey;
ALTER TABLE ONLY final.document DROP CONSTRAINT document_pkey;
ALTER TABLE ONLY final.comment DROP CONSTRAINT comment_pkey;
ALTER TABLE ONLY final.collaborates DROP CONSTRAINT collaborators_pkey;
ALTER TABLE ONLY final.category DROP CONSTRAINT category_pkey;
ALTER TABLE ONLY final.assigned DROP CONSTRAINT assigned_pkey;
ALTER TABLE ONLY final."user" DROP CONSTRAINT "User_pkey";
ALTER TABLE ONLY final."user" DROP CONSTRAINT "User_email_key";
DROP VIEW final.view_project_folder;
DROP VIEW final.view_project_collabs;
DROP TABLE final."user";
DROP TABLE final.task;
DROP SEQUENCE final.task_id_seq;
DROP TABLE final.statistics;
DROP VIEW final.search_fields;
DROP TABLE final.topic;
DROP SEQUENCE final.topic_id_seq;
DROP TABLE final.project;
DROP SEQUENCE final.project_id_seq;
DROP TABLE final.post;
DROP SEQUENCE final.post_id_seq;
DROP TABLE final.notification;
DROP SEQUENCE final.notification_id_seq;
DROP TABLE final.folder_project;
DROP TABLE final.folder;
DROP SEQUENCE final.folder_id_seq;
DROP TABLE final.document;
DROP SEQUENCE final.document_id_seq;
DROP TABLE final.comment;
DROP SEQUENCE final.comment_id_seq;
DROP TABLE final.collaborates;
DROP TABLE final.category;
DROP TABLE final.assigned;
DROP FUNCTION final.update_task();
DROP FUNCTION final.insert_user();
DROP FUNCTION final.insert_update_assigned();
DROP FUNCTION final.insert_task_create_topic();
DROP FUNCTION final.insert_task();
DROP FUNCTION final.insert_project_folder();
DROP FUNCTION final.insert_project();
DROP FUNCTION final.insert_post();
DROP FUNCTION final.insert_folder();
DROP FUNCTION final.insert_document();
DROP FUNCTION final.insert_comment();
DROP FUNCTION final.insert_collaborates();
DROP FUNCTION final.delete_topic();
DROP FUNCTION final.delete_task();
DROP FUNCTION final.delete_project_func();
DROP FUNCTION final.delete_folder_default();
DROP FUNCTION final.delete_folder();
DROP FUNCTION final.delete_comments();
DROP FUNCTION final.delete_collaborates();
DROP FUNCTION final.delete_assigned();
DROP SCHEMA final;
--
-- Name: final; Type: SCHEMA; Schema: -; Owner: lbaw1665
--

CREATE SCHEMA final;


ALTER SCHEMA final OWNER TO lbaw1665;

SET search_path = final, pg_catalog;

--
-- Name: delete_assigned(); Type: FUNCTION; Schema: final; Owner: lbaw1665
--

CREATE FUNCTION delete_assigned() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

 num_tasks numeric;

 message TEXT;

 r_proj project%rowtype;


BEGIN


    SELECT * FROM INTO r_proj project WHERE id = (SELECT project_id FROM task WHERE id = OLD.task_id);
    message := 'You have been deassigned from task ' || (SELECT name FROM task WHERE id = OLD.task_id) || ' in project ' || r_proj.name;

    INSERT INTO notification (description, date, project_id, notificated, type, associated)

            VALUES(message , CURRENT_DATE, r_proj.id , OLD.username, 'Information' , NULL);

 

    IF EXISTS (SELECT 1 FROM statistics WHERE username = OLD.username) AND (SELECT category FROM task WHERE id = OLD.task_id) != 'Done' THEN

      num_tasks = (SELECT task_unfinished_number - 1 FROM statistics WHERE username = OLD.username);
     
      UPDATE statistics SET task_unfinished_number = num_tasks WHERE username = OLD.username;

    END IF;

  IF EXISTS (SELECT 1 FROM statistics WHERE username = OLD.username) AND (SELECT category FROM task WHERE id = OLD.task_id) = 'Done' 
   THEN

      num_tasks = (SELECT task_finished_number - 1 FROM statistics WHERE username = OLD.username);
     
      UPDATE statistics SET task_finished_number = num_tasks WHERE username = OLD.username;

    END IF;

    RETURN OLD;


END$$;


ALTER FUNCTION final.delete_assigned() OWNER TO lbaw1665;

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
    AS $$

BEGIN
    


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

   temp_string := 'Added Document ' || NEW.name || ' to project ' || (SELECT name FROM project WHERE id = NEW.project_id);

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

 num_tasks numeric;

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
     IF (SELECT category FROM task WHERE id = NEW.task_id) != 'Done' THEN

      num_tasks = (SELECT task_unfinished_number + 1 FROM statistics WHERE username = NEW.username);
     
      UPDATE statistics SET task_unfinished_number = num_tasks WHERE username = NEW.username;

     ELSE 
      num_tasks = (SELECT task_finished_number + 1 FROM statistics WHERE username = NEW.username);
     
      UPDATE statistics SET task_finished_number = num_tasks WHERE username = NEW.username;

    END IF;
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

 
   INSERT INTO statistics VALUES (NEW.username,0,0,0,0);

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

   finished_tasks numeric;
   
   unfinished_tasks numeric;
   
   r_collab collaborates%rowtype;
   
   r_assigned assigned%rowtype;

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



 IF NEW.category = 'Done' AND OLD.category != 'Done'  THEN
  
  FOR r_assigned IN SELECT *

               FROM assigned

               WHERE task_id = NEW.id

   LOOP
    
       IF EXISTS (SELECT 1 FROM statistics WHERE username = r_assigned.username) THEN

        finished_tasks = (SELECT task_finished_number + 1 FROM statistics WHERE username = r_assigned.username);
        unfinished_tasks = (SELECT task_unfinished_number - 1 FROM statistics WHERE username = r_assigned.username);
     
        UPDATE statistics SET task_finished_number = finished_tasks , task_unfinished_number = unfinished_tasks WHERE username = r_assigned.username;

       END IF;
   END LOOP;

  ELSIF NEW.category != 'Done' AND OLD.category = 'Done'  THEN
     FOR r_assigned IN SELECT *

               FROM assigned

               WHERE task_id = NEW.id

      LOOP
    
       IF EXISTS (SELECT 1 FROM statistics WHERE username = r_assigned.username) THEN

        finished_tasks = (SELECT task_finished_number - 1 FROM statistics WHERE username = r_assigned.username);
        unfinished_tasks = (SELECT task_unfinished_number + 1 FROM statistics WHERE username = r_assigned.username);
     
        UPDATE statistics SET task_finished_number = finished_tasks , task_unfinished_number = unfinished_tasks WHERE username = r_assigned.username;

         END IF;
      END LOOP;
    END IF;

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


--
-- Name: idx_post_content; Type: INDEX; Schema: final; Owner: lbaw1665; Tablespace: 
--

CREATE INDEX idx_post_content ON post USING gin (to_tsvector('english'::regconfig, (content)::text));


--
-- Name: idx_task_description; Type: INDEX; Schema: final; Owner: lbaw1665; Tablespace: 
--

CREATE INDEX idx_task_description ON task USING gist (to_tsvector('english'::regconfig, description));


--
-- Name: idx_task_name; Type: INDEX; Schema: final; Owner: lbaw1665; Tablespace: 
--

CREATE INDEX idx_task_name ON task USING gin (to_tsvector('english'::regconfig, (name)::text));


--
-- Name: idx_topic_title; Type: INDEX; Schema: final; Owner: lbaw1665; Tablespace: 
--

CREATE INDEX idx_topic_title ON topic USING gin (to_tsvector('english'::regconfig, (title)::text));


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
-- Name: trigger_assigned_delete; Type: TRIGGER; Schema: final; Owner: lbaw1665
--

CREATE TRIGGER trigger_assigned_delete BEFORE DELETE ON assigned FOR EACH ROW EXECUTE PROCEDURE delete_assigned();


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

