require 'bcrypt'
require 'roda'
require 'date'
require 'kaminari/core'
require 'kaminari/mongoid'
require 'swagger/blocks'
require 'swaggerui_local'

Dir['./config/*.rb'].each { |file| require file }
Dir['./lib/*.rb'].each { |file| require file }
Dir['./docs/*.rb'].each { |file| require file }
Dir['./handlers/*.rb'].each { |file| require file }
Dir['./modules/*.rb'].each { |file| require file }
Dir['./modules/**/*.rb'].each { |file| require file }
Dir['./models/*.rb'].each { |file| require file }
Dir['./services/**/*.rb'].each { |file| require file }


