DIAGNOSTIC_LOGGER = defined?(Rails) ? Rails.logger : require('logger') && Logger.new($stdout)

require 'diagnostic'
require 'sinatra'
require 'server'
require 'base'
require 'distributed_base'
require('gem_list')   && HealthStatus::Diagnostic.monitor(HealthStatus::GemList)  
require('env_check')  && HealthStatus::Diagnostic.monitor(HealthStatus::EnvCheck)  
require('disk_space') && HealthStatus::Diagnostic.monitor(HealthStatus::DiskSpace)
require('revision_deployed') && HealthStatus::Diagnostic.monitor(HealthStatus::RevisionDeployed)