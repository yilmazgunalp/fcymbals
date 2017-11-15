
namespace :myrake  do
desktop = '/home/yilmazgunalp/Desktop/' 	
backup_path = '/home/yilmazgunalp/ygprojects/fcymbals/db/back_up/'
time_stamp =  '_' + Time.now.strftime('%Y%m%d%H%M')

desc "heroku update"
task :herokup do 
sh 'git add .'
sh 'git commit'
sh 'git push heroku master' 
end

namespace :db  do

desc "exports selected db table (default: makers) to Csv"
task :exporttable, [:var]  do |task, args|
args.with_defaults(var: 'makers')	

if Rails.env == "development"
	ActiveRecord::Base.establish_connection({"database" => :cymbals, "adapter" => "mysql2","password" => "PJPL2EXX" })
	ActiveRecord::Base.connection.execute("select * from #{args.var} into outfile '#{desktop+args.var+time_stamp}.csv' FIELDS 
		TERMINATED BY ';' LINES TERMINATED BY '\n'")
cp 	"#{desktop+args.var+time_stamp}.csv", backup_path
rm "#{desktop+args.var+time_stamp}.csv"
elsif Rails.env == "production"
sh 'heroku pg:backups:capture'	
end
end	

desc "backs up database"
task :backupdb do 
if Rails.env == "development"
puts "...backing up database in DEVELOPMENT ENV..\n..."	
sh "mysqldump -u root -pPJPL2EXX cymbals > #{backup_path}backup_cymbals#{time_stamp}"
puts "...done!"
elsif Rails.env == "production"
puts "This task is only defined for DEVELOPMENT Environment"	
end
end	

desc "uploads local db to production"
task :localdbtoproduction do 

end

end
end	

