# Relational Databases in PostgreSQL

*Spanish version: [README.md](README.md)*

Design and implementation of a clinical database for a veterinary clinic — from a conceptual model in Chen notation, to a logical schema in **Third Normal Form**, to executable **PostgreSQL DDL** with integrity rules — plus a bank of SQL queries over a university database. Course *Databases I*, MSc in Data Science, Universidad Santo Tomás (2026).

**Team:** Adrian Grateron · Harold Rodríguez · Jhonatan Smith Doncel

## Veterinary clinic

```
OWNER → PET → APPOINTMENT → DIAGNOSIS → PRESCRIPTION → MEDICATION
           PET → VACCINATION RECORD → VACCINE
```

- 10 tables in 3NF; owner phone numbers modeled as a multivalued attribute.
- Weak entities (`prescripcion`, `registro_vacunacion`) with composite keys.
- 1:0..1 appointment–diagnosis relationship enforced with FK + `UNIQUE`.
- Pet age is derived from birth date, never stored.
- Integrity via PK, FK (`RESTRICT`/`CASCADE`), domain `CHECK`s, FK indexes and two **PL/pgSQL triggers**: no expired vaccines, no prescription dated before its appointment.

## Run it (tested on PostgreSQL 16)

```bash
psql -d your_db -f sql/01_clinica_veterinaria_ddl.sql   # schema
psql -d your_db -f sql/02_datos_prueba.sql              # fictitious test data
psql -d your_db -f sql/03_consultas_validacion.sql       # queries + integrity tests
```

Script 03 runs five analytical queries and five **negative tests** that must fail (duplicate diagnosis, expired vaccine, prescription before appointment, deleting an owner with pets, invalid domain value). All five print `OK`.

**Known limitation:** the schema allows at most one diagnosis per appointment but does not check that the appointment status is *attended*.

## University queries

`consultas_universidad.sql` solves 10 exercises (selection, filtering, ordering, aggregation and joins). The university schema was provided by the course and is not included.

**Tech:** PostgreSQL · PL/pgSQL · pgAdmin 4 · diagrams.net · **License:** CC BY 4.0
