# frozen_string_literal: true

##
# app for documentation
module SwaggerAppDoc
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
end
