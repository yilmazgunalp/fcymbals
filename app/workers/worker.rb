class Worker
  attr_reader :name,:pid

  def initialize(name, queue)
    @name = name
    @queue = queue
    @pid = Thread.new { perform }
  end

  def join
    @pid.join
  end

  private

  def perform
    while (job = @queue.pop)
      break if job == :done
       puts "#{name}_@#{pid} got #{job}" # only for debugging
      eval(job)
      end
  end
end