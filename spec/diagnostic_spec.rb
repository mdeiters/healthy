require 'spec/spec_helper'

module HealthStatus  
  describe Diagnostic do
    before :each do
      Diagnostic.flush_diagnostics!
    end
  
    it 'should indicate current server' do
      Diagnostic.current_server.should_not == ''
    end
  
    it 'supports configuring servers' do
      Diagnostic.servers << 'amdc-lamp-lx12.amdc.mckinsey.com'
      Diagnostic.servers.should include('amdc-lamp-lx12.amdc.mckinsey.com')
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
  
    it 'finds diagnostics by name if no handle method is implemented and the class inherits Diagnostic base' do
      test_check_class = Class.new(Diagnostic::Base) do
        def name; 'test123'; end
      end
      Diagnostic.monitor(test_check_class)
      Diagnostic.find('test123').should be_instance_of(test_check_class)
    end

  end
end