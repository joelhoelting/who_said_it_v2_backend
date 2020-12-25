module GeneralHelpers
  def response_body_to_json
    JSON.parse(response.body)
  end

  def expect_json_header
    expect(response.header['Content-Type']).to include('application/json')
  end

  def expect_status(code)
    expect(response.status).to eq code
  end
end
