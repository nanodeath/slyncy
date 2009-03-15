require 'thread'
module Slyncy
  class JobProcessor
    def initialize
      @job_class = Job
      @jobs = Queue.new
    end
 
    def accept(&job)
      j = @job_class.new(&job)
      @jobs << j
      j
    end

    class Job
      attr_reader :result
      attr_reader :done
      attr_reader :exception
      
      def initialize(&block)
        @done = false
        @block = block
      end

      def redeem(timeout)
        raise "No default implementation of Job#redeem"
      end
    end
  end
end
