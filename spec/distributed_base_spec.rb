require 'spec/spec_helper'

module Healthy

  describe Diagnostic::DistributedBase do

    before :each do
      Diagnostic.stubs(:current_server).returns('amdc-lamp-lx10.amdc.mckinsey.com')
      Diagnostic.stubs(:servers).returns(['amdc-lamp-lx10.amdc.mckinsey.com', 'amdc-lamp-lx12.amdc.mckinsey.com'])
    end

    it "should get the server_info for all the servesr when the name does not contain 'standalone'" do
      test_instance = Class.new(Diagnostic::DistributedBase) do
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
  
    it "should perform server_info only on the current server if name contains 'remote' because another check originated the request" do
      test_instance = Class.new(Diagnostic::DistributedBase) do
        def name
          'Test Farm Diagnostic'
        end
    
        def server_info
          'testing'
        end
      end.new
      test_instance.handles?('Test Farm Diagnostic+remote')
      test_instance.info.should == "amdc-lamp-lx10.amdc.mckinsey.com\ntesting"
    end
  
    it 'should not conflict when to different classes configure run_on' do
      test_one = Class.new(Diagnostic::DistributedBase) 
      test_one.run_on = 'one'
      test_two = Class.new(Diagnostic::DistributedBase) 
      test_two.run_on = 'two'
      test_two.run_on.should_not == test_one.run_on
    end

  end

end