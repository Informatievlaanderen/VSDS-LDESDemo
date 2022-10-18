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

ALTER TABLE IF EXISTS public.mobility_hindrances OWNER to ldes;


CREATE view public."Wisselend verkeer via verkeersborden" as select *, 'Wisselend verkeer via verkeersborden',  left(period_start::text, 10) as time_start, left(period_end::text, 10) as time_end from mobility_hindrances where zone_consequence_label LIKE '%Wisselend verkeer via verkeersborden%';
CREATE view public."Geen doorgang voor gemotoriseerd verkeer" as select *, 'Geen doorgang voor gemotoriseerd verkeer',  left(period_start::text, 10) as time_start, left(period_end::text, 10) as time_end from mobility_hindrances where zone_consequence_label LIKE '%Geen doorgang voor gemotoriseerd verkeer%';
CREATE view public."Geen doorgang voor fietsers" as select *, 'Geen doorgang voor fietsers',  left(period_start::text, 10) as time_start, left(period_end::text, 10) as time_end from mobility_hindrances where zone_consequence_label LIKE '%Geen doorgang voor fietsers%';
CREATE view public."Snelheidsbeperking" as select *, 'Snelheidsbeperking',  left(period_start::text, 10) as time_start, left(period_end::text, 10) as time_end from mobility_hindrances where zone_consequence_label LIKE '%Snelheidsbeperking%';
CREATE view public."Wisselend verkeer via verkeerslichten" as select *, 'Wisselend verkeer via verkeerslichten',  left(period_start::text, 10) as time_start, left(period_end::text, 10) as time_end from mobility_hindrances where zone_consequence_label LIKE '%Wisselend verkeer via verkeerslichten%';
CREATE view public."Versmalde rijstroken" as select *, 'Versmalde rijstroken',  left(period_start::text, 10) as time_start, left(period_end::text, 10) as time_end from mobility_hindrances where zone_consequence_label LIKE '%Versmalde rijstroken%';
CREATE view public."Geen doorgang voor voetgangers" as select *, 'Geen doorgang voor voetgangers',  left(period_start::text, 10) as time_start, left(period_end::text, 10) as time_end from mobility_hindrances where zone_consequence_label LIKE '%Geen doorgang voor voetgangers%';
CREATE view public."Geen doorgang voor gemotoriseerd verkeer uitgezonderd plaatselijk verkeer" as select *, 'Geen doorgang voor gemotoriseerd verkeer uitgezonderd plaatselijk verkeer',  left(period_start::text, 10) as time_start, left(period_end::text, 10) as time_end from mobility_hindrances where zone_consequence_label LIKE '%Geen doorgang voor gemotoriseerd verkeer uitgezonderd plaatselijk verkeer%';
CREATE view public."Handelaars moeilijk bereikbaar" as select *, 'Handelaars moeilijk bereikbaar',  left(period_start::text, 10) as time_start, left(period_end::text, 10) as time_end from mobility_hindrances where zone_consequence_label LIKE '%Handelaars moeilijk bereikbaar%';
CREATE view public."Vermindering van rijstroken" as select *, 'Vermindering van rijstroken',  left(period_start::text, 10) as time_start, left(period_end::text, 10) as time_end from mobility_hindrances where zone_consequence_label LIKE '%Vermindering van rijstroken%';


ALTER view IF EXISTS public."Wisselend verkeer via verkeersborden" OWNER to ldes;
ALTER view IF EXISTS public."Geen doorgang voor gemotoriseerd verkeer" OWNER to ldes;
ALTER view IF EXISTS public."Geen doorgang voor fietsers" OWNER to ldes;
ALTER view IF EXISTS public."Snelheidsbeperking" OWNER to ldes;
ALTER view IF EXISTS public."Wisselend verkeer via verkeerslichten" OWNER to ldes;
ALTER view IF EXISTS public."Versmalde rijstroken" OWNER to ldes;
ALTER view IF EXISTS public."Geen doorgang voor voetgangers" OWNER to ldes;
ALTER view IF EXISTS public."Geen doorgang voor gemotoriseerd verkeer uitgezonderd plaatselijk verkeer" OWNER to ldes;
ALTER view IF EXISTS public."Wisselend verkeer via verkeersborden" OWNER to ldes;
ALTER view IF EXISTS public."Handelaars moeilijk bereikbaar" OWNER to ldes;
ALTER view IF EXISTS public."Vermindering van rijstroken" OWNER to ldes;

create view unnest_stats as select unnest(('{' || zone_consequence_label || '}')::text[][]), left(period_start::text, 10) as start, left(period_end::text, 10) as end
from mobility_hindrances where zone_consequence_label is not null;


create view overview_stats as
select count(*)::int, foo.date
from unnest_stats,
(SELECT date_trunc('day', dd):: date as date
FROM generate_series
        ( '2020-01-01'::timestamp 
        , '2022-12-31'::timestamp
        , '1 day'::interval) dd) as foo
		

where "start"::date <= foo.date AND "end"::date >= foo.date
group by foo.date;


create view stats as
select q.sd, q.unnest, count(*) from
(SELECT
GENERATE_SERIES
(t.start, t.end, '1 DAY')::date AS sd,
t.* FROM (select unnest(('{' || zone_consequence_label || '}')::text[][]), left(period_start::text, 10)::date as start, left(period_end::text, 10)::date as end
from mobility_hindrances
)as t
 ORDER BY t.start
) as q
group by q.sd, q.unnest;

create view unnest_stats2 as
select unnest(('{' || zone_consequence_label || '}')::text[][]), left(period_start::text, 10) as start, left(period_end::text, 10) as end,
ST_X(ST_CENTROID(ST_SETSRID(zone_geometry_wkt, 4326))) as longitude, ST_Y(ST_CENTROID(ST_SETSRID(zone_geometry_wkt, 4326))) as latitude
from mobility_hindrances
where period_start > '2020-01-01' and period_end < '2022-12-24'
order by period_start;



create view category as
select distinct(unnest(('{' || zone_consequence_label || '}')::text[][]))
from mobility_hindrances;


create view owner as
select distinct(owner_preferred_name)
from mobility_hindrances;
