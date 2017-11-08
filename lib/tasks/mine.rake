
namespace :myrake do

desc "writing my own rake:)"
task :data => 'resque:scheduler' do 
puts "wow did my first rake task"
end

desc "check git status"
task :git_status do |task, args|
sh 'git status' 
p  task.methods 	
end

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

end	