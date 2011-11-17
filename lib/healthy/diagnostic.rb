module Healthy
  class Diagnostic  
    class << self
      def info_for(normalized_name)
        route = Router.routes[normalized_name]
        if ServerIdentity.matches?(route[:servers])
          route[:klass].new.info
        else
          `curl -H 'Host: #{Diagnostic.site_host}' http://#{route[:servers].first}/status/#{normalized_name}`
        end
      end
    
      def status
        status = :pass
        checks.each do |check| 
          case check.status
          when :warn
            status = :warn
          when :fail
            return :fail
          end
        end
          
        status
      end
    
      def all_good?
        status == :pass
      end
              
      def site_host
        @@site_host
      end
      
      def site_host=(value)
        @@site_host=value
      end
    
      def monitor(diagnostic)
        @diagnostics ||= []
        exsisting = @diagnostics.detect{|exsisting| exsisting.name == diagnostic.name }
        @diagnostics.delete(exsisting) if exsisting
        @diagnostics << diagnostic
        Router.add_route(diagnostic)
      end
    
      def diagnostics
        @diagnostics.uniq.collect(&:new)
      end
    
      def flush_diagnostics!
        @diagnostics.uniq.clear
        Router.routes = nil
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