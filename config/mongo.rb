require 'mongoid'
Mongoid.logger.level = Logger::DEBUG
Mongo::Logger.logger.level = Logger::DEBUG
Mongoid.raise_not_found_error = false
Mongoid.load!('./mongoid.yml', ENV['RACK_ENV'] || 'development')
