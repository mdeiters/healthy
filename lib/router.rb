require 'singleton'
module Healthy
  class Router
    class << self
      attr_accessor :routes
      
      # @param Hash r key should be class, value should be array of servers to run on
      def add(r)
        r.each { |klass, servers| add_route(klass, servers) }
      end
      
      def add_route(*route)
        @routes ||= Hash.new{|h, k| h[k] = {}}
        klass = route.first
        # this can be nil
        servers = route[1]
        @routes[normalized_name(klass)][:klass] = klass
        @routes[normalized_name(klass)][:servers] = servers
      end
      
      def normalized_name(klass)
        instance = klass.new
        name = instance.respond_to?(:name) ? instance.name : klass.name
        name.downcase.gsub(" ", "")
      end
    end
  end
end