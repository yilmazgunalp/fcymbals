# CYMBAL FINDER APP #


###DATABASE SETUP###

1.Create a table to include all cymbals from all manufacturers:
	Sabian, Zildjian, Paiste, Meinl, Istanbul Mehmet, Agop, Bosphorus, Dream, UFIP ...

2.Create a table for all retailers in Australia to include all cymbals they have in stock
	a) Write a web-scraping script to automatically scrape retailer websites and update database

###APP FUNCTIONS###

1. Write a search algorithm to  list all cymbals based on query string which may include:
	brand,type,size,model,sku

2. Make and advanced search function

###FRONT END###

1.Make the front end.

2.Posibble features:
	* search by sound
	* add reviews
	* google ads
	* user sign up for updates
	* API for retailers



load data local infile  '~/ygprojects/hevna/db/manufacturers/bosphorus/_bosphorus.csv' into table makers fields terminated by ','  ignore 1 lines ;

<!-- SQL MODE CHANGE -->
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ZERO_IN_DATE' 


<!-- reset retailers to default maker -->
update retailers set maker_id=3604 where maker_id!=3604;

<!-- BACKUP MYSQL DATABASE -->
 mysqldump -u root -p cymbals > backup_cymbals

<!-- LOADING BACKUP DB INTO A NEW DB(back_up_test) -->
 mysql -u root -p back_up_test < backup_cymbals;

<!-- export table data to csv file -->
 select * from makers into outfile '/home/yilmazgunalp/Desktop/exportdb.csv' FIELDS TERMINATED BY ';' LINES TERMINATED BY '\n'


<!-- DUPLICATE MAKERS QUERY -->
select maker_id,model,size,kind,retailers.id,link,title from retailers join makers on maker_id = makers.id  where maker_id in (select makers.id from makers join retailers on (maker_id=makers.id and makers.id!=3604) group by makers.id  having count(retailers.id) > 1) and brand='sabian' order by maker_id;
