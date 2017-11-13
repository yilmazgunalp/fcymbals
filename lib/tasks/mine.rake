


namespace :myrake do

desc "heroku update"
task :herokup do 
sh 'git add .'
sh 'git commit'
sh 'git push heroku master' 
end

desc "testing task with parameters"
task :param, [:var] => :git_status do |task, args|
puts "var in `second` is #{args.var.inspect}"
end	

desc "backs up db"
task :exporttable, [:var] do |task, args|
args.with_defaults(var: 'makers')	

if ENV["RAILS_ENV"] = "development"
ActiveRecord::Base.establish_connection({"database" => :cymbals, "adapter" => "mysql2","password" => "PJPL2EXX" })
ActiveRecord::Base.connection.execute("select * from #{args.var} into outfile '/home/yilmazgunalp/Desktop/#{args.var + '_' + Time.now.strftime('%Y%m%d%H%M')}.csv' FIELDS 
	TERMINATED BY ';' LINES TERMINATED BY '\n'")
end
if ENV["RAILS_ENV"] = "production"
puts "noW in PRODUCTION"	
end
end	

end	

