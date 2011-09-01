module Healthy
  class Diagnostic  
    # all checks are expected to implement methods passed?, warning?, info
    # all tools are expected to implement methods info
    module Base    
      def status
        raise "status is not supported on a tool" unless respond_to?(:passed?)
        return :warn if warning? && passed?
        return :fail unless passed?
        return :pass
      end

      def name
        self.class.name
      end      
    end    
  end
end