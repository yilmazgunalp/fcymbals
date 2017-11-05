class MakersController < ApplicationController
  def index
  	@cymbals = Maker.all
  	Resque.enqueue_at(60.seconds.from_now,TestingJob)
	Resque.enqueue(SleepingJob)
 Resque.enqueue(CleanupJob,3699)
  	
  end
end
