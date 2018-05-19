class CustomRequest
  attr_reader :code, :content_type, :body

  def initialize(l_resp)
    @code = l_resp.status.to_s || nil
    @content_type = l_resp.original_headers["Content-Type"]
    @body = l_resp.body
  end
end

module RequestHelper
  def response
    ::CustomRequest.new(last_response)
  end

  def json
    JSON.parse(response.body)
  end
end
