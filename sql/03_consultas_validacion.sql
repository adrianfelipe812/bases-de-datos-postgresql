-- ============================================================================
-- Clínica veterinaria · Consultas de validación del modelo
-- Ejecutar después de 01_clinica_veterinaria_ddl.sql y 02_datos_prueba.sql
-- ============================================================================
SET search_path TO clinica_veterinaria, public;

-- 1. Historia clínica completa: dueño → mascota → cita → diagnóstico → prescripción → medicamento
SELECT
    d.nombres || ' ' || d.apellidos           AS dueno,
    m.nombre                                  AS mascota,
    c.fecha,
    v.nombre_completo                         AS veterinario,
    dg.descripcion                            AS diagnostico,
    md.nombre_generico                        AS medicamento,
    p.dosis || ' ' || p.unidad                AS dosis,
    p.frecuencia
FROM dueno d
JOIN mascota m        ON m.cedula_dueno = d.cedula_dueno
JOIN cita c           ON c.id_mascota = m.id_mascota
JOIN veterinario v    ON v.cedula_veterinario = c.cedula_veterinario
LEFT JOIN diagnostico dg  ON dg.id_cita = c.id_cita
LEFT JOIN prescripcion p  ON p.id_diagnostico = dg.id_diagnostico
LEFT JOIN medicamento md  ON md.id_medicamento = p.id_medicamento
ORDER BY c.fecha, mascota, p.numero_prescripcion;

-- 2. Edad derivada (no almacenada) de cada mascota
SELECT
    nombre,
    especie,
    fecha_nacimiento,
    DATE_PART('year', AGE(CURRENT_DATE, fecha_nacimiento))::int AS edad_anios
FROM mascota
ORDER BY edad_anios DESC;

-- 3. Historial preventivo: vacunas aplicadas y próximas dosis
SELECT
    m.nombre        AS mascota,
    rv.numero_registro,
    va.nombre       AS vacuna,
    va.lote,
    rv.fecha_aplicacion,
    rv.proxima_dosis
FROM registro_vacunacion rv
JOIN mascota m  ON m.id_mascota = rv.id_mascota
JOIN vacuna va  ON va.id_vacuna = rv.id_vacuna
ORDER BY m.nombre, rv.numero_registro;

-- 4. Carga de trabajo por veterinario y estado de la cita
SELECT
    v.nombre_completo,
    c.estado,
    COUNT(*) AS citas
FROM cita c
JOIN veterinario v ON v.cedula_veterinario = c.cedula_veterinario
GROUP BY v.nombre_completo, c.estado
ORDER BY v.nombre_completo, c.estado;

-- 5. Medicamentos más formulados
SELECT
    md.nombre_generico,
    COUNT(*) AS prescripciones
FROM prescripcion p
JOIN medicamento md ON md.id_medicamento = p.id_medicamento
GROUP BY md.nombre_generico
ORDER BY prescripciones DESC, md.nombre_generico;

-- ============================================================================
-- Pruebas de integridad: cada bloque DEBE fallar. Se ejecutan dentro de
-- subtransacciones para que el error no detenga el script.
-- ============================================================================

-- 6. Una cita no puede tener dos diagnósticos (UNIQUE sobre id_cita)
DO $$
BEGIN
    INSERT INTO clinica_veterinaria.diagnostico (id_cita, descripcion) VALUES (1, 'Duplicado');
    RAISE EXCEPTION 'FALLO: se aceptó un segundo diagnóstico';
EXCEPTION WHEN unique_violation THEN
    RAISE NOTICE 'OK: UNIQUE impide dos diagnósticos para la misma cita';
END $$;

-- 7. Trigger: no se puede aplicar una vacuna vencida (vence 2026-03-31)
DO $$
BEGIN
    INSERT INTO clinica_veterinaria.registro_vacunacion (id_mascota, numero_registro, id_vacuna, fecha_aplicacion)
    VALUES (3, 2, 3, '2026-05-20');
    RAISE EXCEPTION 'FALLO: se aceptó una vacuna vencida';
EXCEPTION WHEN raise_exception THEN
    IF SQLERRM LIKE 'FALLO%' THEN RAISE; END IF;
    RAISE NOTICE 'OK: trigger bloquea vacuna vencida -> %', SQLERRM;
END $$;

-- 8. Trigger: la prescripción no puede ser anterior a la cita (cita 2026-05-04)
DO $$
BEGIN
    INSERT INTO clinica_veterinaria.prescripcion
        (id_diagnostico, numero_prescripcion, id_medicamento, fecha_emision, dosis, unidad, frecuencia, via_administracion)
    VALUES (2, 2, 1, '2026-05-01', 0.1, 'mg/kg', 'Cada 24 horas', 'Oral');
    RAISE EXCEPTION 'FALLO: se aceptó una prescripción anterior a la cita';
EXCEPTION WHEN raise_exception THEN
    IF SQLERRM LIKE 'FALLO%' THEN RAISE; END IF;
    RAISE NOTICE 'OK: trigger bloquea prescripción anterior a la cita -> %', SQLERRM;
END $$;

-- 9. No se puede eliminar un dueño con mascotas (ON DELETE RESTRICT)
DO $$
BEGIN
    DELETE FROM clinica_veterinaria.dueno WHERE cedula_dueno = 1001001002;
    RAISE EXCEPTION 'FALLO: se eliminó un dueño con mascotas';
EXCEPTION WHEN foreign_key_violation THEN
    RAISE NOTICE 'OK: RESTRICT protege a los dueños con mascotas';
END $$;

-- 10. Dominio: sexo solo admite M, F u O (CHECK)
DO $$
BEGIN
    INSERT INTO clinica_veterinaria.mascota (cedula_dueno, nombre, especie, sexo, fecha_nacimiento)
    VALUES (1001001003, 'Toby', 'Canino', 'X', '2024-01-01');
    RAISE EXCEPTION 'FALLO: se aceptó un sexo fuera del dominio';
EXCEPTION WHEN check_violation THEN
    RAISE NOTICE 'OK: CHECK restringe el dominio de sexo';
END $$;
