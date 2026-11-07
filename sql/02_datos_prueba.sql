-- ============================================================================
-- Clínica veterinaria · Datos de prueba
-- Todos los registros son FICTICIOS; sirven solo para verificar el modelo.
-- Ejecutar después de 01_clinica_veterinaria_ddl.sql
-- ============================================================================
BEGIN;
SET search_path TO clinica_veterinaria, public;

INSERT INTO dueno (cedula_dueno, nombres, apellidos, direccion) VALUES
    (1001001001, 'Laura',  'Gómez Ruiz',   'Calle 45 # 12-30, Bogotá'),
    (1001001002, 'Andrés', 'Pérez Mora',   'Carrera 7 # 80-15, Bogotá'),
    (1001001003, 'Sofía',  'Ramírez Díaz', 'Avenida 68 # 22-10, Bogotá');

INSERT INTO dueno_telefono (cedula_dueno, telefono) VALUES
    (1001001001, '3001234567'),
    (1001001001, '601 7654321'),
    (1001001002, '3109876543'),
    (1001001003, '3205551234');

INSERT INTO veterinario (cedula_veterinario, nombre_completo, tarjeta_profesional, especialidad) VALUES
    (2002002001, 'Camilo Torres Vega',   50001, 'Medicina interna'),
    (2002002002, 'Daniela Rojas Castro', 50002, 'Cirugía');

INSERT INTO mascota (id_mascota, cedula_dueno, nombre, especie, raza, sexo, fecha_nacimiento, microchip) VALUES
    (1, 1001001001, 'Luna',  'Canino', 'Labrador',  'F', '2021-03-14', 900000000000001),
    (2, 1001001001, 'Milo',  'Felino', NULL,        'M', '2022-07-02', NULL),
    (3, 1001001002, 'Rocky', 'Canino', 'Criollo',   'M', '2019-11-20', 900000000000002),
    (4, 1001001003, 'Nala',  'Felino', 'Siamés',    'F', '2023-01-09', 900000000000003);

INSERT INTO cita (id_cita, id_mascota, cedula_veterinario, fecha, hora, motivo, estado) VALUES
    (1, 1, 2002002001, '2026-05-04', '09:00', 'Control anual',             'ATENDIDA'),
    (2, 3, 2002002002, '2026-05-04', '10:30', 'Cojera en pata trasera',    'ATENDIDA'),
    (3, 2, 2002002001, '2026-05-10', '15:00', 'Vómito recurrente',         'ATENDIDA'),
    (4, 4, 2002002001, '2026-06-01', '08:00', 'Vacunación',                'CANCELADA'),
    (5, 1, 2002002002, '2026-06-15', '11:00', 'Revisión postoperatoria',   'PROGRAMADA');

INSERT INTO diagnostico (id_diagnostico, id_cita, descripcion, observaciones) VALUES
    (1, 1, 'Paciente sano', 'Peso adecuado para la edad'),
    (2, 2, 'Esguince leve de tarso', 'Reposo de dos semanas'),
    (3, 3, 'Gastritis aguda', 'Dieta blanda');

INSERT INTO medicamento (id_medicamento, nombre_generico, presentacion, concentracion, forma_farmaceutica) VALUES
    (1, 'Meloxicam',  'Frasco 10 ml',       '1,5 mg/ml', 'Suspensión oral'),
    (2, 'Omeprazol',  'Caja x 14',          '10 mg',     'Cápsula'),
    (3, 'Maropitant', 'Caja x 4',           '16 mg',     'Tableta');

INSERT INTO prescripcion (id_diagnostico, numero_prescripcion, id_medicamento, fecha_emision,
                          dosis, unidad, frecuencia, via_administracion, duracion_dias, indicaciones) VALUES
    (2, 1, 1, '2026-05-04', 0.10, 'mg/kg', 'Cada 24 horas', 'Oral', 5, 'Administrar con comida'),
    (3, 1, 2, '2026-05-10', 1.00, 'mg/kg', 'Cada 24 horas', 'Oral', 7, 'En ayunas'),
    (3, 2, 3, '2026-05-10', 1.00, 'mg/kg', 'Cada 24 horas', 'Oral', 3, NULL);

INSERT INTO vacuna (id_vacuna, nombre, fabricante, lote, fecha_vencimiento) VALUES
    (1, 'Antirrábica',           'Laboratorio A', 'L-2026-01', '2027-01-31'),
    (2, 'Triple felina',         'Laboratorio B', 'L-2026-07', '2026-12-31'),
    (3, 'Pentavalente canina',   'Laboratorio A', 'L-2025-11', '2026-03-31');

INSERT INTO registro_vacunacion (id_mascota, numero_registro, id_vacuna, fecha_aplicacion, proxima_dosis) VALUES
    (1, 1, 3, '2026-02-10', '2027-02-10'),
    (1, 2, 1, '2026-05-04', '2027-05-04'),
    (2, 1, 2, '2026-05-10', '2027-05-10'),
    (3, 1, 1, '2026-05-04', '2027-05-04');

-- Las identidades se insertaron con id explícito: se sincronizan las secuencias.
SELECT setval(pg_get_serial_sequence('clinica_veterinaria.mascota',     'id_mascota'),     (SELECT MAX(id_mascota)     FROM mascota));
SELECT setval(pg_get_serial_sequence('clinica_veterinaria.cita',        'id_cita'),        (SELECT MAX(id_cita)        FROM cita));
SELECT setval(pg_get_serial_sequence('clinica_veterinaria.diagnostico', 'id_diagnostico'), (SELECT MAX(id_diagnostico) FROM diagnostico));
SELECT setval(pg_get_serial_sequence('clinica_veterinaria.medicamento', 'id_medicamento'), (SELECT MAX(id_medicamento) FROM medicamento));
SELECT setval(pg_get_serial_sequence('clinica_veterinaria.vacuna',      'id_vacuna'),      (SELECT MAX(id_vacuna)      FROM vacuna));

COMMIT;
