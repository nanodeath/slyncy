
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
