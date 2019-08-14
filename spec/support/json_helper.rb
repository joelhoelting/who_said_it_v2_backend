module JSONHelper
  def response_body_to_json
    JSON.parse(response.body)
  end
end

