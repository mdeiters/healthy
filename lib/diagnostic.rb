module Healthy
  class Diagnostic  
    class << self    
      def normalize_name(name)
        name.gsub(' ', '').downcase
      end
    
      def status
        statuses = checks.collect(&:status).uniq
        return :fail if statuses.include?(:fail)
        return :warn if statuses.include?(:warn)
        return :pass
      end
    
      def all_good?
        status == :pass
      end
    
      def find(name)
        diagnostics.select do |check| 
          if check.respond_to?(:handles?)
            check.handles?(name) 
          else
            Diagnostic.normalize_name(check.class.name) == Diagnostic.normalize_name(name)
          end
        end.first
      end
    
      def servers
        (@@servers ||= [])
      end
    
      def servers=(arg)
        @@servers = arg
      end
      
      def site_host
        @@site_host
      end
      
      def site_host=(value)
        @@site_host=value
      end
    
      def current_server
        fqdn = `hostname --fqdn`.strip
        fqdn = `hostname`.strip if fqdn == ''
        fqdn
      end
    
      def monitor(diagnostic)
        @diagnostics ||= []
        exsisting = @diagnostics.detect{|exsisting| exsisting.name == diagnostic.name }
        @diagnostics.delete(exsisting) if exsisting
        @diagnostics << diagnostic
      end
    
      def diagnostics
        @diagnostics.uniq.collect(&:new)
      end
    
      def flush_diagnostics!
        @diagnostics.uniq.clear
      end
    
      def checks
        diagnostics.select{|diagnostic| diagnostic.respond_to?(:passed?) }.sort{|x,y| extract_name(x) <=> extract_name(y)}
      end    
    
      def tools
        diagnostics.select{|diagnostic| !diagnostic.respond_to?(:passed?) }.sort{|x,y| extract_name(x) <=> extract_name(y)}
      end
      
      def extract_name(obj)
        if obj.respond_to?(:name)
          obj.name
        else
          obj.class.name
        end
      end
    end    
  end
end