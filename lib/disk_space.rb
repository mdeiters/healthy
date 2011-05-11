module Healthy
  class DiskSpace
    def name
      'Disk Space'
    end
  
    def info
      `df`
    end
  end
end