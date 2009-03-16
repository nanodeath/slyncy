
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe Slyncy do
  include Slyncy
  before(:each) do
    @user = mock("User")
    @user.should_receive(:get_pictures).any_number_of_times.with(an_instance_of(Fixnum)).and_return {|a| sleep a/100; ['picture'] * a}
    @user.should_receive(:get_picture).any_number_of_times.with(an_instance_of(Fixnum)).and_return do |a|
      if a < 10
        'picture'
      else
        raise "No such picture."
      end
    end
  end

  # shared examples in the spec helper
  describe Slyncy::JITJobProcessor do
    before(:all) do
      Slyncy.options[:job_processor] = Slyncy::JITJobProcessor
    end

    it_should_behave_like "a job processor"
  end

  describe Slyncy::NewthreadJobProcessor do
    before(:each) do
      Slyncy.options[:job_processor] = Slyncy::NewthreadJobProcessor
    end

    it_should_behave_like "a job processor"
  end
end

# EOF
