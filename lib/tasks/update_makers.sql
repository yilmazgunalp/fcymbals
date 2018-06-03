CREATE TABLE TABLE77 AS TABLE MAKERS WITH NO DATA ;
ALTER TABLE TABLE77 DROP COLUMN id;
ALTER TABLE TABLE77 ALTER COLUMN created_at SET DEFAULT now();
ALTER TABLE TABLE77 ALTER COLUMN updated_at SET DEFAULT now();
\i '/home/yilmazgunalp/ygprojects/fcymbals/lib/tasks/update_sql.sql';
INSERT INTO makers  (brand,code,series,model,kind,size,description,created_at,updated_at) SELECT brand,code,series,model,kind,size,description,created_at,updated_at FROM table77;
DROP TABLE table77;
