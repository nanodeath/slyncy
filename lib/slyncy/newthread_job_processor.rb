require File.join(File.dirname(__FILE__), %w[job_processor])

module Slyncy
  # The NewthreadJobProcessor is asynchronous, but really dumb.  It just spins
  # up a thread whenever a new job is handed to it.
  class NewthreadJobProcessor < JobProcessor
    # :stopdoc:
    def initialize
      super
      @job_class = NewthreadJobProcessor::Job
    end

    class Job < JobProcessor::Job
      def initialize(&block)
        @thread = Thread.new(&block)
      end

      def redeem(timeout)
        return @result if @done
        begin
          begin
            if(timeout > 0)
              Timeout::timeout(timeout) do
                @result = @thread.value
              end
            else
              @result = @thread.value
            end
          rescue TimeoutError => e
            raise Slyncy::TimeoutException
          end
        rescue Exception => e
          @exception = e
        end
        @done = @exception.nil?
        nil
      end
    end
    # :startdoc:
  end
end
