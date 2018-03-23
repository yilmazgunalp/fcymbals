class WorkerPool
  def initialize(num_workers)
     @queue = SizedQueue.new(num_workers)
    @workers = Array.new(num_workers) { |n| 
      Worker.new("worker_#{n}", @queue) 
    }
  end

  def <<(job)
    if job == :done
      @workers.size.times { @queue << :done }
    else
      @queue << job
    end
  end

  def wait
    @workers.map(&:join)
  end
end