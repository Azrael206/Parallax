# Parallax — Documento de Especificación (v1, abierto a iteración)

**Proyecto personal de Alex. Uso propio, NO publicar.**

Herramienta para desglosar noticias y contenido de redes, separar hecho de narrativa,
y mapear el sesgo de las fuentes — para que el pensamiento crítico lo ponga Alex, no la app.

---

## 1. Qué es y qué NO es

**Es:** una app (Android, personal) que recibe una URL, un texto, un archivo o una
transcripción de vídeo, y devuelve un desglose estructurado: hechos duros por fuente,
qué omite cada medio, técnicas retóricas usadas, hacia qué lado tira la pieza y estado
de verificación de cada afirmación. Guarda un histórico compacto y una memoria creciente
de fuentes ya diagnosticadas.

**No es:** un juez de la verdad. No da un veredicto agregado, ni un porcentaje de sesgo,
ni un "% de desinformación". Da materia prima ordenada; la conclusión la saca Alex.

---

## 2. Decisiones cerradas (no volver a discutir sin motivo)

| Tema | Decisión |
|---|---|
| Plataforma | App **Android nativa** (Kotlin/Jetpack). Sin servidor, sin coste recurrente. |
| Input | URL, texto pegado, archivo, y **compartir desde TikTok/Instagram** (share target). |
| Origen del dev | Sin backend propio. La app llama a la API de Claude directamente (clave en la app; aceptable por ser uso personal single-user). |
| Modelo | **Haiku 4.5** por defecto ($1/$5 por millón tok). Salta a un modelo mejor solo si el resultado se queda corto. |
| Pago | Solo créditos en Claude Platform. Régimen "a ver cuánto aguanta" con ~20 € como referencia. |
| Idiomas | ES + EN. |
| Ámbito | Centrado en política, pero válido para cualquier tema. |
| Veredicto | **Prohibido** el veredicto agregado y el % de sesgo. Sesgo = etiqueta cualitativa + dirección + prueba concreta. Estado por afirmación: verificado / contradicho / no verificable. |
| "No lo sé" | Permitido y esperado. Si no es verificable, se dice. |
| Vídeo v1 | Alex pega la transcripción (subtítulos autogenerados o subtítulos en directo del móvil). La app la trata como texto. |
| Vídeo v2 | Auto-descarga + auto-transcripción (on-device). Diferido; se decide coste/curro entonces. |
| Memoria de fuentes | Al ver una fuente/@ nueva: diagnóstico provisional de línea editorial + por qué. Alex confirma. Una vez confirmado, se guarda y se reutiliza (no se rediagnostica). Reevaluable si la fuente cambia. |
| Histórico | Compacto: tema, fuentes, hechos clave, estado por afirmación, conclusión de Alex. SQLite local. |

---

## 3. Realidades técnicas que condicionan todo

1. **El móvil no "corre" el análisis.** Lo hace Claude en servidor. Batería/CPU del teléfono
   es un no-problema. El único punto sensible es dónde vive la clave de API (en la app, por ser personal).
2. **Claude no procesa audio ni vídeo.** Solo texto, imágenes y PDF. Por eso el vídeo necesita
   transcripción previa, y por eso la transcripción automática rompe la regla de "solo pago Claude"
   (obligaría a otra API de pago o a compute en servidor). → v1 = transcripción manual pegada.
3. **Compartir un TikTok/IG da una URL, no el archivo.** Descargar el vídeo para sacar audio
   requiere compute (yt-dlp). Otra razón para diferir el vídeo automático a v2.
4. **Paywalls:** fallback vía archive (archive.ph/today). Funciona a veces, es frágil y zona gris de ToS.
   Aceptable para uso personal; NO construir nada crítico que dependa de ello.

### Fuentes de transcripción gratis (v1 = pegar a mano, elige según el contenido)

| Contenido | Mejor fuente | Por qué / pega |
|---|---|---|
| Vídeo de TikTok / Instagram | **Subtítulos automáticos de la propia app** | Es el texto fiel de lo que se dice, sin recompresión. La opción más limpia. |
| Vídeo sin subtítulos | **Live Caption de Android** | Subtitula cualquier audio multimedia, aun en silencio. Pega: el texto es efímero, no se copia bien. |
| Voz tuya / nota de voz / llamada | **Essential Space / Essential Voice (Nothing)** | Graba por micro o llamada y transcribe; copias el texto directo. NO captura audio de otras apps. |

Regla: Essential es para TU voz o llamadas, no para el TikTok ajeno (grabaría el audio por micro,
con pérdida, y se procesa en el servidor de Nothing). Para vídeo de terceros, subtítulos nativos primero.

---

## 4. Fases

### v0 — Validar el cerebro (hoy, 0 € de dev, sin app)

Montar el **Prompt Maestro** (§6) en un Proyecto de Claude. Pegar URLs / texto / transcripciones
a mano. Probar con 5-10 casos reales (políticos y no). Objetivo: confirmar que el análisis es
bueno y útil ANTES de escribir una línea de Kotlin.

- **Entregable:** el prompt afinado + 5-10 análisis reales revisados.
- **Coste:** cero en API (va con la suscripción de claude.ai).

### v1 — App Android nativa

- Share target (intent filters) para recibir desde TikTok/IG/navegador.
- Fetch + parseo de artículos on-device (nativo = sin CORS). Fallback archive para paywalls.
- Llamada a Haiku con el Prompt Maestro.
- Memoria de fuentes en SQLite (diagnóstico → confirmación de Alex → guardado).
- Histórico compacto en SQLite.
- Vídeo: campo para pegar transcripción → pipeline de texto.
- **Entregable:** APK funcional que Alex usa a diario.
- **Coste:** solo tokens Haiku (~2-3 céntimos/análisis).

### v2 — Vídeo automático (opcional)

Auto-descarga del vídeo compartido + transcripción on-device (Whisper on-device o
reconocimiento del sistema). Se evalúa coste/curro llegado el momento.

---

## 5. Cuentas de coste (estimación, no factura)

- Haiku 4.5: **1 $/M entrada, 5 $/M salida** (verificado ago-2026).
- Por análisis de texto (~12k tok entrada + ~2,5k salida): **~2-3 céntimos**.
- ~20 € ≈ **500-1.000 análisis de texto**. Meses de uso personal.
- Palanca: caché de prompt (−90% en lo repetido, p. ej. la memoria de fuentes) lo estira más.
- Sube el coste: artículos muy largos, saltar a Sonnet en casos difíciles, o (v2) el vídeo.

---

## 6. PROMPT MAESTRO (el cerebro)

Vive en [`../prompts/prompt-maestro.md`](../prompts/prompt-maestro.md), listo para pegar
en el Proyecto de Claude. Esa es la copia canónica: cualquier cambio se hace ahí.

---

## 7. Esquema de datos (v1, SQLite local)

Versión ejecutable en [`esquema-datos.sql`](esquema-datos.sql).

**Tabla `fuentes`**

```
id | nombre_o_@ | plataforma (web/tiktok/instagram) | etiqueta_editorial |
descripcion_breve | confirmada (bool) | fecha_diagnostico | criterio | fecha_revision
```

Regla: `confirmada = true` solo tras el OK de Alex. El campo `criterio` guarda POR QUÉ,
para poder auditar/reevaluar. La app usa la etiqueta guardada y no rediagnostica si ya está confirmada.

**Tabla `analisis`**

```
id | fecha | tema | fuentes_usadas (ids) | resumen_compacto |
estado_verificacion_json | conclusion_alex (editable)
```

Solo se guarda el resumen compacto (punto 9 del prompt) y el estado por afirmación, no los
artículos completos.

---

## 8. Límites (qué NO hace, en cualquier versión)

- Ningún % de sesgo ni de desinformación. Ningún veredicto agregado de "verdad".
- No reproduce cuerpos completos de artículos de terceros (solo hechos + citas cortas + link).
- No decide por Alex: la etiqueta editorial de una fuente se guarda solo tras su confirmación.
- No promete "es auténtico" por ausencia de pruebas: "no verificable" se dice tal cual.
- No se convierte en producto público sin reevaluar el riesgo legal (LO 2/1984, honor). Eso
  sería otra conversación.

---

## 9. Criterio de "terminado"

- **v0 terminada:** el prompt produce, en 5-10 casos reales, un desglose que a Alex le ahorra
  trabajo frente a hacerlo a pelo, y cuya salida cabe en el resumen compacto.
- **v1 terminada:** Alex comparte un enlace/pega un texto desde el móvil y recibe el desglose
  completo (§6), con la etiqueta editorial de cada fuente visible, la memoria de fuentes
  creciendo con su confirmación, y el histórico guardándose — todo sin ningún juicio de verdad
  generado por el sistema.

---

## 10. Primer paso ahora mismo

Pegar el Prompt Maestro (§6) en un Proyecto de Claude nuevo llamado "Parallax" y lanzar
el primer caso real de hoy. Nada de Kotlin hasta que el cerebro esté validado.
