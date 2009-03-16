
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe Slyncy do
  include Slyncy

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
