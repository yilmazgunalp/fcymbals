
namespace :myrake  do
desktop = '/home/yilmazgunalp/Desktop/' 	
backup_path = "/home/yilmazgunalp/ygprojects/fcymbals/db/back_up/"
time_stamp =  '_' + Time.now.strftime('%Y%m%d%H%M')
push_table_file = nil


desc "heroku update"
	task :herokup do 
		sh 'git add .'
		sh 'git commit'
		sh 'git push heroku master' 
	end

desc "background scraping"
	task :bg do 
		system "BACKGROUND=yes rake resque:scheduler"
		sleep(3)
		system "INTERVAL=3 QUEUE=* rake resque:work"
	end	

desc "connect to redis"
	task :redis do 
		system "redis-cli -h grouper.redistogo.com -p 11403 -a 0bb85d0940c51b3cc18334cead512f5c"
	end	


namespace :db  do

desc "exports selected db table (default: makers) to Csv"
	task :exporttable, [:table]  do |task, args|
		args.with_defaults(table: 'makers')
		file_name = backup_path+args.table.capitalize+time_stamp+".csv"	
		puts "Exporting  #{args.table} into #{file_name} "
		system "psql -d cymbals -U postgres -c \"COPY #{args.table} to \'#{file_name}\' delimiter \'~\' CSV HEADER ;\""
		push_table_file = file_name
		puts "Export Completed!..\n"
	end	

desc "pushes makers table from local to production"
	task :pushtable => [:backupdevdb, :exporttable] do 
		lines =  `wc -l #{push_table_file} | cut -d' ' -f1`
		makers_count = `psql -d cymbals -c "select count(*) from makers" | grep -B1 "(1 row)"`.match(/\d+/)[0]
		
		if lines.to_i == makers_count.to_i+1
			puts "PREPARING TO PUSH MAKERS TO PRODUCTION.."
			system "psql -h ec2-54-163-232-171.compute-1.amazonaws.com -d d540c41u721f1g -U njfxzqdlfhanit -p 5432 -c 'delete from makers ;'"
			system "psql -h ec2-54-163-232-171.compute-1.amazonaws.com -d d540c41u721f1g -U njfxzqdlfhanit -p 5432 -c \"\\copy makers from \'#{push_table_file}\' with delimiter as '~' csv header;\""
		else
			puts "WARNING! \n Makers table was not completely exported. Can not push table to production!"
		end	
		puts "DONE!"
	end	 #pushtable

desc "backs up production database"
	task :backupprodb do 
		puts "...backing up database in PRODUCTION ENV..\n..."		
		sh 'heroku pg:backups:capture'
	end	

desc "backs up development database"
	task :backupdevdb do 
		puts "...backing up database in DEVELOPMENT ENV..\n..."	
		sh  "pg_dump -U postgres -W -F t cymbals > #{backup_path+"cymbals"+time_stamp}.tar"
		puts "DONE!..Backup completed!\n"
	end	

desc "restores a backup file into a new  DEVELOPMENT database"
	task :restoredevdb, [:database,:backup_file] do |task,args| 
		puts "...restoring CYMBALS DB in DEVELOPMENT ENV..\n..."	
		sh  "pg_restore -U postgres -W --dbname=#{args.database} --verbose #{backup_path+args.backup_file}"
		puts "...DONE!"
	end	

desc "uploads local db to production"
	task :localdbtoproduction do 
		sh "heroku pg:reset"
		sleep(7)
		sh "heroku pg:push cymbals postgresql-octagonal-23089"
	end

desc "downloads production db to local db"
	task :productiondbtolocal do
		puts "Dropping local database -cymbals-..."
		sh 'psql -c "DROP DATABASE cymbals"'
		puts "Pulling production db to local -cymbals-..."
		sh 'heroku', 'pg:pull', 'postgresql-octagonal-23089', 'cymbals'
	end

desc "connects to aws db!!credentials are not permanent. use heroku pg:credentials:url to get the latest"
	task :awsconnect do
		sh 'psql -h ec2-54-163-232-171.compute-1.amazonaws.com -d d540c41u721f1g -U njfxzqdlfhanit -p 5432'
	end


end #db
end	#myrake

task "jobs:work" => "myrake:bg"


