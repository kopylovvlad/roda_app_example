class CustomRequest
  attr_reader :code, :content_type, :body

  def initialize(l_resp)
    @code = l_resp.status.to_s || nil
    @content_type = l_resp.original_headers["Content-Type"]
    @body = l_resp.body
  end
end

module RequestHelper
  include Warden::Test::Helpers

  def response
    ::CustomRequest.new(last_response)
  end

  def json
    JSON.parse(response.body)
  end

  # TODO: replace all the things
  def check_response
    expect(response.code).to eq('200')
    expect(response.content_type).to eq('application/json')
  end

  def sign_in(resource)
    login_as(resource)
  end

  def sign_out(resource)
    logout(resource)
  end
end
