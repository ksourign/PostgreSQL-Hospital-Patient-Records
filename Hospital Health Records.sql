-- TABLES
-- Creating patients table for importing patients.csv
create table patients(
patient_id text primary key,
birth_date date,
death_date date,
prefix text,
first_name text,
last_name text,
suffix text,
maiden text,
martial text,
race text,
ethnicity text,
gender text,
birthplace text,
address text,
city text,
state text,
county text,
zipcode text,
patient_latitude double precision,
patient_longitude double precision
);

-- Creating organizations table for importing organizations.csv
create table organizations (
organization_id text primary key,
organization_name text,
organization_address text,
organization_city text,
organization_state text,
organization_zipcode text,
organization_latitude double precision,
organization_longitude double precision
);

-- Creating payers table for importing payers.csv
create table payers(
payer_id text primary key,
payer_name text,
payer_address text,
payer_city text,
payer_state_headquartered text,
payer_zipcode text,
payer_phone text
);


-- Creating encounter table for importing encounter.csv
create table encounter(
encounter_id text primary key,
encounter_start timestamptz,
encounter_stop timestamptz,
patient_id text,
foreign key (patient_id) references patients(patient_id),
organization_id text,
foreign key (organization_id) references organizations(organization_id),
payer_id text,
foreign key (payer_id) references payers(payer_id),
encounter_class text,
encounter_code text,
encounter_description text,
encounter_base_cost decimal(6,2),
total_claim_cost decimal(8,2),
payer_coverage decimal(8,2),
encounter_reason_code text,
encounter_reason_description text
);

-- Creating procedures table for importing procedures.csv
create table procedures(
procedure_start timestamptz,
procedure_stop timestamptz,
patient_id text,
foreign key (patient_id) references patients(patient_id),
encounter_id text,
foreign key(encounter_id) references encounters(encounter_id),
procedure_code text,
procedure_description text,
procedure_base_cost int,
procedure_reason_code text,
procedure_reason_description text
);




----------------------------------------------------------------------------------------------------------
-- QUERIES

select * from procedures;
select * from patients;
select  * from encounters;


-- PRACTICING VIEWS/STORED PROCEDURES
-- FUNCTION STRUCTURE EXAMPLE
CREATE function get_patient_encounters (v_patient_id text)
returns table(
	encounter_id text,
	patient_id text,
	first_name text,
	last_name text
)
language sql
as $$
	select encounter_id, patients.patient_id, first_name, last_name
	from encounters
	join patients on patients.patient_id = encounters.patient_id
	where patients.patient_id = v_patient_id
$$;



-- VIEW get_patient_encounters
create view get_patient_encounters as
select encounter_id, patients.patient_id, first_name, last_name, encounter_start, encounter_stop, encounter_class, encounter_code, encounter_description, encounter_reason_code, encounter_reason_description
from encounters
join patients on patients.patient_id = encounters.patient_id;


select * from encounters where patient_id = '3de74169-7f67-9304-91d4-757e0f3a14d2';



-- Changing Postgre TIMEZONE to match dataset's UTC
SET TIME ZONE 'UTC';



--------------------------------------------------------------------------------------------------------------------------------------------
-- DATA VALIDATIONS + INSIGHTS for Tableau Results
-- 14670 encounters in procedures
-- an encounter can have many procedures by 1 patient
select encounter_id, count(*)
from procedures
group by encounter_id;


select * from procedures
where encounter_id = '6fa55fb5-1e01-439a-a04c-d1ad2f88f504'

-- 10 diff payers
select * from payers;



-- return payer_name and their count of encounters (Medicare most used, 10 payers)
select payer_name, count(encounters.payer_id)
from encounters
join payers on payers.payer_id =  encounters.payer_id
group by payer_name, encounters.payer_id
order by count(encounters.payer_id) desc;


-- 27891 encounters
select * from encounters;

select distinct procedure_code, procedure_description, count(procedure_code)
from procedures
group by procedure_code, procedure_description
order by count desc;


select * from procedures
where procedure_code = '710824005'

select procedure_code, procedure_description
from procedures
order by procedure_code desc;

select * from procedures
where procedure_description = 'Instrumental delivery'



select * from patients
where death_date is not null;


-- return each patient's count of occurences and number of distinct years active (omitting deceased) [820 diff patients with encounters]
select encounters.patient_id, count(*) as count_total_encounters, count(distinct extract(year from encounters.encounter_start)) as active_years
from encounters
join patients on patients.patient_id = encounters.patient_id
where death_date is null
group by encounters.patient_id
order by count(*) desc;

-- Validation - return a patient's distinct years for their encounters (could be a procedure?)
select distinct patient_id, extract(year from encounters.start)
from encounters
where patient_id = '5dcb295d-92df-a147-ebcc-aa49b6262830';


-- 974 patients total
-- (820 patients alive)
select * from patients where death_date is null;
-- (154 patients deceased)
select * from patients where death_date is not null;



select EXTRACT(YEAR FROM start), count(*), encounter_description
from encounters
where patient_id = '1712d26d-822d-1e3a-2267-0a9dba31d7c8'
group by EXTRACT(YEAR FROM start), encounter_description
order by EXTRACT(YEAR FROM start) desc;



select * from encounters
where patient_id = '1712d26d-822d-1e3a-2267-0a9dba31d7c8'
