DIAGNOSTIC_LOGGER = defined?(Rails) ? Rails.logger : require('logger') && Logger.new($stdout)

require 'diagnostic'
require 'sinatra'
require 'server'
require 'base'
require 'distributed_base'
require('gem_list')          && Healthy::Diagnostic.monitor(Healthy::GemList)  
require('env_check')         && Healthy::Diagnostic.monitor(Healthy::EnvCheck)  
require('disk_space')        && Healthy::Diagnostic.monitor(Healthy::DiskSpace)
require('revision_deployed') && Healthy::Diagnostic.monitor(Healthy::RevisionDeployed)