CREATE TABLE TABLE88 AS TABLE RETAILERS WITH NO DATA ;
\i '/home/yg/ygprojects/fcymbals/lib/tasks/copy_sql.sql';
INSERT INTO RETAILERS SELECT * FROM table88
ON CONFLICT(id) DO UPDATE SET maker_id = EXCLUDED.maker_id;
DROP TABLE table88;
