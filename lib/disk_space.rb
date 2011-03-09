module Healthy
  class DiskSpace < Diagnostic::DistributedBase
    def name
      'Disk Space'
    end
  
    def info
      `df`
    end
  end
end