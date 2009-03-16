
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

    it "shouldn't be mandatory to check done?" do
      call = slyncy { @user.get_pictures(10) }
      
      pictures = call.get
      pictures.length.should == 10
    end

    it "should allow timeouts" do
      call = slyncy { @user.get_pictures(100) }

      lambda { pictures = call.get(0.1) }.should raise_error(Slyncy::TimeoutException)
    end

    it "shouldn't hit high timeouts" do
      call = slyncy { @user.get_pictures(10)}

      lambda { pictures = call.get(1) }.should_not raise_error(Slyncy::TimeoutException)
    end

    it "should propagate exceptions" do
      call = slyncy { @user.get_picture(20) }

      lambda { call.get }.should raise_error(RuntimeError)
    end
  end

  describe Array do
    it "should allow batch calls" do
      picture_batch = []
      picture_batch << slyncy { @user.get_pictures(10) }
      picture_batch << slyncy { @user.get_pictures(20) }

      picture_batch.first.get.length.should == 10
      picture_batch.last.get.length.should == 20
    end

    it "should propagate exceptions in batch calls" do
      picture_batch = []
      picture_batch << slyncy { @user.get_picture(5) }
      picture_batch << slyncy { @user.get_picture(20) }

      picture_batch.first.get.should == 'picture'
      lambda { picture_batch.last.get }.should raise_error(RuntimeError)
    end

    it "should allow timeouts in batch calls" do
      picture_batch = []
      picture_batch << slyncy { @user.get_pictures(10) }
      picture_batch << slyncy { @user.get_pictures(100) }

      picture_batch.first.get(0.1).length.should == 10
      lambda { picture_batch.last.get(0.1) }.should raise_error(Slyncy::TimeoutException)
    end
  end
end

# EOF
