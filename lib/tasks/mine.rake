
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

desc "background scraping"
task :bg do 
system "BACKGROUND=yes rake resque:scheduler"
sleep(3)
system "QUEUE=* rake resque:work"
end	

namespace :db  do


desc "exports selected db table (default: makers) to Csv"
task :exporttable, [:table]  do |task, args|
args.with_defaults(table: 'makers')	
puts "YET TO BE IMPLEMENTED"
end	

desc "backs up production database"
task :backupprodb do 
puts "...backing up database in PRODUCTION ENV..\n..."		
sh 'heroku pg:backups:capture'
end	
desc "backs up development database"
task :backupdevdb do 
puts "...backing up database in DEVELOPMENT ENV..\n..."	
sh  "pg_dump -U postgres -W -F t cymbals > #{backup_path+"cymbals"+time_stamp}.tar"
puts "...DONE!"
end	

desc "restores a backup file into a new database"
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

end
end	

