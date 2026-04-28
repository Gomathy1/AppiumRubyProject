require 'rest-client'
require 'json'

class ApiHelper
  attr_reader :base_url, :last_response, :last_response_time

  def initialize(base_url = nil)
    @base_url = base_url || ENV['API_BASE_URL'] || 'https://jsonplaceholder.typicode.com'
    @last_response = nil
    @last_response_time = nil
  end

  def get(endpoint, headers = {})
    execute_request(:get, endpoint, nil, headers)
  end

  def post(endpoint, body, headers = {})
    execute_request(:post, endpoint, body, headers)
  end

  def put(endpoint, body, headers = {})
    execute_request(:put, endpoint, body, headers)
  end

  def patch(endpoint, body, headers = {})
    execute_request(:patch, endpoint, body, headers)
  end

  def delete(endpoint, headers = {})
    execute_request(:delete, endpoint, nil, headers)
  end

  def response_body
    JSON.parse(@last_response.body) if @last_response
  end

  def response_code
    @last_response&.code
  end

  def response_headers
    @last_response&.headers
  end

  private

  def execute_request(method, endpoint, body = nil, headers = {})
    url = "#{@base_url}#{endpoint}"
    default_headers = { content_type: :json, accept: :json }
    merged_headers = default_headers.merge(headers)

    start_time = Time.now
    begin
      @last_response = case method
                       when :get
                         RestClient.get(url, merged_headers)
                       when :post
                         RestClient.post(url, body.to_json, merged_headers)
                       when :put
                         RestClient.put(url, body.to_json, merged_headers)
                       when :patch
                         RestClient.patch(url, body.to_json, merged_headers)
                       when :delete
                         RestClient.delete(url, merged_headers)
                       end
      @last_response_time = ((Time.now - start_time) * 1000).round
      @last_response
    rescue RestClient::ExceptionWithResponse => e
      @last_response = e.response
      @last_response_time = ((Time.now - start_time) * 1000).round
      @last_response
    end
  end
end
