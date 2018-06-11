# frozen_string_literal: true
# https://github.com/jeremyevans/roda/tree/master/lib/roda/plugins

module Plugins
  def self.included(base)
    base.class_eval do
      plugin :multi_route
      plugin :head
      plugin :json
      plugin :all_verbs
      plugin :environments
      plugin :middleware
      plugin :run_handler
      plugin :halt
      plugin :shared_vars
      plugin :error_handler do |e|
        puts 'error_handler:'
        puts e.inspect
        puts e.backtrace
        { success: false, message: 'internal server error' }
      end
      plugin :not_found do |e|
        unless ENV['RACK_ENV'] == 'test'
          puts 'not_found:'
          puts e.inspect
        end
        {}
      end
    end
  end
end
