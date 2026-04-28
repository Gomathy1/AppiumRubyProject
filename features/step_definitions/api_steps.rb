require 'rest-client'
require 'json'

Before('@api') do
  @api_base_url = ENV['API_BASE_URL'] || 'https://jsonplaceholder.typicode.com'
  @response = nil
  @response_time = nil
end

When('I send a GET request to {string}') do |endpoint|
  start_time = Time.now
  begin
    @response = RestClient.get("#{@api_base_url}#{endpoint}")
    @response_time = ((Time.now - start_time) * 1000).round
  rescue RestClient::ExceptionWithResponse => e
    @response = e.response
    @response_time = ((Time.now - start_time) * 1000).round
  end
end

When('I send a POST request to {string} with body:') do |endpoint, body|
  start_time = Time.now
  begin
    @response = RestClient.post(
      "#{@api_base_url}#{endpoint}",
      body,
      { content_type: :json, accept: :json }
    )
    @response_time = ((Time.now - start_time) * 1000).round
  rescue RestClient::ExceptionWithResponse => e
    @response = e.response
    @response_time = ((Time.now - start_time) * 1000).round
  end
end

When('I send a PUT request to {string} with body:') do |endpoint, body|
  start_time = Time.now
  begin
    @response = RestClient.put(
      "#{@api_base_url}#{endpoint}",
      body,
      { content_type: :json, accept: :json }
    )
    @response_time = ((Time.now - start_time) * 1000).round
  rescue RestClient::ExceptionWithResponse => e
    @response = e.response
    @response_time = ((Time.now - start_time) * 1000).round
  end
end

When('I send a DELETE request to {string}') do |endpoint|
  start_time = Time.now
  begin
    @response = RestClient.delete("#{@api_base_url}#{endpoint}")
    @response_time = ((Time.now - start_time) * 1000).round
  rescue RestClient::ExceptionWithResponse => e
    @response = e.response
    @response_time = ((Time.now - start_time) * 1000).round
  end
end

Then('the response status should be {int}') do |status_code|
  expect(@response.code).to eq(status_code)
end

Then('the response should contain a list of posts') do
  data = JSON.parse(@response.body)
  expect(data).to be_an(Array)
  expect(data.length).to be > 0
  expect(data.first).to have_key('id')
  expect(data.first).to have_key('title')
end

Then('the response should contain:') do |table|
  data = JSON.parse(@response.body)
  table.rows_hash.each do |field, value|
    actual_value = data[field].to_s
    expect(actual_value).to eq(value)
  end
end

Then('the response should have field {string}') do |field|
  data = JSON.parse(@response.body)
  expect(data).to have_key(field)
  expect(data[field]).not_to be_nil
end

Then('the response should match the post schema') do
  data = JSON.parse(@response.body)
  expect(data).to have_key('userId')
  expect(data).to have_key('id')
  expect(data).to have_key('title')
  expect(data).to have_key('body')
  expect(data['userId']).to be_a(Integer)
  expect(data['id']).to be_a(Integer)
  expect(data['title']).to be_a(String)
  expect(data['body']).to be_a(String)
end

Then('the response time should be less than {int} ms') do |max_time|
  expect(@response_time).to be < max_time
  puts "Response time: #{@response_time}ms"
end
