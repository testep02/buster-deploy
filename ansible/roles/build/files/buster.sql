--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.5
-- Dumped by pg_dump version 9.5.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE buster;
--
-- Name: buster; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE buster WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C' LC_CTYPE = 'C';


ALTER DATABASE buster OWNER TO postgres;

\connect buster

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: buster; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE buster IS 'This database is to support Buster, the AWS Management and Deployment Application.';


--
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO postgres;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner:
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner:
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: backups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE backups (
    backup_id integer NOT NULL,
    backup_date timestamp without time zone NOT NULL,
    backup_env character(50) NOT NULL,
    backup_scheduler_id integer,
    backup_source character(150)
);


ALTER TABLE backups OWNER TO postgres;

--
-- Name: backup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE backup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE backup_id_seq OWNER TO postgres;

--
-- Name: backup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE backup_id_seq OWNED BY backups.backup_id;


--
-- Name: backup_scheduler; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE backup_scheduler (
    backup_scheduler_id integer NOT NULL,
    backup_env character(50) NOT NULL,
    backup_cron_string character(50) NOT NULL,
    backup_schedule_enabled integer NOT NULL,
    backup_schedule_created_by character(150) NOT NULL
);


ALTER TABLE backup_scheduler OWNER TO postgres;

--
-- Name: backup_scheduler_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE backup_scheduler_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE backup_scheduler_id_seq OWNER TO postgres;

--
-- Name: backup_scheduler_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE backup_scheduler_id_seq OWNED BY backup_scheduler.backup_scheduler_id;


--
-- Name: backup_snapshots; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE backup_snapshots (
    backup_snapshot_id integer NOT NULL,
    backup_id integer NOT NULL,
    backup_instance_id character(150) NOT NULL,
    backup_instance_name character(150) NOT NULL,
    backup_volume_id character(150) NOT NULL
);


ALTER TABLE backup_snapshots OWNER TO postgres;

--
-- Name: backup_snapshot_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE backup_snapshot_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE backup_snapshot_id_seq OWNER TO postgres;

--
-- Name: backup_snapshot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE backup_snapshot_id_seq OWNED BY backup_snapshots.backup_snapshot_id;


--
-- Name: build_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE build_config (
    build_config_id integer NOT NULL,
    build_name character(150) NOT NULL,
    build_cron_schedule character(50) NOT NULL,
    build_command text,
    build_repository text,
    build_branch text
);


ALTER TABLE build_config OWNER TO postgres;

--
-- Name: build_config_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE build_config_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE build_config_id_seq OWNER TO postgres;

--
-- Name: build_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE build_config_id_seq OWNED BY build_config.build_config_id;


--
-- Name: build; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE build (
    build_id integer DEFAULT nextval('build_config_id_seq'::regclass) NOT NULL,
    build_config_id integer NOT NULL,
    build_name character(150),
    build_status integer,
    build_state integer NOT NULL,
    build_version character(50) NOT NULL,
    build_date date NOT NULL,
    next_deployment_date date
);


ALTER TABLE build OWNER TO postgres;

--
-- Name: build_approval_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE build_approval_logs (
    build_approval_logs_id integer NOT NULL,
    build_id integer NOT NULL,
    build_approver_uid character(150) NOT NULL,
    build_approval_date timestamp without time zone NOT NULL,
    build_approval_state integer NOT NULL
);


ALTER TABLE build_approval_logs OWNER TO postgres;

--
-- Name: build_approval_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE build_approval_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE build_approval_logs_id_seq OWNER TO postgres;

--
-- Name: build_approval_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE build_approval_logs_id_seq OWNED BY build_approval_logs.build_approval_logs_id;


--
-- Name: build_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE build_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE build_id_seq OWNER TO postgres;

--
-- Name: build_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE build_id_seq OWNED BY build.build_id;


--
-- Name: deployment_scheduler; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE deployment_scheduler (
    deployment_scheduler_id integer NOT NULL,
    build_id integer NOT NULL,
    deployment_status integer NOT NULL,
    deployment_date timestamp without time zone NOT NULL
);


ALTER TABLE deployment_scheduler OWNER TO postgres;

--
-- Name: deployment_scheduler_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE deployment_scheduler_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE deployment_scheduler_id_seq OWNER TO postgres;

--
-- Name: deployment_scheduler_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE deployment_scheduler_id_seq OWNED BY deployment_scheduler.deployment_scheduler_id;


--
-- Name: environments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE environments (
    environment_id integer NOT NULL,
    environment_name character(150),
    environment_desc text,
    environment_creation_date date,
    environment_backed_up integer DEFAULT 0,
    environment_owned_by integer DEFAULT 0
);


ALTER TABLE environments OWNER TO postgres;

--
-- Name: environment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE environment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE environment_id_seq OWNER TO postgres;

--
-- Name: environment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE environment_id_seq OWNED BY environments.environment_id;


--
-- Name: backup_scheduler_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY backup_scheduler ALTER COLUMN backup_scheduler_id SET DEFAULT nextval('backup_scheduler_id_seq'::regclass);


--
-- Name: backup_snapshot_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY backup_snapshots ALTER COLUMN backup_snapshot_id SET DEFAULT nextval('backup_snapshot_id_seq'::regclass);


--
-- Name: backup_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY backups ALTER COLUMN backup_id SET DEFAULT nextval('backup_id_seq'::regclass);


--
-- Name: build_approval_logs_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY build_approval_logs ALTER COLUMN build_approval_logs_id SET DEFAULT nextval('build_approval_logs_id_seq'::regclass);


--
-- Name: build_config_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY build_config ALTER COLUMN build_config_id SET DEFAULT nextval('build_config_id_seq'::regclass);


--
-- Name: deployment_scheduler_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY deployment_scheduler ALTER COLUMN deployment_scheduler_id SET DEFAULT nextval('deployment_scheduler_id_seq'::regclass);


--
-- Name: environment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY environments ALTER COLUMN environment_id SET DEFAULT nextval('environment_id_seq'::regclass);


--
-- Name: backup_scheduler_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY backup_scheduler
    ADD CONSTRAINT backup_scheduler_pkey PRIMARY KEY (backup_scheduler_id);


--
-- Name: backup_snapshots_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY backup_snapshots
    ADD CONSTRAINT backup_snapshots_pkey PRIMARY KEY (backup_snapshot_id);


--
-- Name: backups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY backups
    ADD CONSTRAINT backups_pkey PRIMARY KEY (backup_id);


--
-- Name: build_approval_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY build_approval_logs
    ADD CONSTRAINT build_approval_logs_pkey PRIMARY KEY (build_approval_logs_id);


--
-- Name: build_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY build_config
    ADD CONSTRAINT build_config_pkey PRIMARY KEY (build_config_id);


--
-- Name: build_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY build
    ADD CONSTRAINT build_pkey PRIMARY KEY (build_id);


--
-- Name: deployment_scheduler_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY deployment_scheduler
    ADD CONSTRAINT deployment_scheduler_pkey PRIMARY KEY (deployment_scheduler_id);


--
-- Name: environments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY environments
    ADD CONSTRAINT environments_pkey PRIMARY KEY (environment_id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--
