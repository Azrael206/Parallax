-- Parallax — esquema SQLite local (v1)
-- Referencia. Todavía no se usa: v1 está bloqueada hasta validar v0.

PRAGMA foreign_keys = ON;

-- Memoria de fuentes: se diagnostica una vez, Alex confirma, y se reutiliza.
CREATE TABLE IF NOT EXISTS fuentes (
    id                INTEGER PRIMARY KEY AUTOINCREMENT,
    nombre_o_arroba   TEXT    NOT NULL,
    plataforma        TEXT    NOT NULL CHECK (plataforma IN ('web', 'tiktok', 'instagram')),
    etiqueta_editorial TEXT   NOT NULL,   -- cualitativa: "centro-derecha, enfoque económico"
    descripcion_breve TEXT,
    -- true SOLO tras el OK explícito de Alex. La app no rediagnostica lo confirmado.
    confirmada        INTEGER NOT NULL DEFAULT 0 CHECK (confirmada IN (0, 1)),
    fecha_diagnostico TEXT    NOT NULL,   -- ISO-8601
    criterio          TEXT,               -- POR QUÉ esa etiqueta: permite auditar y reevaluar
    fecha_revision    TEXT,               -- última reevaluación, si la fuente ha cambiado
    UNIQUE (nombre_o_arroba, plataforma)
);

-- Histórico compacto: nunca el artículo entero, solo el punto 9 del Prompt Maestro.
CREATE TABLE IF NOT EXISTS analisis (
    id                       INTEGER PRIMARY KEY AUTOINCREMENT,
    fecha                    TEXT NOT NULL,   -- ISO-8601
    tema                     TEXT NOT NULL,
    resumen_compacto         TEXT NOT NULL,   -- 4-6 líneas
    estado_verificacion_json TEXT,            -- [{"afirmacion": ..., "estado": "NO_VERIFICABLE"}]
    conclusion_alex          TEXT             -- editable a mano; la app nunca la rellena
);

-- fuentes_usadas: relación N:N, en vez de una lista de ids en una columna.
CREATE TABLE IF NOT EXISTS analisis_fuentes (
    analisis_id INTEGER NOT NULL REFERENCES analisis(id) ON DELETE CASCADE,
    fuente_id   INTEGER NOT NULL REFERENCES fuentes(id)  ON DELETE RESTRICT,
    PRIMARY KEY (analisis_id, fuente_id)
);

CREATE INDEX IF NOT EXISTS idx_analisis_fecha ON analisis(fecha DESC);
CREATE INDEX IF NOT EXISTS idx_fuentes_confirmada ON fuentes(confirmada);
