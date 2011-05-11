require 'spec/spec_helper'

module Healthy

  describe Diagnostic::Base do
    before(:all) do
      class Check
        include Healthy::Diagnostic::Base
      end
    end
    it 'returns a status of :pass if a diagnostic indicates passed? and there are no warnings' do
      test_diagnotic = Class.new(Check) do
        def warning?; false; end
        def passed?; true;   end
      end      
      test_diagnotic.new.status.should == :pass
    end

    it 'returns a status of :warn if a diagnostic indicates passed? but there are warnings' do
      test_diagnotic = Class.new(Check) do
        def warning?; true; end
        def passed?; true;  end
      end      
      test_diagnotic.new.status.should == :warn
    end

    it 'returns a status of :fail when it did not pass' do 
      test_diagnotic = Class.new(Check) do
        def warning?; true; end
        def passed?; false; end
      end      
      test_diagnotic.new.status.should == :fail
    end
  end

end