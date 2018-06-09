CREATE TABLE TABLE77 AS TABLE MAKERS WITH NO DATA ;
ALTER TABLE TABLE77 ALTER COLUMN created_at SET DEFAULT now();
ALTER TABLE TABLE77 ALTER COLUMN updated_at SET DEFAULT now();
\i '/home/yg/ygprojects/fcymbals/lib/tasks/upsert_sql.sql';
INSERT INTO makers  (id,brand,code,series,model,kind,size,description,created_at,updated_at) SELECT id,brand,code,series,model,kind,size,description,created_at,updated_at FROM table77
ON CONFLICT(id) DO UPDATE SET code = EXCLUDED.code, series = EXCLUDED.series, model = EXCLUDED.model,
kind = EXCLUDED.kind, size = EXCLUDED.size, description = EXCLUDED.description, brand=EXCLUDED.brand;
DROP TABLE table77;
