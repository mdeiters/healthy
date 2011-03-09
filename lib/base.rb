module HealthStatus
  class Diagnostic
    # all checks are expected to implement methods passed?, warning?, info
    # all tools are expected to implement methods info
    class Base    
      def normalized_name
        Diagnostic.normalize_name(self.name)
      end

      def handles?(name)
        normalized_name == Diagnostic.normalize_name(name)
      end

      def status
        raise "status is not supported on a tool" unless respond_to?(:passed?)
        return :warn if warning? && passed?
        return :fail unless passed?
        return :pass
      end
    
      def htmlized_info
        info.gsub(' ', '&nbsp;').gsub("\n", '<br>')
      end
  
      def name
        self.class.name
      end    
  
    end
  end
end