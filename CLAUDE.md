# CLAUDE.md — contexto de Parallax

Léelo antes de tocar nada. Hablo español; tutéame, directo y sin paja.

## Qué es esto

Herramienta personal para desglosar noticias y contenido de redes: separar hecho de
narrativa y mapear el sesgo de las fuentes. **El pensamiento crítico lo pone Alex, no la app.**

La especificación completa es `docs/ESPECIFICACION.md` y es la **fuente de verdad**.
Si algo aquí la contradice, gana la especificación.

## Reglas duras del proyecto (no negociables)

1. **Ningún veredicto agregado de "verdad". Ningún porcentaje de sesgo o desinformación.**
   El sesgo se expresa cualitativo + direccional + con la prueba concreta. Si alguna vez
   propones un score, un índice o un "% de fiabilidad", te has salido del proyecto.
2. **"No verificable" se dice tal cual.** No rellenar huecos, no inferir autenticidad por
   ausencia de pruebas.
3. **No se publica.** Proyecto personal, uso propio. Convertirlo en producto público exige
   reevaluar el riesgo legal (LO 2/1984, honor) — otra conversación, no una decisión de paso.
4. **La clave de la API de Claude NUNCA se commitea.** Va en `local.properties` (ya
   ignorado). El repo es público, ver "Pendientes" abajo.
5. **La etiqueta editorial de una fuente solo se guarda tras la confirmación de Alex**
   (`fuentes.confirmada = 1`). El sistema propone; Alex decide.

## Estado: v0 — validar el cerebro

**Cero código de app, a propósito.** Nada de Kotlin hasta que el Prompt Maestro esté
validado con 5-10 casos reales. Esto está en la especificación §4 y §10, y es deliberado:
la app es un envoltorio; si el prompt no sirve, la app tampoco.

| Fase | Qué es | Estado |
|---|---|---|
| v0 | Prompt Maestro validado con 5-10 casos reales | 🟡 en curso, 0 casos hechos |
| v1 | App Android nativa (share target, SQLite, Haiku 4.5) | ⬜ bloqueada por v0 |
| v2 | Vídeo automático (descarga + transcripción on-device) | ⬜ diferida |

### Cómo se avanza en v0

1. El Prompt Maestro (`prompts/prompt-maestro.md`) va pegado en un Proyecto de claude.ai
   llamado "Parallax".
2. Cada caso real se registra en `docs/v0-casos/NN-slug.md`, copiando `PLANTILLA.md`.
3. Lo que falle se corrige en `prompts/prompt-maestro.md` y se commitea. **Ese fichero es
   la copia canónica del prompt** — no dupliques el prompt en otro sitio.
4. Se actualiza la tabla de `docs/v0-casos/README.md`.

**v0 termina** cuando 5-10 casos seguidos le ahorran trabajo real a Alex, ninguno cuela un
veredicto ni un porcentaje, y el resumen compacto (punto 9 del prompt) sirve tal cual para
el histórico.

## Mapa del repo

```
CLAUDE.md                     esto
README.md                     resumen del proyecto y cómo arrancar v0
docs/ESPECIFICACION.md        fuente de verdad
docs/esquema-datos.sql        esquema SQLite de v1 (referencia, aún sin usar)
docs/v0-casos/                plantilla, índice y los casos de validación
prompts/prompt-maestro.md     el cerebro (copia canónica)
```

## Decisiones ya cerradas (no re-discutir sin motivo nuevo)

Android nativo Kotlin/Jetpack · sin backend propio · la app llama a la API de Claude
directamente con la clave dentro (aceptable por ser single-user personal) · **Haiku 4.5**
por defecto, saltar de modelo solo si se queda corto · solo créditos de Claude Platform,
~20 € de referencia · ES + EN · vídeo v1 = transcripción pegada a mano.

Tabla completa con los porqués: `docs/ESPECIFICACION.md` §2.

## Qué vigilar cuando corran los casos de v0

Tres cosas detectadas al montar el repo, aún sin comprobar con casos reales:

1. **Con una sola fuente los puntos 3 y 4 del prompt se caen** — no hay con qué comparar
   omisiones. El punto 4 se convierte en "qué falta que cabría esperar", que es otra cosa.
   Puede que haya que decírselo explícitamente al prompt.
2. **El punto 7 (estado por afirmación) depende solo del conocimiento del modelo, sin web.**
   Si casi todo cae en `NO VERIFICABLE`, ese punto no vale para nada tal como está.
3. **Si pasa lo anterior:** la API de Claude tiene búsqueda web como herramienta de servidor,
   facturada por Anthropic — no rompe la regla de "solo créditos de Claude Platform", pero
   sube el coste por análisis. Decisión de Alex, no automática.

## Pendientes / abiertos

- **El repo es público.** Choca con el "uso propio, NO publicar" de la especificación, y es
  un riesgo real de cara a v1 (cualquier secreto commiteado por error se escanea en
  segundos). Ponerlo en privado en Settings → General → Danger Zone.
- La rama de trabajo es `claude/parallax-bias-analysis-app-drtsdb`, que además es la rama
  por defecto del repo (fue la primera que se subió). Si prefieres `main`, se renombra.

## Convenciones

- Commits y documentación en español.
- El histórico y la memoria de fuentes guardan **solo el resumen compacto**, nunca el
  cuerpo de los artículos de terceros (§8 de la especificación).
- Al añadir tablas o campos, mantener `docs/esquema-datos.sql` alineado con §7.
