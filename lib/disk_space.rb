module HealthStatus
  class DiskSpace < Diagnostic::FarmFriendly
    def name
      'Disk Space'
    end
  
    def info
      `df`
    end
  end
end