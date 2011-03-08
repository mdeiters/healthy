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
  
    class FarmFriendly < Base
      attr_reader :originator_of_request

      def self.run_on
        @run_on
      end
      
      def self.run_on=(value)
        @run_on=value
      end

      def handles?(name)
        name_match = Diagnostic.normalize_name(name).include?(normalized_name)
        @originator_of_request = true if name_match && !name.include?('+standalone')
        return name_match
      end

      def ask_other_servers?
        originator_of_request == true
      end
    
      def run_on?(server)
        return true if run_on.nil? 
        run_on.include?(server)
      end
    
      def info
        response = ''
        DIAGNOSTIC_LOGGER.debug Diagnostic.servers.inspect
        Diagnostic.servers.each do |server|
          DIAGNOSTIC_LOGGER.debug "Running diagnostic: #{server}"
          if server.strip == Diagnostic.current_server.strip
            data = server_info
            response << "#{Diagnostic.current_server}\n"
            response << data
            DIAGNOSTIC_LOGGER.debug "Diagnostic #{name}: #{data}"
          elsif ask_other_servers?
            response << remote_server_info(server)
            response << "\n\n"
          end
        end
        response
      end
    
      def remote_server_info(server)
        `curl -H 'Host: #{Diagnostic.site_host}' http://#{server}/status?info=#{normalized_name}+standalone`
      end
    
      def server_info
        status
      end
    end
  
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
        (@diagnostics ||= []) << diagnostic
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