module Healthy
    class RevisionDeployed
    def name
      'Subversion Revision'
    end
  
    def info
      File.read("#{RAILS_ROOT}/REVISION")
    rescue
      'Unkown'
    end
  end
end