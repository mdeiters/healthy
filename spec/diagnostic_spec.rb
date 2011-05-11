require 'spec/spec_helper'

module Healthy
  describe Diagnostic do
    before :each do
      Diagnostic.flush_diagnostics!
    end
  
    it 'considers tools as anything in diagnostic array that does not have the passed? method but has info' do
      test_tool_class = Class.new do
        def info; end
      end
      Diagnostic.monitor(test_tool_class)
      Diagnostic.tools.first.should be_instance_of(test_tool_class)
    end
  
    it 'considers checks as anything in diagnostic array that has the passed? method' do
      test_check_class = Class.new do
        def passed?; end
        def info; end
      end
      Diagnostic.monitor(test_check_class)
      Diagnostic.checks.first.should be_instance_of(test_check_class)
    end
  
    
    it 'should only have one instance of diagnostic even if multiple exsist so development autoreloading works' do
      test_check_class = Class.new(Object)
      test_check_class.class_eval do
        include Diagnostic::Base
      end
      Diagnostic.monitor(test_check_class)
      Diagnostic.monitor(test_check_class)
      loaded_diagnostics = Diagnostic.instance_variable_get("@diagnostics")
      loaded_diagnostics.uniq.should == loaded_diagnostics
    end
  end
end