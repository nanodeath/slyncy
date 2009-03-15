require File.join(File.dirname(__FILE__), %w[job_processor])

module Slyncy
  class JITJobProcessor < JobProcessor
    def initialize
      super
      @job_class = JITJobProcessor::Job
    end

    class Job < JobProcessor::Job
      def redeem(timeout)
        return @result if @done
        begin
          begin
            if(timeout > 0)
              Timeout::timeout(timeout) do
                @result = @block.call
              end
            else
              @result = @block.call
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
  end
end
