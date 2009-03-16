
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
      Slyncy.job_processor = Slyncy::JITJobProcessor.new
    end

    it_should_behave_like "a job processor"

    it "should report correct job processor" do
      Slyncy.job_processor.should be_a(Slyncy::JITJobProcessor)
    end
  end

  describe Slyncy::NewthreadJobProcessor do
    before(:all) do
      Slyncy.job_processor = Slyncy::NewthreadJobProcessor.new
    end

    it_should_behave_like "a job processor"

    it "should report correct job processor" do
      Slyncy.job_processor.should be_a(Slyncy::NewthreadJobProcessor)
    end
  end
end

# EOF
