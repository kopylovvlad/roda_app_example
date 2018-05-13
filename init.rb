require 'cuba'
require 'cuba/safe'
require 'dotenv'
require 'mongoid'

puts 'initialize'

Dotenv.load
Cuba.use(Rack::Session::Cookie, :secret => ENV['SECRET'])
Cuba.plugin(Cuba::Safe)

Mongoid.logger.level = Logger::DEBUG
Mongo::Logger.logger.level = Logger::DEBUG
Mongoid.load!('./mongoid.yml', :development)

Dir['./models/*.rb'].each { |file| require file }


