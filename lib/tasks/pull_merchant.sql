CREATE TABLE TABLE99 AS TABLE RETAILERS WITH NO DATA ;
\i '/home/yilmazgunalp/ygprojects/fcymbals/lib/tasks/copy_sql.sql';
INSERT INTO RETAILERS SELECT * FROM table99
-- ON CONFLICT(id) DO UPDATE SET maker_id = EXCLUDED.maker_id;
-- -- DROP TABLE table88;