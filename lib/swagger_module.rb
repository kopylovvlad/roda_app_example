module SwaggerModule
  include Swagger::Blocks

  swagger_root do
    key :swagger, '2.0'
    info do
      key :version, '1.0.0'
      key :title, 'Swagger Roda App'
      key :description, 'Pet-app with Roda and Mongoid'
      license do
        key :name, 'MPL-2.0'
      end
    end
    key :basePath, '/'
    key :consumes, ['application/json']
    key :produces, ['application/json']
  end

  def self.json
    Swagger::Blocks.build_root_json([User, Message, Chat, Bookmark, self])
  end
end
