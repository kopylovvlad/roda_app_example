RSpec.shared_examples 'not_guest' do |path, parameters, method = 'get'|
  describe 'guest' do
    it 'return 401' do
      # action
      get(path, parameters)

      # check
      expect(response.code).to eq('401')
      expect(response.content_type).to eq('application/json')
      expect(json['error']).to eq('Unauthorized')
    end
  end
end
