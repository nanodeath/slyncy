
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
    it "should allow slow calls" do
      call = slyncy { @user.get_pictures(10) }
      3.times do
        @user.get_pictures(10)
      end

      call.done?.should be_true
      pictures = call.get
      pictures.length.should == 10
    end

    it "shouldn't be mandatory to check done?" do
      call = slyncy { @user.get_pictures(10) }
      pictures = call.get
      pictures.length.should == 10
    end

    it "should allow timeouts for slow calls" do
      call = slyncy { @user.get_pictures(1000)}
      call.done?(0.2).should be_false

      call.timed_out?.should be_true
    end

    it "shouldn't hit high timeouts for slow calls" do
      call = slyncy { @user.get_pictures(10)}
      call.done?(1).should be_true

      call.timed_out?.should be_false
      call.exception.should be_nil
    end

    it "should trap exceptions gracefully" do
      call = slyncy { @user.get_picture(20) }
      call.done?.should be_false
      call.exception.class.should == RuntimeError
      call.exception.message.should == "No such picture."
    end

  end

  describe Slyncy::SlyncyCallBatch do
    it "should allow slow batch calls" do
      picture_batch = slyncy_batch
      picture_batch << slyncy { @user.get_pictures(10) }
      picture_batch << slyncy { @user.get_pictures(20) }

      picture_batch.done?.should be_true
      picture_batch.first.get.length.should == 10
      picture_batch.last.get.length.should == 20
    end

    it "should let me start processing elements of batch calls immediately" do
      picture_batch = slyncy_batch
      picture_batch << slyncy { @user.get_pictures(10) }
      picture_batch << slyncy { @user.get_pictures(20) }

      # not checking done here
      picture_batch.first.get.length.should == 10
      picture_batch.last.get.length.should == 20
    end
  end

  it "should trap exceptions in array calls gracefully" do
    picture_batch = slyncy_batch
    picture_batch << slyncy { @user.get_picture(5) }
    picture_batch << slyncy { @user.get_picture(20) }
    
    picture_batch.done?.should be_false
    picture_batch.first.get.should == 'picture'
    lambda { picture_batch.last.get }.should raise_error(RuntimeError)

    picture_batch.exception?.should be_true
    picture_batch.exceptions.first.should be_nil
    picture_batch.exceptions.last.class.should == RuntimeError
  end
end

# EOF
