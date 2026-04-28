require 'spec_helper'
require_relative '../../lib/utils/api_helper'

RSpec.describe ApiHelper do
  let(:base_url) { 'https://api.example.com' }
  let(:api_helper) { ApiHelper.new(base_url) }
  let(:mock_response) { double('response', body: '{"id": 1, "name": "Test"}', code: 200, headers: {}) }

  describe '#initialize' do
    it 'sets the base URL' do
      expect(api_helper.base_url).to eq(base_url)
    end

    it 'uses environment variable when no URL provided' do
      ENV['API_BASE_URL'] = 'https://env.example.com'
      helper = ApiHelper.new
      
      expect(helper.base_url).to eq('https://env.example.com')
    end

    it 'uses default URL when no URL or env variable provided' do
      ENV.delete('API_BASE_URL')
      helper = ApiHelper.new
      
      expect(helper.base_url).to eq('https://jsonplaceholder.typicode.com')
    end
  end

  describe '#get' do
    it 'makes a GET request' do
      expect(RestClient).to receive(:get)
        .with("#{base_url}/posts", { content_type: :json, accept: :json })
        .and_return(mock_response)
      
      response = api_helper.get('/posts')
      
      expect(response).to eq(mock_response)
      expect(api_helper.last_response).to eq(mock_response)
    end

    it 'records response time' do
      allow(RestClient).to receive(:get).and_return(mock_response)
      
      api_helper.get('/posts')
      
      expect(api_helper.last_response_time).to be_a(Integer)
      expect(api_helper.last_response_time).to be >= 0
    end
  end

  describe '#post' do
    it 'makes a POST request with body' do
      body = { title: 'Test Post', body: 'Content' }
      expect(RestClient).to receive(:post)
        .with("#{base_url}/posts", body.to_json, { content_type: :json, accept: :json })
        .and_return(mock_response)
      
      response = api_helper.post('/posts', body)
      
      expect(response).to eq(mock_response)
    end
  end

  describe '#put' do
    it 'makes a PUT request with body' do
      body = { id: 1, title: 'Updated' }
      expect(RestClient).to receive(:put)
        .with("#{base_url}/posts/1", body.to_json, { content_type: :json, accept: :json })
        .and_return(mock_response)
      
      response = api_helper.put('/posts/1', body)
      
      expect(response).to eq(mock_response)
    end
  end

  describe '#delete' do
    it 'makes a DELETE request' do
      expect(RestClient).to receive(:delete)
        .with("#{base_url}/posts/1", { content_type: :json, accept: :json })
        .and_return(mock_response)
      
      response = api_helper.delete('/posts/1')
      
      expect(response).to eq(mock_response)
    end
  end

  describe '#response_body' do
    it 'returns parsed JSON response' do
      allow(RestClient).to receive(:get).and_return(mock_response)
      api_helper.get('/posts')
      
      body = api_helper.response_body
      
      expect(body).to eq({ 'id' => 1, 'name' => 'Test' })
    end
  end

  describe '#response_code' do
    it 'returns response status code' do
      allow(RestClient).to receive(:get).and_return(mock_response)
      api_helper.get('/posts')
      
      expect(api_helper.response_code).to eq(200)
    end
  end

  describe 'error handling' do
    it 'handles HTTP errors gracefully' do
      error_response = double('error_response', body: '{"error": "Not Found"}', code: 404, headers: {})
      exception = RestClient::ExceptionWithResponse.new
      allow(exception).to receive(:response).and_return(error_response)
      
      expect(RestClient).to receive(:get).and_raise(exception)
      
      response = api_helper.get('/posts/99999')
      
      expect(api_helper.response_code).to eq(404)
    end
  end
end
