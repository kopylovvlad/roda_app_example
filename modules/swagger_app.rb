# frozen_string_literal: true

##
# app for documentation
module SwaggerApp
  def self.included(base)
    base.class_eval do
      route 'swagger_json' do |r|
        r.is do
          # route: GET /api
          r.get do
            SwaggerModule.json
          end
        end
      end
      route 'swagger_ui' do |r|
        r.is do
          r.get do
            path_to_swagger_json = './swagger_json'
            ::SwaggeruiLocal.render_html(path_to_swagger_json)
          end
        end
      end
    end
  end
end
