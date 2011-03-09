module Healthy
  class EnvCheck < Diagnostic::DistributedBase
    def name
      'Environment'
    end
  
    def info
      ENV.keys.sort.map { |key| "#{key}=#{ENV[key]}" }.join("\n")
    end
  end
end