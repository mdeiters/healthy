require 'spec/spec_helper'

class WarholCheck
end

class DuchampCheck
  def name
    "Moustache Check"
  end
end

module Healthy
  describe Router do
    before(:all) do
      Diagnostic.flush_diagnostics!
    end
    
    describe ".add" do
      it "should convert they given key/value pair" do
        Router.add({
          WarholCheck => ["localhost:3000"],
          DuchampCheck => ["localhost:3001"]
        })
        
        Router.routes.should == {
          "warholcheck" => {
            :servers => ["localhost:3000"],
            :klass   => WarholCheck
          },
          "moustachecheck" => {
            :servers => ["localhost:3001"],
            :klass   => DuchampCheck
          }
        }
      end
    end
  end
end
