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
latitude double precision,
longitude double precision
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
start timestamptz,
stop timestamptz,
patient_id text,
foreign key (patient_id) references patients(patient_id),
organization_id text,
foreign key (organization_id) references organizations(organization_id),
payer_id text,
foreign key (payer_id) references payers(payer_id),
encounterclass text,
encounter_code text,
encounter_description text,
base_encounter_cost decimal(6,2),
total_claim_cost decimal(8,2),
payer_coverage decimal(8,2),
reason_code text,
reason_description text
);

-- Creating procedures table for importing procedures.csv
create table procedures(
start timestamptz,
stop timestamptz,
patient_id text,
foreign key (patient_id) references patients(patient_id),
encounter_id text,
foreign key(encounter_id) references encounters(encounter_id),
procedure_code text,
procedure_description text,
procedure_base_cost int,
reason_code text,
reason_description text
);

select * from procedures;

-- create stored procedures

select first_name, last_name 
from patients
where patient_id = '3de74169-7f67-9304-91d4-757e0f3a14d2';


select * from encounter
where encounter_id = '32c84703-2481-49cd-d571-3899d5820253';


SET TIME ZONE 'UTC';

select * from encounter;


select * from organizations;

select * from patients;

