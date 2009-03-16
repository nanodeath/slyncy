module Slyncy
  def slyncy(&block)
    SlyncyCall.new(&block)
  end

  class << self
    attr_writer :job_processor
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

    def get(timeout=-1)
      return @ticket.result if done?(timeout)
      raise @exception
    end

    private
    def done?(timeout=-1)
      @ret = @ticket.redeem(timeout)
      @exception = @ticket.exception

      return @ticket.done
    end
  end
  class TimeoutException < Exception; end;
end
