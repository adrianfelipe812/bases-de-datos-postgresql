# Aplicación de este conocimiento en otras áreas

Toda analítica descansa sobre datos bien modelados. Lo que se practica aquí, **traducir reglas de negocio a un esquema que impide datos inconsistentes**, es igual de útil en un sistema transaccional que en una bodega de datos.

## Habilidades que se transfieren

| Habilidad del proyecto | Uso general |
|---|---|
| Modelo entidad-relación desde reglas de negocio | Levantar requerimientos con usuarios y convertirlos en estructura |
| Normalización a 3FN | Evitar duplicidad y anomalías en sistemas operativos |
| Entidades débiles y claves compuestas | Modelar eventos que solo existen dentro de otro (líneas de factura, cuotas de un crédito) |
| Restricciones `CHECK`, `UNIQUE`, FK | Garantizar calidad de datos desde la fuente, no después |
| Triggers con reglas entre tablas | Validaciones de negocio que dependen de varias tablas |
| Pruebas negativas en SQL | Verificar que las reglas realmente bloquean lo que deben bloquear |

## Ejemplos por sector

- **Salud humana.** El mismo flujo paciente → cita → diagnóstico → fórmula → medicamento sirve para una IPS o consultorio; las reglas de vacunas vencidas aplican igual.
- **Comercio y facturación.** Cliente → pedido → línea de pedido → producto; inventario con lotes y fechas de vencimiento (alimentos, farmacia).
- **Educación.** Estudiante → matrícula → curso → nota, que es el tipo de base sobre la que trabaja `consultas_universidad.sql`.
- **Banca.** Cliente → producto → transacción, con restricciones que impiden saldos o fechas inválidas.
- **Logística.** Envío → paquete → evento de rastreo, con estados controlados por `CHECK` como en las citas.
- **Ingeniería de datos y BI.** Entender 3FN es el punto de partida para diseñar modelos en estrella (hechos y dimensiones) en Power BI o Databricks, y para saber cuándo desnormalizar.

## Cómo se adaptaría

1. Escribir primero las reglas de negocio en una tabla (como en el documento del proyecto).
2. Identificar entidades fuertes, débiles y atributos multivaluados.
3. Implementar las reglas más importantes como restricciones y triggers, no solo en la aplicación.
4. Acompañar el DDL con datos de prueba y pruebas negativas, como en `sql/03_consultas_validacion.sql`.
