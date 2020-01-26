DROP TABLE IF EXISTS public.project;
DROP TABLE IF EXISTS public.project_item;
DROP TABLE IF EXISTS public.person;
DROP TABLE IF EXISTS public.work_item;
DROP TABLE IF EXISTS public.work_status;
DROP TABLE IF EXISTS public.status_sequence;
DROP TABLE IF EXISTS public.status_sequence_element;
DROP PROCEDURE IF EXISTS insert_project;
DROP PROCEDURE IF EXISTS insert_person;
DROP PROCEDURE IF EXISTS insert_sequence;
DROP PROCEDURE IF EXISTS insert_sequence_element;
DROP PROCEDURE IF EXISTS insert_work_item;


/* ########################################################################## */

CREATE TABLE public.project (
    id uuid NOT NULL PRIMARY key,
    project_name varchar(50) NOT NULL,
    project_description varchar(200000) NULL,
    project_owner uuid NULL,
    parent_id uuid NULL,    
    work_item_count int NULL,
    work_item_completed int
);
/* ########################################################################## */
CREATE TABLE public.person (
    id uuid NOT NULL PRIMARY KEY,
    username varchar(50) NOT NULL,
    first_name varchar (30) NULL,
    last_name varchar (50) NULL,
    email varchar(300) NULL
);
/* ########################################################################## */
CREATE TABLE public.work_status (
    id uuid NOT NULL PRIMARY KEY,
    status_name varchar(50),
    completed BOOLEAN    
);
/* ########################################################################## */
CREATE TABLE public.status_sequence (
    id uuid NOT NULL PRIMARY KEY,
    sequence_name varchar(50) NOT NULL
);
/* ########################################################################## */
CREATE TABLE public.status_sequence_element (
    status_sequence_id uuid NOT NULL,
    work_status_id uuid NOT NULL,
    sequence_number int NOT NULL,
	UNIQUE (status_sequence_id, work_status_id)
);
/* ########################################################################## */
CREATE TABLE public.work_item (
    id uuid NOT NULL PRIMARY KEY,
    person_id uuid NULL,
    work_item_status_id uuid NOT NULL,
    status_sequence_id uuid NOT NULL,    
    completed BOOLEAN,
    work_item_name varchar(50),    
    work_item_description varchar(200000) NULL       
);

/* ########################################################################## */
CREATE TABLE public.project_item (
    project_id uuid NOT NULL,
    work_item_id uuid NOT NULL,
    UNIQUE (project_id, work_item_id)
);

/* ########################################################################## */
CREATE PROCEDURE insert_work_status(id uuid, status_name varchar(50), completed BOOLEAN)
LANGUAGE SQL
AS $$
    INSERT INTO public.work_status VALUES (id, status_name, completed);
$$;

CALL insert_work_status('cd6810b1-f77f-4dc3-893d-532fe396b71f', 'New', FALSE);
CALL insert_work_status('8818568c-c07e-4c7e-b1d7-82de7e30839f', 'Done', TRUE);
/* ########################################################################## */

CREATE PROCEDURE insert_sequence(id uuid, status_name varchar(50))
LANGUAGE SQL
AS $$
    INSERT INTO public.status_sequence VALUES (id, status_name)
$$;

CALL insert_sequence('66122958-1ff9-4ead-9d1d-93424ad9a3d8', 'Sample Sequence');

/* ########################################################################## */

CREATE PROCEDURE insert_sequence_element(sequence_id uuid, status_id uuid, sequence_number int)
LANGUAGE SQL
AS $$
    INSERT INTO public.status_sequence_element
	VALUES (sequence_id, status_id, sequence_number);
$$;

CALL insert_sequence_element('66122958-1ff9-4ead-9d1d-93424ad9a3d8', 'cd6810b1-f77f-4dc3-893d-532fe396b71f', 0);
CALL insert_sequence_element('66122958-1ff9-4ead-9d1d-93424ad9a3d8', '8818568c-c07e-4c7e-b1d7-82de7e30839f', 1);

/* ########################################################################## */

CREATE PROCEDURE insert_work_item(
        id uuid, 
        work_item_name varchar(50), 
        work_item_description varchar(200000), 
        work_item_status_id uuid,
		status_sequence_id uuid
		)
LANGUAGE SQL
AS $$
    INSERT INTO 
        public.work_item(
            id, 
            work_item_name, 
            work_item_description, 
            work_item_status_id,
            status_sequence_id
            ) 
    VALUES
        (id, 
         work_item_name, 
         work_item_description, 
         work_item_status_id,
         status_sequence_id);
$$;

CALL insert_work_item(
    '9f709c38-7ed3-4e8c-80c4-6b637e21b81e',
    'First Work Item',
    'Test out model',
    'cd6810b1-f77f-4dc3-893d-532fe396b71f',
    '66122958-1ff9-4ead-9d1d-93424ad9a3d8'
    
);
/* ########################################################################## */

CREATE PROCEDURE insert_project (id uuid, project_name varchar(50))
LANGUAGE SQL
AS $$
 INSERT INTO public.project VALUES (id, project_name);
$$;

CALL insert_project('5e94bd5a-3463-444f-9a1c-9ca8150952b5', 'Sample Project');

/* ########################################################################## */

CREATE PROCEDURE insert_person(
    id uuid, 
    username varchar(50), 
    first_name varchar(50), 
    last_name varchar(50), 
    email varchar(300))
LANGUAGE SQL
AS $$
    INSERT INTO public.person VALUES 
        (id, 
         username, 
         first_name, 
         last_name, 
         email);
$$;

CALL insert_person('5773584e-6a16-493a-b2da-66232a7e96aa', 'kamabery', 'Kurt', 'Mabery', 'kamabery@gmail.com');

/* ########################################################################## */

CREATE PROCEDURE insert_project_item(project_id uuid, work_item_id uuid)
LANGUAGE SQL
AS $$
INSERT INTO  public.project_item VALUES (project_id, work_item_id)
$$;

CALL insert_project_item('5e94bd5a-3463-444f-9a1c-9ca8150952b5', '9f709c38-7ed3-4e8c-80c4-6b637e21b81e');

/* ########################################################################## */
