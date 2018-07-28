# frozen_string_literal: true

##
# app for documentation
module SwaggerApp
  include Swagger::Blocks
  swagger_path '/swagger_json' do
    operation :get do
      key :tags, ['swagger']
      response 200 do
        key :description, 'Return swagger json'
      end
    end
  end
  swagger_path '/swagger_ui' do
    operation :get do
      key :tags, ['swagger']
      response 200 do
        key :description, 'Return swagger ui html-page'
      end
    end
  end

  def self.included(base)
    base.class_eval do
      route 'swagger_json' do |r|
        r.is do
          # route: GET /swagger_json
          r.get do
            SwaggerModule.json
          end
        end
      end
      route 'swagger_ui' do |r|
        r.is do
          # route: GET /swagger_ui
          r.get do
            path_to_swagger_json = './swagger_json'
            ::SwaggeruiLocal.render_html(path_to_swagger_json)
          end
        end
      end
    end
  end
end
