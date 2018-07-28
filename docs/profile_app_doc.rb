# frozen_string_literal: true

module ProfileAppDoc
  include Swagger::Blocks
  swagger_path '/profiles' do
    operation :get do
      key :description, 'Returns all profiles'
      key :tags, ['profiles']
      [
        'first_name', 'last_name', 'email', 'city', 'height_after',
        'height_before', 'weight_after', 'weight_before', 'gender',
        'birthdate_before', 'birthdate_after'
      ].each do |param_name|
        parameter do
          key :name, param_name.to_sym
          key :in, :query
          key :required, false
        end
      end
    end
  end
  swagger_path '/profiles/{id}' do
    key :description, 'See profile data'
    operation :get do
      key :tags, ['profiles']
      parameter do
        key :name, :id
        key :in, :path
        key :required, true
        key :type, :integer
        key :format, :int64
      end
    end
    operation :patch do
      key :description, 'Update your own profile data'
      key :tags, ['profiles']
      parameter do
        key :name, :id
        key :in, :path
        key :description, 'ID of pet to fetch'
        key :required, true
        key :type, :integer
        key :format, :int64
      end
      %i[email first_name last_name].each do |sym|
        parameter do
          key :name, sym
          key :in, :body
          key :required, true
        end
      end
      %i[
        height weight city birthdate password password_confirmation
      ].each do |sym|
        parameter do
          key :name, sym
          key :in, :body
          key :required, false
        end
      end
      parameter do
        key :name, :gender
        key :in, :body
        key :description, "Shoul be 'male' or 'female'"
        key :required, false
      end
    end
  end
end
