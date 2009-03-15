module Slyncy
  def slyncy(&block)
    SlyncyCall.new(&block)
  end

  def slyncy_array
    SlyncyCallArray.new
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

    def exception?
      not @exception.nil?
    end

    def done?(timeout=-1)
      @ret = @ticket.redeem(timeout)
      @exception = @ticket.exception

      return @ticket.done
    end

    def get
      return @ticket.result if done?
    end
  end

  class SlyncyCallArray
    attr_reader :exceptions
    def initialize
      @blocks = []
      @exceptions = []
      @has_exception = false
      @done = nil
    end
    def <<(slyncy_call)
      @blocks << slyncy_call
    end

    def done?
      if @done.nil?
        @done = true
        @blocks.each do |b|
          @done &&= b.done?
          if b.exception?
            @has_exception = true
            @exceptions << b.exception
          else
            @exceptions << nil
          end
        end
      end
      return @done
    end

    def exception?
      done?
      @has_exception
    end

    def get
      done?
      return @blocks.map{|b| b.get}
    end
  end

  class TimeoutException < Exception; end;
end
