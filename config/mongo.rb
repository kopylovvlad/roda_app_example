require 'mongoid'
Mongoid.logger.level = Logger::DEBUG
Mongo::Logger.logger.level = Logger::DEBUG
Mongoid.load!('./mongoid.yml', ENV['RACK_ENV'] || 'development')
