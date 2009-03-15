module Slyncy
  def slyncy(&block)
    SlyncyCall.new(&block)
  end

  def slyncy_batch
    SlyncyCallBatch.new
  end

  def self.job_processor
    @job_processor ||= options[:job_processor].new
  end

  class SlyncyCall
    attr_reader :exception
    def initialize(&block)
      @ticket = Slyncy.job_processor.accept(&block)
      @exception = nil
    end

    def timed_out?
      @exception.is_a? TimeoutException
    end

    def done?(timeout=-1)
      @ret = @ticket.redeem(timeout)
      @exception = @ticket.exception

      return @ticket.done
    end

    def get
      return @ticket.result if done?
      raise @exception
    end
  end

  class SlyncyCallBatch < Array
    attr_reader :exceptions
    def initialize
      @blocks = []
      @exceptions = []
      @has_exception = false
      @done = nil
    end

    def done?
      if @done.nil?
        @done = true
        @exceptions = []
        @has_exception = false
        each_index do |i|
          el = self[i]
          @done &&= el.done?
          @has_exception ||= !el.exception.nil?
          @exceptions[i] = el.exception
        end
      end
      return @done
    end

    def exception?
      @has_exception
    end
  end

  class TimeoutException < Exception; end;
end
