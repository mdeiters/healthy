module Healthy
  class EnvCheck
    def name
      'Environment'
    end
  
    def info
      ENV.keys.sort.map { |key| "#{key}=#{ENV[key]}" }.join("\n")
    end
  end
end