require 'resque/tasks'
require 'resque/scheduler/tasks'
task "resque:setup" => :environment

# namespace :resque do
    #   task :setup  do 
    #     require 'resque'
    #     ENV['QUEUE'] = '*'
        
    #   end #setup

    # task :setup_schedule => :setup do
    #     require 'resque-scheduler' 
        
    #     # If you want to be able to dynamically change the schedule,
    #     # uncomment this line.  A dynamic schedule can be updated via the
    #     # Resque::Scheduler.set_schedule (and remove_schedule) methods.
    #     # When dynamic is set to true, the scheduler process looks for
    #     # schedule changes and applies them on the fly.
    #     # Note: This feature is only available in >=2.0.0.
    #     # Resque::Scheduler.dynamic = true

    #     # If your schedule already has +queue+ set for each job, you don't
    #     # need to require your jobs.  This can be an advantage since it's
    #     # less code that resque-scheduler needs to know about. But in a small
    #     # project, it's usually easier to just include you job classes here.
    #     # So, something like this:
    #     # require 'jobs'
    #   end #setup_schedule


    # # task :scheduler => :setup_schedule  do 

    # # end #scheduler   

    # end #resque


namespace :resque do
  task :setup

  desc "Start a Resque worker"
  task :work => [ :preload, :setup ] do
    require 'resque'

    begin
      worker = Resque::Worker.new
    rescue Resque::NoQueueError
      abort "set QUEUE env var, e.g. $ QUEUE=critical,high rake resque:work"
    end
    fork do  
    puts "inside the fork" 
    Resque.schedule = YAML.load_file("#{Rails.root}/app/jobs/_schedule.yml")
    Resque::Scheduler.run
    puts "at the end of the fork"
    end #fork 
    puts "after the fork"

    worker.prepare
    worker.log "Starting worker #{self}"
    worker.work(ENV['INTERVAL'] || 5) # interval, will block
  end

  desc "Start multiple Resque workers. Should only be used in dev mode."
  task :workers do
    threads = []

    if ENV['COUNT'].to_i < 1
      abort "set COUNT env var, e.g. $ COUNT=2 rake resque:workers"
    end

    ENV['COUNT'].to_i.times do
      threads << Thread.new do
        system "rake resque:work"
      end
    end

    threads.each { |thread| thread.join }
  end

  # Preload app files if this is Rails
  task :preload => :setup do
    if defined?(Rails)
      if Rails::VERSION::MAJOR > 3
        ActiveSupport.run_load_hooks(:before_eager_load, Rails.application)
        Rails.application.config.eager_load_namespaces.each(&:eager_load!)

      elsif Rails::VERSION::MAJOR == 3
        ActiveSupport.run_load_hooks(:before_eager_load, Rails.application)
        Rails.application.eager_load!

      elsif defined?(Rails::Initializer)
        $rails_rake_task = false
        Rails::Initializer.run :load_application_classes
      end
    end
  end

 

  namespace :failures do
    desc "Sort the 'failed' queue for the redis_multi_queue failure backend"
    task :sort do
      require 'resque'
      require 'resque/failure/redis'

      warn "Sorting #{Resque::Failure.count} failures..."
      Resque::Failure.each(0, Resque::Failure.count) do |_, failure|
        data = Resque.encode(failure)
        Resque.redis.rpush(Resque::Failure.failure_queue_name(failure['queue']), data)
      end
      warn "done!"
    end
  end
end



Resque.after_fork = Proc.new { ActiveRecord::Base.establish_connection } #this is necessary for production environments, otherwise your background jobs will start to fail when hit from many different connections.

desc "Alias for resque:work (To run workers on Heroku)"
task "jobs:work" => "resque:work"