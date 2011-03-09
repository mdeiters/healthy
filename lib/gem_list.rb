module Healthy
  class GemList < Diagnostic::DistributedBase
    def name
      'Installed Ruby And Gems'
    end
  
    def info
      [ 
      "RUBY_VERSION=#{RUBY_VERSION}",
      "RUBY_PATCHLEVEL=#{RUBY_PATCHLEVEL}",
      "RUBY_PLATFORM=#{RUBY_PLATFORM}",
      "RUBY_RELEASE_DATE=#{RUBY_RELEASE_DATE}",
      `gem list`
      ].join("\n")
    end
  end
end