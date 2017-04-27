
SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = proto, pg_catalog;

ALTER TABLE ONLY proto.topic DROP CONSTRAINT topic_task_id_fkey;
ALTER TABLE ONLY proto.topic DROP CONSTRAINT topic_project_id_fkey;
ALTER TABLE ONLY proto.task DROP CONSTRAINT task_project_id_fkey;
ALTER TABLE ONLY proto.task DROP CONSTRAINT task_owner_fkey;
ALTER TABLE ONLY proto.task DROP CONSTRAINT task_category_fkey;
ALTER TABLE ONLY proto.project DROP CONSTRAINT project_manager_fkey;
ALTER TABLE ONLY proto.post DROP CONSTRAINT post_topic_id_fkey;
ALTER TABLE ONLY proto.post DROP CONSTRAINT post_poster_fkey;
ALTER TABLE ONLY proto.notification DROP CONSTRAINT notification_project_id_fkey;
ALTER TABLE ONLY proto.notification DROP CONSTRAINT notification_notificated_fkey;
ALTER TABLE ONLY proto.notification DROP CONSTRAINT notification_associated_fkey;
ALTER TABLE ONLY proto.folder DROP CONSTRAINT folder_username_fkey;
ALTER TABLE ONLY proto.folder_project DROP CONSTRAINT folder_project_project_id_fkey;
ALTER TABLE ONLY proto.folder_project DROP CONSTRAINT folder_project_folder_id_fkey;
ALTER TABLE ONLY proto.document DROP CONSTRAINT document_project_id_fkey;
ALTER TABLE ONLY proto.comment DROP CONSTRAINT comment_post_id_fkey;
ALTER TABLE ONLY proto.comment DROP CONSTRAINT comment_commenter_fkey;
ALTER TABLE ONLY proto.collaborates DROP CONSTRAINT collaborators_username_fkey;
ALTER TABLE ONLY proto.collaborates DROP CONSTRAINT collaborates_project_id_fkey;
ALTER TABLE ONLY proto.assigned DROP CONSTRAINT assigned_username_fkey;
ALTER TABLE ONLY proto.assigned DROP CONSTRAINT assigned_task_id_fkey;
DROP TRIGGER trigger_topic_delete ON proto.topic;
DROP TRIGGER trigger_task_update ON proto.task;
DROP TRIGGER trigger_task_insert ON proto.task;
DROP TRIGGER trigger_task_delete ON proto.task;
DROP TRIGGER trigger_project_delete ON proto.project;
DROP TRIGGER trigger_post_insert ON proto.post;
DROP TRIGGER trigger_post_delete ON proto.post;
DROP TRIGGER trigger_document_insert ON proto.document;
DROP TRIGGER trigger_comment_insert ON proto.comment;
DROP TRIGGER trigger_collaborates_delete ON proto.collaborates;
DROP TRIGGER trigger_assigned_insert_update ON proto.assigned;
DROP TRIGGER insert ON proto.project;
DROP TRIGGER "On_Insert" ON proto.collaborates;
DROP TRIGGER "On_Insert" ON proto.folder_project;
DROP TRIGGER "On_Insert" ON proto."user";
DROP TRIGGER "On_Delete_Default" ON proto.folder;
DROP TRIGGER "On_Delete" ON proto.folder;
DROP INDEX proto.index_task_deadline;
DROP INDEX proto.index_post_date;
DROP INDEX proto.index_notification_date;
DROP INDEX proto.index_commenter_date;
ALTER TABLE ONLY proto.topic DROP CONSTRAINT topic_pkey;
ALTER TABLE ONLY proto.task DROP CONSTRAINT task_pkey;
ALTER TABLE ONLY proto.project DROP CONSTRAINT project_pkey;
ALTER TABLE ONLY proto.post DROP CONSTRAINT post_pkey;
ALTER TABLE ONLY proto.notification DROP CONSTRAINT notification_pkey;
ALTER TABLE ONLY proto.folder_project DROP CONSTRAINT folder_project_pkey;
ALTER TABLE ONLY proto.folder DROP CONSTRAINT folder_pkey;
ALTER TABLE ONLY proto.document DROP CONSTRAINT document_pkey;
ALTER TABLE ONLY proto.comment DROP CONSTRAINT comment_pkey;
ALTER TABLE ONLY proto.collaborates DROP CONSTRAINT collaborators_pkey;
ALTER TABLE ONLY proto.category DROP CONSTRAINT category_pkey;
ALTER TABLE ONLY proto.assigned DROP CONSTRAINT assigned_pkey;
ALTER TABLE ONLY proto."user" DROP CONSTRAINT "User_pkey";
ALTER TABLE ONLY proto."user" DROP CONSTRAINT "User_email_key";
DROP VIEW proto.view_project_folder;
DROP VIEW proto.view_project_collabs;
DROP TABLE proto."user";
DROP TABLE proto.task;
DROP SEQUENCE proto.task_id_seq;
DROP VIEW proto.search_fields;
DROP TABLE proto.topic;
DROP SEQUENCE proto.topic_id_seq;
DROP TABLE proto.project;
DROP SEQUENCE proto.project_id_seq;
DROP TABLE proto.post;
DROP SEQUENCE proto.post_id_seq;
DROP TABLE proto.notification;
DROP SEQUENCE proto.notification_id_seq;
DROP TABLE proto.folder_project;
DROP TABLE proto.folder;
DROP SEQUENCE proto.folder_id_seq;
DROP TABLE proto.document;
DROP SEQUENCE proto.document_id_seq;
DROP TABLE proto.comment;
DROP SEQUENCE proto.comment_id_seq;
DROP TABLE proto.collaborates;
DROP TABLE proto.category;
DROP TABLE proto.assigned;
DROP FUNCTION proto.update_task();
DROP FUNCTION proto.insert_user();
DROP FUNCTION proto.insert_update_assigned();
DROP FUNCTION proto.insert_task();
DROP FUNCTION proto.insert_project_folder();
DROP FUNCTION proto.insert_project();
DROP FUNCTION proto.insert_post();
DROP FUNCTION proto.insert_document();
DROP FUNCTION proto.insert_comment();
DROP FUNCTION proto.insert_collaborates();
DROP FUNCTION proto.delete_topic();
DROP FUNCTION proto.delete_task();
DROP FUNCTION proto.delete_project_func();
DROP FUNCTION proto.delete_folder_default();
DROP FUNCTION proto.delete_folder();
DROP FUNCTION proto.delete_comments();
DROP FUNCTION proto.delete_collaborates();
DROP SCHEMA proto;

CREATE SCHEMA proto;


ALTER SCHEMA proto OWNER TO lbaw1665;

SET search_path = proto, pg_catalog;


CREATE FUNCTION delete_collaborates() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

  folderID numeric;

BEGIN
   folderID=(SELECT folder.id FROM folder_project, folder WHERE folder.username=OLD.username AND folder_project.folder_id = folder.id AND folder_project.project_id = OLD.project_id);

   DELETE FROM folder_project WHERE project_id = OLD.project_id AND folder_id = folderID;
   RETURN OLD;
END$$;


ALTER FUNCTION proto.delete_collaborates() OWNER TO lbaw1665;


CREATE FUNCTION delete_comments() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

   DELETE FROM comment

      WHERE post_id = OLD.id;

   RETURN OLD;

END;$$;


ALTER FUNCTION proto.delete_comments() OWNER TO lbaw1665;


COMMENT ON FUNCTION delete_comments() IS 'Funcao que apaga um comentario de um post';



CREATE FUNCTION delete_folder() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

  f_project folder_project%rowtype;

BEGIN

    FOR f_project IN

    SELECT * FROM folder_project

    WHERE folder_id = OLD.id

    LOOP

        BEGIN

           DELETE FROM folder_project

           WHERE folder_id = f_project.folder_id AND project_id = f_project.project_id;

           DELETE FROM project

           WHERE manager = OLD.username AND id = f_project.project_id;

           DELETE FROM collaborates

           WHERE project_id = f_project.project_id AND username = OLD.username;

        END;

    END LOOP;

    RETURN OLD;

END;$$;


ALTER FUNCTION proto.delete_folder() OWNER TO lbaw1665;


COMMENT ON FUNCTION delete_folder() IS 'Funcao que apaga uma pasta';



CREATE FUNCTION delete_folder_default() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

   IF OLD.name = 'DEFAULT'

   THEN RETURN NULL;

   ELSE RETURN OLD;

   END IF;

END;$$;


ALTER FUNCTION proto.delete_folder_default() OWNER TO lbaw1665;


COMMENT ON FUNCTION delete_folder_default() IS 'Funcao que nao deixa apagar a folder default do utilizador';



CREATE FUNCTION delete_project_func() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

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


ALTER FUNCTION proto.delete_project_func() OWNER TO lbaw1665;


CREATE FUNCTION delete_task() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

   DELETE FROM topic WHERE task_id = OLD.id;

   DELETE FROM assigned WHERE task_id = OLD.id;

   RETURN OLD;

END$$;


ALTER FUNCTION proto.delete_task() OWNER TO lbaw1665;


CREATE FUNCTION delete_topic() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

   DELETE FROM post WHERE post.topic_id = OLD.id;

   RETURN OLD;

END$$;


ALTER FUNCTION proto.delete_topic() OWNER TO lbaw1665;


CREATE FUNCTION insert_collaborates() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

  folderID numeric;

BEGIN

  folderID = (SELECT id FROM folder WHERE name = 'DEFAULT' AND username = NEW.username);

  INSERT INTO folder_project VALUES (NEW.project_id,folderID);

  RETURN NEW;

END;$$;


ALTER FUNCTION proto.insert_collaborates() OWNER TO lbaw1665;


COMMENT ON FUNCTION insert_collaborates() IS 'Funcao que adiciona um projecto a pasta de default do utilizador quando este e adicionado como colaborador do projeto';



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

   temp_string := NEW.commenter || 'COMMENTED ON YOUR POST AT:' || (SELECT name FROM project WHERE id = project__id)|| '/' ||(SELECT title FROM topic WHERE id = topic__id);

  INSERT INTO notification (description, date, project_id, notificated, type, associated)

    VALUES(temp_string, '2001-12-13', project__id, (SELECT poster FROM post WHERE NEW.post_id = id), 'Information' ,NEW.commenter);

   RETURN NEW;

END$$;


ALTER FUNCTION proto.insert_comment() OWNER TO lbaw1665;


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

            VALUES(temp_string, '2001-12-13', NEW.project_id, r_collab.username, 'Information' , NULL);

   END LOOP;

   RETURN NEW;

END$$;


ALTER FUNCTION proto.insert_document() OWNER TO lbaw1665;


COMMENT ON FUNCTION insert_document() IS 'Sends notification when the project is updated';



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

   temp_string := 'ADDED POST:' || (SELECT name FROM project WHERE id = project__id)|| '/' ||(SELECT title FROM topic WHERE id = NEW.topic_id);

   FOR r_collab IN SELECT *

               FROM collaborates

               WHERE project_id = project__id

   LOOP

         INSERT INTO notification (description, date, project_id, notificated, type, associated)

            VALUES(temp_string, '2001-12-13', project__id, r_collab.username, 'Information' , NEW.poster);

   END LOOP;

   RETURN NEW;

END

$$;


ALTER FUNCTION proto.insert_post() OWNER TO lbaw1665;


CREATE FUNCTION insert_project() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

    INSERT INTO collaborates

    VALUES (NEW.id,NEW.manager);

    RETURN NEW;

END;

$$;


ALTER FUNCTION proto.insert_project() OWNER TO lbaw1665;


COMMENT ON FUNCTION insert_project() IS 'Trigger para inserir o manager de um projecto como colaborador';



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


ALTER FUNCTION proto.insert_project_folder() OWNER TO lbaw1665;


COMMENT ON FUNCTION insert_project_folder() IS 'Verifica se o utilizador da pasta colabora no projeto';



CREATE FUNCTION insert_task() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

   r_collab collaborates%rowtype;

   message TEXT;

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

            VALUES(message , '2001-12-13', NEW.project_id, r_collab.username, 'Information' , NEW.owner);

      END IF;

   END LOOP;

   RETURN NEW;

END$$;


ALTER FUNCTION proto.insert_task() OWNER TO lbaw1665;


CREATE FUNCTION insert_update_assigned() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

   IF

      EXISTS(

         SELECT project_id

            FROM

               collaborates

            WHERE

               username = NEW.username

               AND project_id IN (SELECT project_id

                                     FROM task WHERE id = NEW.task_id)) THEN

   RETURN NEW;

   END IF;

   RETURN NULL;

END$$;


ALTER FUNCTION proto.insert_update_assigned() OWNER TO lbaw1665;


CREATE FUNCTION insert_user() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN

   INSERT INTO folder(name,username)

   VALUES ('DEFAULT',NEW.username);

   RETURN NEW;

END;$$;


ALTER FUNCTION proto.insert_user() OWNER TO lbaw1665;


COMMENT ON FUNCTION insert_user() IS 'Funcao para criar a pasta DEFAULT a um novo user';



CREATE FUNCTION update_task() RETURNS trigger
    LANGUAGE plpgsql
    AS $$DECLARE

   r_collab collaborates%rowtype;

   temp_string TEXT;

BEGIN

   IF NEW.category = OLD.category THEN

      RETURN NULL;

   END IF;

   temp_string := 'TASK:' || (SELECT name FROM project WHERE id = NEW.project_id) || '/' || NEW.name || ' Changed Category To:' || NEW.category;

   FOR r_collab IN SELECT *

               FROM collaborates

               WHERE project_id = NEW.project_id

   LOOP

      IF NEW.owner != r_collab.username THEN

         INSERT INTO notification (description, date, project_id, notificated, type, associated)

            VALUES(temp_string, '2001-12-13', NEW.project_id, r_collab.username, 'Information' , NULL);

      END IF;

   END LOOP;

   RETURN NEW;

END$$;


ALTER FUNCTION proto.update_task() OWNER TO lbaw1665;

SET default_tablespace = '';

SET default_with_oids = false;


CREATE TABLE assigned (
    username character varying NOT NULL,
    task_id numeric NOT NULL
);



CREATE TABLE category (
    name character varying NOT NULL
);




CREATE TABLE collaborates (
    project_id numeric NOT NULL,
    username character varying NOT NULL
);




CREATE SEQUENCE comment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




CREATE TABLE comment (
    message character varying NOT NULL,
    date date,
    post_id numeric NOT NULL,
    commenter character varying NOT NULL,
    id numeric DEFAULT nextval('comment_id_seq'::regclass) NOT NULL
);




CREATE SEQUENCE document_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




CREATE TABLE document (
    name character varying NOT NULL,
    description character varying,
    type character varying NOT NULL,
    path character varying,
    project_id numeric NOT NULL,
    id numeric DEFAULT nextval('document_id_seq'::regclass) NOT NULL,
    CONSTRAINT "definedType" CHECK ((((type)::text = 'Document'::text) OR ((type)::text = 'Link'::text)))
);




CREATE SEQUENCE folder_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




CREATE TABLE folder (
    name character varying NOT NULL,
    username character varying NOT NULL,
    id numeric DEFAULT nextval('folder_id_seq'::regclass) NOT NULL
);




CREATE TABLE folder_project (
    project_id numeric NOT NULL,
    folder_id numeric NOT NULL
);




CREATE SEQUENCE notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




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




CREATE SEQUENCE post_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




CREATE TABLE post (
    content character varying,
    date date,
    topic_id numeric NOT NULL,
    poster character varying NOT NULL,
    id numeric DEFAULT nextval('post_id_seq'::regclass) NOT NULL
);




CREATE SEQUENCE project_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




CREATE TABLE project (
    name character varying NOT NULL,
    description text,
    deadline date,
    manager character varying NOT NULL,
    id numeric DEFAULT nextval('project_id_seq'::regclass) NOT NULL
);




CREATE SEQUENCE topic_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;




CREATE TABLE topic (
    id numeric DEFAULT nextval('topic_id_seq'::regclass) NOT NULL,
    title character varying NOT NULL,
    project_id numeric,
    task_id numeric,
    type character varying NOT NULL,
    CONSTRAINT task_reference_chk CHECK ((((task_id IS NULL) AND (project_id IS NOT NULL)) OR ((task_id IS NOT NULL) AND (project_id IS NULL)))),
    CONSTRAINT task_type_chk CHECK ((((task_id IS NOT NULL) AND ((type)::text = 'task'::text)) OR ((project_id IS NOT NULL) AND ((type)::text = 'project'::text))))
);




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




CREATE SEQUENCE task_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



CREATE TABLE task (
    name character varying NOT NULL,
    description text,
    deadline date,
    id numeric DEFAULT nextval('task_id_seq'::regclass) NOT NULL,
    owner character varying NOT NULL,
    project_id numeric NOT NULL,
    category character varying NOT NULL
);




CREATE TABLE "user" (
    username character varying NOT NULL,
    email character varying NOT NULL,
    password character varying NOT NULL
);




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




ALTER TABLE ONLY "user"
    ADD CONSTRAINT "User_email_key" UNIQUE (email);



ALTER TABLE ONLY "user"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (username);



ALTER TABLE ONLY assigned
    ADD CONSTRAINT assigned_pkey PRIMARY KEY (username, task_id);



ALTER TABLE ONLY category
    ADD CONSTRAINT category_pkey PRIMARY KEY (name);



ALTER TABLE ONLY collaborates
    ADD CONSTRAINT collaborators_pkey PRIMARY KEY (project_id, username);



ALTER TABLE ONLY comment
    ADD CONSTRAINT comment_pkey PRIMARY KEY (id);



ALTER TABLE ONLY document
    ADD CONSTRAINT document_pkey PRIMARY KEY (id);



ALTER TABLE ONLY folder
    ADD CONSTRAINT folder_pkey PRIMARY KEY (id);



ALTER TABLE ONLY folder_project
    ADD CONSTRAINT folder_project_pkey PRIMARY KEY (project_id, folder_id);



ALTER TABLE ONLY notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);



ALTER TABLE ONLY post
    ADD CONSTRAINT post_pkey PRIMARY KEY (id);



ALTER TABLE ONLY project
    ADD CONSTRAINT project_pkey PRIMARY KEY (id);



ALTER TABLE ONLY task
    ADD CONSTRAINT task_pkey PRIMARY KEY (id);



ALTER TABLE ONLY topic
    ADD CONSTRAINT topic_pkey PRIMARY KEY (id);



CREATE INDEX index_commenter_date ON comment USING btree (date);

ALTER TABLE comment CLUSTER ON index_commenter_date;



CREATE INDEX index_notification_date ON notification USING btree (date);

ALTER TABLE notification CLUSTER ON index_notification_date;



CREATE INDEX index_post_date ON post USING btree (date);

ALTER TABLE post CLUSTER ON index_post_date;



CREATE INDEX index_task_deadline ON task USING btree (deadline);

ALTER TABLE task CLUSTER ON index_task_deadline;



CREATE TRIGGER "On_Delete" BEFORE DELETE ON folder FOR EACH ROW EXECUTE PROCEDURE delete_folder();



CREATE TRIGGER "On_Delete_Default" BEFORE DELETE ON folder FOR EACH ROW EXECUTE PROCEDURE delete_folder_default();



CREATE TRIGGER "On_Insert" AFTER INSERT ON "user" FOR EACH ROW EXECUTE PROCEDURE insert_user();



CREATE TRIGGER "On_Insert" BEFORE INSERT ON folder_project FOR EACH ROW EXECUTE PROCEDURE insert_project_folder();



CREATE TRIGGER "On_Insert" AFTER INSERT ON collaborates FOR EACH ROW EXECUTE PROCEDURE insert_collaborates();



CREATE TRIGGER insert AFTER INSERT ON project FOR EACH ROW EXECUTE PROCEDURE insert_project();



CREATE TRIGGER trigger_assigned_insert_update BEFORE INSERT OR UPDATE ON assigned FOR EACH ROW EXECUTE PROCEDURE insert_update_assigned();



CREATE TRIGGER trigger_collaborates_delete BEFORE DELETE ON collaborates FOR EACH ROW EXECUTE PROCEDURE delete_collaborates();



CREATE TRIGGER trigger_comment_insert BEFORE INSERT ON comment FOR EACH ROW EXECUTE PROCEDURE insert_comment();



CREATE TRIGGER trigger_document_insert BEFORE INSERT ON document FOR EACH ROW EXECUTE PROCEDURE insert_document();



CREATE TRIGGER trigger_post_delete BEFORE DELETE ON post FOR EACH ROW EXECUTE PROCEDURE delete_comments();



CREATE TRIGGER trigger_post_insert BEFORE INSERT ON post FOR EACH ROW EXECUTE PROCEDURE insert_post();



CREATE TRIGGER trigger_project_delete BEFORE DELETE ON project FOR EACH ROW EXECUTE PROCEDURE delete_project_func();



CREATE TRIGGER trigger_task_delete BEFORE DELETE ON task FOR EACH ROW EXECUTE PROCEDURE delete_task();



CREATE TRIGGER trigger_task_insert BEFORE INSERT ON task FOR EACH ROW EXECUTE PROCEDURE insert_task();



CREATE TRIGGER trigger_task_update BEFORE UPDATE ON task FOR EACH ROW EXECUTE PROCEDURE update_task();



CREATE TRIGGER trigger_topic_delete BEFORE DELETE ON topic FOR EACH ROW EXECUTE PROCEDURE delete_topic();



ALTER TABLE ONLY assigned
    ADD CONSTRAINT assigned_task_id_fkey FOREIGN KEY (task_id) REFERENCES task(id);



ALTER TABLE ONLY assigned
    ADD CONSTRAINT assigned_username_fkey FOREIGN KEY (username) REFERENCES "user"(username);



ALTER TABLE ONLY collaborates
    ADD CONSTRAINT collaborates_project_id_fkey FOREIGN KEY (project_id) REFERENCES project(id);



ALTER TABLE ONLY collaborates
    ADD CONSTRAINT collaborators_username_fkey FOREIGN KEY (username) REFERENCES "user"(username);



ALTER TABLE ONLY comment
    ADD CONSTRAINT comment_commenter_fkey FOREIGN KEY (commenter) REFERENCES "user"(username);



ALTER TABLE ONLY comment
    ADD CONSTRAINT comment_post_id_fkey FOREIGN KEY (post_id) REFERENCES post(id);



ALTER TABLE ONLY document
    ADD CONSTRAINT document_project_id_fkey FOREIGN KEY (project_id) REFERENCES project(id);



ALTER TABLE ONLY folder_project
    ADD CONSTRAINT folder_project_folder_id_fkey FOREIGN KEY (folder_id) REFERENCES folder(id);



ALTER TABLE ONLY folder_project
    ADD CONSTRAINT folder_project_project_id_fkey FOREIGN KEY (project_id) REFERENCES project(id);



ALTER TABLE ONLY folder
    ADD CONSTRAINT folder_username_fkey FOREIGN KEY (username) REFERENCES "user"(username);



ALTER TABLE ONLY notification
    ADD CONSTRAINT notification_associated_fkey FOREIGN KEY (associated) REFERENCES "user"(username);



ALTER TABLE ONLY notification
    ADD CONSTRAINT notification_notificated_fkey FOREIGN KEY (notificated) REFERENCES "user"(username);



ALTER TABLE ONLY notification
    ADD CONSTRAINT notification_project_id_fkey FOREIGN KEY (project_id) REFERENCES project(id);



ALTER TABLE ONLY post
    ADD CONSTRAINT post_poster_fkey FOREIGN KEY (poster) REFERENCES "user"(username);



ALTER TABLE ONLY post
    ADD CONSTRAINT post_topic_id_fkey FOREIGN KEY (topic_id) REFERENCES topic(id);



ALTER TABLE ONLY project
    ADD CONSTRAINT project_manager_fkey FOREIGN KEY (manager) REFERENCES "user"(username);



ALTER TABLE ONLY task
    ADD CONSTRAINT task_category_fkey FOREIGN KEY (category) REFERENCES category(name);



ALTER TABLE ONLY task
    ADD CONSTRAINT task_owner_fkey FOREIGN KEY (owner) REFERENCES "user"(username);



ALTER TABLE ONLY task
    ADD CONSTRAINT task_project_id_fkey FOREIGN KEY (project_id) REFERENCES project(id);



ALTER TABLE ONLY topic
    ADD CONSTRAINT topic_project_id_fkey FOREIGN KEY (project_id) REFERENCES project(id);



ALTER TABLE ONLY topic
    ADD CONSTRAINT topic_task_id_fkey FOREIGN KEY (task_id) REFERENCES task(id);



REVOKE ALL ON SCHEMA proto FROM PUBLIC;
REVOKE ALL ON SCHEMA proto FROM lbaw1665;
GRANT ALL ON SCHEMA proto TO lbaw1665;
