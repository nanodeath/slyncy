
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
