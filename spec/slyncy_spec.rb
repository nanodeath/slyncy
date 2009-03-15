
require File.join(File.dirname(__FILE__), %w[spec_helper])

describe Slyncy do
    include Slyncy

    it "should allow slow calls" do
      x = slyncy do
        sleep 0.1
        3
      end
      sleep 0.01
      x.done?.should be_true
      x.get.should == 3

      x.exception?.should be_false
      x.exception.should be_nil
    end

    it "should allow slow array calls" do
      x = slyncy_array
      x << slyncy do
        sleep 0.1
        1
      end
      x << slyncy do
        sleep 0.2
        2
      end
      sleep 0.01
      x.done?.should be_true
      res = x.get
      res.first.should == 1
      res.last.should == 2

      x.exception?.should be_false
    end

    it "should allow timeouts for slow calls" do
      x = slyncy do
        sleep 3
        2
      end
      sleep 0.01
      x.done?(0.2).should be_false

      x.exception?.should be_true
      x.exception.class.should == Slyncy::TimeoutException
    end

    it "should trap exceptions gracefully" do
      x = slyncy do
        raise "exception"
      end
      x.done?.should be_false
      x.exception?.should be_true
      x.exception.class.should == RuntimeError
      x.exception.message.should == "exception"
    end

    it "should trap exceptions in array calls gracefully" do
      x = slyncy_array
      x << slyncy do
        3
      end
      x << slyncy do
        raise "exception"
      end
      x.done?.should be_false
      res = x.get
      res.first.should == 3
      res.last.should be_nil

      x.exception?.should be_true
      x.exceptions.first.should be_nil
      x.exceptions.last.class.should == RuntimeError
    end
end

# EOF
