-- ============================================================================
-- Respuestas corregidas - Consultando la Base de Datos de una Universidad
-- Base de datos: universidad_db.sql
-- Gestor sugerido: PostgreSQL
-- ============================================================================

-- ============================================================================
-- a. Consultas básicas
-- ============================================================================

-- Pregunta 1. Lista el nombre y apellido de todos los estudiantes.
SELECT
    nombres,
    apellidos
FROM estudiantes;

-- Pregunta 2. Muestra los detalles de los cursos que otorgan más de 3 créditos.
SELECT
    *
FROM cursos
WHERE creditos > 3;

-- Pregunta 3. Obtén una lista de los profesores ordenados alfabéticamente por apellido.
SELECT
    *
FROM profesores
ORDER BY apellidos, nombres;

-- ============================================================================
-- b. Consultas de agregación
-- ============================================================================

-- Pregunta 4. ¿Cuántos estudiantes hay en total?
SELECT
    COUNT(*) AS total_estudiantes
FROM estudiantes;

-- Pregunta 5. ¿Cuál es el promedio de créditos de los cursos ofrecidos?
SELECT
    ROUND(AVG(creditos)::numeric, 2) AS promedio_creditos
FROM cursos;

-- Pregunta 6. Muestra el número de estudiantes inscritos por cada curso. (GROUP BY).
SELECT
    c.nombre AS curso,
    COUNT(i.id_estudiante) AS estudiantes_inscritos
FROM cursos c
LEFT JOIN inscripciones i
    ON c.id_curso = i.id_curso
GROUP BY c.id_curso, c.nombre
ORDER BY estudiantes_inscritos DESC;

-- ============================================================================
-- c. Consultas multitabla y avanzadas
-- ============================================================================

-- Pregunta 7. Muestra el nombre del estudiante y el nombre del curso para todas las inscripciones existentes. (INNER JOIN).
SELECT
    CONCAT(e.nombres, ' ', e.apellidos) AS estudiante,
    c.nombre AS curso
FROM inscripciones i
INNER JOIN estudiantes e
    ON i.id_estudiante = e.id_estudiante
INNER JOIN cursos c
    ON i.id_curso = c.id_curso
ORDER BY estudiante, curso;

-- Pregunta 8. Lista todos los profesores y los nombres de los cursos que imparten. Incluye a los profesores que no imparten ningún curso. (LEFT JOIN).
SELECT
    CONCAT(p.nombres, ' ', p.apellidos) AS profesor,
    COALESCE(c.nombre, 'Sin curso asignado') AS curso
FROM profesores p
LEFT JOIN cursos c
    ON p.id_profesor = c.id_profesor
ORDER BY profesor, curso;

-- Pregunta 9. Encuentra los estudiantes que están inscritos en el curso "Bases de Datos". (Subconsulta o JOIN).
SELECT
    CONCAT(e.nombres, ' ', e.apellidos) AS estudiante,
    c.nombre AS curso
FROM inscripciones i
INNER JOIN estudiantes e
    ON i.id_estudiante = e.id_estudiante
INNER JOIN cursos c
    ON i.id_curso = c.id_curso
WHERE c.nombre = 'Bases de Datos'
ORDER BY estudiante;

-- Pregunta 10. ¿Qué cursos tienen más de 5 estudiantes inscritos? (GROUP BY y HAVING).
SELECT
    c.nombre AS curso,
    COUNT(i.id_estudiante) AS estudiantes_inscritos
FROM cursos c
INNER JOIN inscripciones i
    ON c.id_curso = i.id_curso
GROUP BY c.id_curso, c.nombre
HAVING COUNT(i.id_estudiante) > 5
ORDER BY estudiantes_inscritos DESC;
