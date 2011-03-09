module HealthStatus
  class Diagnostic
    class DistributedBase < Base
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
  end
end