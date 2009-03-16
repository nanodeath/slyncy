
require File.expand_path(
  File.join(File.dirname(__FILE__), %w[.. lib slyncy]))
    
Spec::Runner.configure do |config|
  # == Mock Framework
  #
  # RSpec uses it's own mocking framework by default. If you prefer to
  # use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
end

shared_examples_for "a job processor" do
  describe Slyncy::SlyncyCall do
    it "should allow calls" do
      call = slyncy { @user.get_pictures(10) }

      pictures = call.get
      pictures.length.should == 10
    end

    it "should allow timeouts" do
      call = slyncy { @user.get_pictures(100) }

      lambda { pictures = call.get(0.1) }.should raise_error(Slyncy::TimeoutException)
    end

    it "shouldn't hit high timeouts" do
      call = slyncy { @user.get_pictures(10) }

      lambda { pictures = call.get(1) }.should_not raise_error(Slyncy::TimeoutException)
    end

    it "should propagate exceptions" do
      call = slyncy { @user.get_picture(20) }

      lambda { call.get }.should raise_error(RuntimeError)
    end
  end
end

# EOF
