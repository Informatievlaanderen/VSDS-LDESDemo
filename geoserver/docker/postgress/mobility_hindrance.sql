-- Table: public.mobility_hindrances

-- DROP TABLE IF EXISTS public.mobility_hindrances;

CREATE TABLE IF NOT EXISTS public.mobility_hindrances
(
    id character varying COLLATE pg_catalog."default" NOT NULL,
    gipod_id bigint NOT NULL,
    identifier_assigned_by_name character varying COLLATE pg_catalog."default",
    description character varying COLLATE pg_catalog."default",
    owner_id character varying COLLATE pg_catalog."default",
    owner_preferred_name character varying COLLATE pg_catalog."default",
    zone_id character varying COLLATE pg_catalog."default",
    zone_consequence_label character varying COLLATE pg_catalog."default",
    zone_geometry_wkt geometry,
    zone_type character varying COLLATE pg_catalog."default",
    period_start date,
    period_end date,
    status character varying COLLATE pg_catalog."default",
    generated_at_time date,
    last_event_name character varying COLLATE pg_catalog."default",
    created_on date NOT NULL,
    CONSTRAINT mobility_hindrances_pkey PRIMARY KEY (id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.mobility_hindrances
    OWNER to ldes;
