
#  I added for resque gem following instruction here: https://gist.github.com/Diasporism/5631030
if Rails.env == 'production'
  uri = URI.parse(ENV["REDISTOGO_URL"])
  Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
else 
# ENV["REDIS_URL"] = 'redis:localhost:6379'
$redis = Redis::Namespace.new("my_app", :redis => Redis.new)
end

