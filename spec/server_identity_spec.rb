require 'spec/spec_helper'

module Healthy

  describe ServerIdentity do
    before { ServerIdentity.identity = nil }
    describe ".establish" do
      it "should set the identity when given a string" do
        ServerIdentity.establish("test")
        ServerIdentity.identity.should == "test"
      end
      
      it "should set the identity when given a block" do
        ServerIdentity.establish { "block" }
        ServerIdentity.identity.should == "block"
      end
      
      it "should set the identity when given a symbol of a method name" do
        class Healthy::ServerIdentity
          def self.test_method
            "test_method"
          end
        end
        
        ServerIdentity.establish(:test_method)
        ServerIdentity.identity.should == "test_method"
      end
    end
    
    describe ".matches?" do
      it "should match if the argument given is nil or empty" do
        ServerIdentity.matches?(nil).should == true
        ServerIdentity.matches?([]).should == true
      end
      
      it "should match if the argument is the same as the identity" do
        ServerIdentity.establish("match")
        ServerIdentity.matches?("match").should == true
      end
      
      it "should match if the argument is an array containing the identity" do
        ServerIdentity.establish("match")
        ServerIdentity.matches?(["does not match", "match"]).should == true
      end
      
      it "should not match if none of the above are true" do
        ServerIdentity.establish("match")
        ServerIdentity.matches?("does not match").should == false
        ServerIdentity.matches?(["does not match"]).should == false
      end
    end
  end
end