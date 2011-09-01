require 'singleton'
module Healthy
  class ServerIdentity
    class << self
      attr_accessor :identity
      def establish(string_or_method_name = nil, &block)
        self.identity = if block
          yield
        elsif string_or_method_name.is_a? Symbol
          self.send(string_or_method_name)
        else
          string_or_method_name
        end
        if identity.nil? || identity.empty?
          raise ArgumentError, "server identity cannot be nil or empty"
        end
      end
      
      def matches?(test)
        test.nil? || test.empty? || test == identity || test.is_a?(Array) && test.include?(identity)
      end
      
      def fqdn
        fqdn = `hostname --fqdn`.strip
        fqdn = `hostname`.strip if fqdn == ''
        fqdn
      end
      
      # TODO
      def ip_and_port
      end
      
    end
  end
end