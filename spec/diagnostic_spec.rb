require 'spec/spec_helper'

module HealthStatus  
  describe Diagnostic do
    before :each do
      Diagnostic.flush_diagnostics!
    end
  
    describe Diagnostic::Base do
      it 'returns a status of :pass if a diagnostic indicates passed? and there are no warnings' do
        test_diagnotic = Class.new(Diagnostic::Base) do
          def warning?; false; end
          def passed?; true;   end
        end      
        test_diagnotic.new.status.should == :pass
      end
    
      it 'returns a status of :warn if a diagnostic indicates passed? but there are warnings' do
        test_diagnotic = Class.new(Diagnostic::Base) do
          def warning?; true; end
          def passed?; true;  end
        end      
        test_diagnotic.new.status.should == :warn
      end
    
      it 'returns a status of :fail when it did not pass' do 
        test_diagnotic = Class.new(Diagnostic::Base) do
          def warning?; true; end
          def passed?; false; end
        end      
        test_diagnotic.new.status.should == :fail
      end
    end
  
    describe Diagnostic::FarmFriendly do
    
      before :each do
        Diagnostic.stubs(:current_server).returns('amdc-lamp-lx10.amdc.mckinsey.com')
        Diagnostic.stubs(:servers).returns(['amdc-lamp-lx10.amdc.mckinsey.com', 'amdc-lamp-lx12.amdc.mckinsey.com'])
      end
    
      it "should get the server_info for all the servesr when the name does not contain 'standalone'" do
        test_instance = Class.new(Diagnostic::FarmFriendly) do
          def name
            'Test Farm Diagnostic'
          end
        
          def server_info
            'current server test'
          end
        end.new
        test_instance.handles?('Test Farm Diagnostic')
        test_instance.expects(:remote_server_info).with('amdc-lamp-lx12.amdc.mckinsey.com').returns("amdc-lamp-lx12.amdc.mckinsey.com\nother server test")
        response = test_instance.info
        response.should include("amdc-lamp-lx10.amdc.mckinsey.com\ncurrent server test")
        response.should include("amdc-lamp-lx12.amdc.mckinsey.com\nother server test")
      end
      
      it "should perform server_info only on the current server if name contains 'standalone' because another check originated the request" do
        test_instance = Class.new(Diagnostic::FarmFriendly) do
          def name
            'Test Farm Diagnostic'
          end
        
          def server_info
            'testing'
          end
        end.new
        test_instance.handles?('Test Farm Diagnostic+standalone')
        test_instance.info.should == "amdc-lamp-lx10.amdc.mckinsey.com\ntesting"
      end
      
      it 'should not conflict when to different classes configure run_on' do
        test_one = Class.new(Diagnostic::FarmFriendly) 
        test_one.run_on = 'one'
        test_two = Class.new(Diagnostic::FarmFriendly) 
        test_two.run_on = 'two'
        test_two.run_on.should_not == test_one.run_on
      end
    
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