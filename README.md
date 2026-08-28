# Parallax

Herramienta personal para desglosar noticias y contenido de redes: separar hecho de
narrativa y mapear el sesgo de las fuentes. **El pensamiento crítico lo pone Alex, no la app.**

> Proyecto personal. Uso propio, **no publicar**.

## Qué hace

Recibe una URL, un texto, un archivo o una transcripción de vídeo y devuelve un desglose
estructurado: hechos duros por fuente, qué omite cada medio, técnicas retóricas, hacia qué
lado tira la pieza y estado de verificación por afirmación.

## Qué NO hace

- Ningún veredicto agregado de "verdad".
- Ningún porcentaje de sesgo ni de desinformación.
- No decide por Alex: la etiqueta editorial de una fuente solo se guarda tras su confirmación.
- No dice "es auténtico" por ausencia de pruebas: **"no verificable" se dice tal cual**.

## Estado actual: **v0 — validar el cerebro**

Cero código. Se valida el Prompt Maestro a mano en un Proyecto de Claude antes de
escribir una línea de Kotlin.

| Fase | Qué es | Estado |
|---|---|---|
| v0 | Prompt Maestro validado con 5-10 casos reales | 🟡 en curso |
| v1 | App Android nativa (share target, SQLite, Haiku 4.5) | ⬜ bloqueada por v0 |
| v2 | Vídeo automático (descarga + transcripción on-device) | ⬜ diferida |

## Cómo arrancar v0

1. Crear un Proyecto en claude.ai llamado **Parallax**.
2. Pegar [`prompts/prompt-maestro.md`](prompts/prompt-maestro.md) como instrucciones del proyecto.
3. Lanzar un caso real. Copiar la salida a `docs/v0-casos/` usando
   [`docs/v0-casos/PLANTILLA.md`](docs/v0-casos/PLANTILLA.md).
4. Anotar en la plantilla qué falló y afinar el prompt. Repetir hasta 5-10 casos.

**v0 termina** cuando el desglose le ahorra trabajo real a Alex frente a hacerlo a pelo,
y su salida cabe en el resumen compacto del punto 9.

## Mapa del repo

```
README.md                     esto
docs/ESPECIFICACION.md        el documento de especificación v1 (fuente de verdad)
docs/esquema-datos.sql        esquema SQLite de v1 (referencia, aún sin usar)
docs/v0-casos/PLANTILLA.md    plantilla para registrar cada caso de prueba
prompts/prompt-maestro.md     el cerebro: pegar en el Proyecto de Claude
```

## Coste (estimación, no factura)

Haiku 4.5 a 1 $/M entrada y 5 $/M salida ⇒ **~2-3 céntimos por análisis de texto**.
~20 € ≈ 500-1.000 análisis. La caché de prompt (memoria de fuentes) lo estira más.
