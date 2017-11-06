
namespace :my_rake do

desc "writing my own rake:)"
task :data => 'resque:scheduler' do 
puts "wow did my first rake task"
end

desc "check git status"
task :git_status do 
sh 'git status' 
end

end	