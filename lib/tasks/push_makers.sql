CREATE TABLE TABLE77 AS TABLE MAKERS WITH NO DATA ;
\i '/home/yilmazgunalp/ygprojects/fcymbals/lib/tasks/copy_sql.sql';
INSERT INTO makers SELECT * FROM table77
ON CONFLICT(id) DO UPDATE SET code = EXCLUDED.code, series = EXCLUDED.series, model = EXCLUDED.model,
kind = EXCLUDED.kind, size = EXCLUDED.size, description = EXCLUDED.description;
DROP TABLE table77;
