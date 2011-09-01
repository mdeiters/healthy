DIAGNOSTIC_LOGGER = defined?(Rails) ? Rails.logger : require('logger') && Logger.new($stdout)

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'diagnostic'
require 'base'
require 'sinatra'
require 'server'
require 'server_identity'
require 'router'
require('gem_list')          && Healthy::Diagnostic.monitor(Healthy::GemList)  
require('env_check')         && Healthy::Diagnostic.monitor(Healthy::EnvCheck)  
require('disk_space')        && Healthy::Diagnostic.monitor(Healthy::DiskSpace)
require('revision_deployed') && Healthy::Diagnostic.monitor(Healthy::RevisionDeployed)