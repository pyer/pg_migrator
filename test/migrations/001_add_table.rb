# Version 001
# add table, sequence and data for testing

@up = "
    CREATE TABLE role (
        id integer NOT NULL,
        name character varying(30) );
    CREATE SEQUENCE role_id_seq
        START WITH 1
        INCREMENT BY 1
        NO MINVALUE
        NO MAXVALUE
        CACHE 1;
    INSERT INTO role VALUES (1,'admin');
    INSERT INTO role VALUES (2,'user');"

@down = "
    DROP TABLE role;
    DROP SEQUENCE role_id_seq;"
