DIAGNOSTIC_LOGGER = defined?(Rails) ? Rails.logger : require('logger') && Logger.new($stdout)

require 'healthy/diagnostic'
require 'healthy/base'
require 'sinatra'
require 'healthy/server'
require 'healthy/server_identity'
require 'healthy/router'
require('healthy/gem_list')          && Healthy::Diagnostic.monitor(Healthy::GemList)  
require('healthy/env_check')         && Healthy::Diagnostic.monitor(Healthy::EnvCheck)  
require('healthy/disk_space')        && Healthy::Diagnostic.monitor(Healthy::DiskSpace)
require('healthy/revision_deployed') && Healthy::Diagnostic.monitor(Healthy::RevisionDeployed)