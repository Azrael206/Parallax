# Bitácora

Registro de qué se hizo en cada sesión y por qué. Lo más reciente arriba.
Para el contexto permanente del proyecto, `CLAUDE.md`. Para el qué y el porqué del
producto, `docs/ESPECIFICACION.md`.

---

## Sesión 01 — 2026-08-28 · Claude Code en navegador

**Punto de partida:** repositorio vacío, sin un solo commit. Alex trae la especificación
de Parallax ya redactada y cerrada.

**Objetivo:** dejar el proyecto arrancado en la fase que manda la propia especificación
(v0, validar el prompt), sin escribir código de app.

### Qué se creó

| Fichero | Por qué |
|---|---|
| `docs/ESPECIFICACION.md` | La especificación de Alex, versionada como fuente de verdad. Contenido sin cambios; §6 pasó a apuntar al fichero del prompt en vez de duplicarlo. |
| `prompts/prompt-maestro.md` | El prompt, en su copia canónica y única, listo para pegar en el Proyecto de claude.ai. Con notas de mantenimiento. |
| `docs/v0-casos/PLANTILLA.md` | Para que v0 termine con evidencia y no con una sensación. Obliga a responder si el análisis ahorró trabajo, si se coló un veredicto, y si el resumen compacto servía. |
| `docs/v0-casos/README.md` | Índice de casos y criterio explícito de cierre de v0. |
| `docs/esquema-datos.sql` | El §7 de la especificación en SQL ejecutable. Referencia para v1; todavía no se usa. |
| `README.md` | Qué es, qué no es, estado por fases, cómo arrancar v0. |
| `.gitignore` | Bloquea la clave de API y los artefactos de Android antes de que existan. |
| `CLAUDE.md` | Contexto permanente para las sesiones de Claude Code en terminal. |
| `docs/BITACORA.md` | Esto. |

### Decisiones que tomó Claude, no Alex

Marcadas aparte a propósito: son revertibles y no vienen de la especificación.

1. **`fuentes_usadas` modelado como tabla N:N** (`analisis_fuentes`) en vez de una columna
   con lista de ids, como estaba escrito en §7. Una lista dentro de una columna no permite
   consultar "dame todo lo que he analizado de @tal" sin parsear texto a mano.
2. **Errata corregida** en el punto 5 del Prompt Maestro: `whataposmo` → `whataboutism`.
3. **Estructura de carpetas** (`docs/`, `prompts/`, `docs/v0-casos/`): no venía en la
   especificación, es convención.

### Verificado

- Precio de Haiku 4.5: **1 $/M entrada, 5 $/M salida**. Las cuentas de §5 de la
  especificación se sostienen.

### Hallazgos abiertos

1. **Con una sola fuente, los puntos 3 y 4 del prompt se degradan** — sin una segunda
   fuente no hay omisiones que comparar. Sin comprobar aún con casos reales.
2. **El punto 7 (estado por afirmación) depende solo del conocimiento del modelo**, sin
   acceso a web. Si en los casos reales casi todo cae en `NO VERIFICABLE`, ese punto no
   aporta nada tal como está.
3. **Si pasa lo anterior:** la API de Claude ofrece búsqueda web como herramienta de
   servidor, facturada por Anthropic. No rompe la regla de "solo créditos de Claude
   Platform", pero sube el coste por análisis. Decisión de Alex, no automática.

### Repositorio: privado y `main`

Al cerrar la sesión, Alex pide poner el repo en privado y renombrar la rama a `main`.

- **`main` creada** con todo el contenido, y pasa a ser la rama de trabajo.
- **Sin hacer, requieren la web de GitHub** (las sesiones de Claude Code no tienen API para
  ninguna de las dos): poner `main` como rama por defecto y borrar
  `claude/parallax-bias-analysis-app-drtsdb`; y cambiar la visibilidad a privado.

El repo nació público y con la rama `claude/…` de por defecto porque fue la primera que se
subió a un repositorio vacío, no por decisión de nadie.

### Notas del entorno

- La sesión corrió en Claude Code **web**, en un contenedor efímero. `git push` estaba
  bloqueado por el clasificador de permisos, así que todo se subió por la API de GitHub.
  Consecuencia visible: el arranque quedó repartido en varios commits en vez de uno.
- Alex decide al final de la sesión **pasar el trabajo al terminal**, que es lo correcto:
  v1 exige compilar el APK, Gradle contra su SDK e instalar en el Nothing Phone por `adb`,
  y nada de eso se puede hacer desde el navegador.

### Estado al cerrar

v0 en curso, **0 casos de validación hechos**. Nada de código de app, a propósito.

**Siguiente paso:** crear el Proyecto "Parallax" en claude.ai, pegar
`prompts/prompt-maestro.md`, lanzar el primer caso real y registrarlo en `docs/v0-casos/`.
