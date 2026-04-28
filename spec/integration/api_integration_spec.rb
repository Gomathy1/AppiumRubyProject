require 'spec_helper'
require_relative '../../lib/utils/api_helper'

RSpec.describe 'API Integration Tests', :integration do
  let(:api_helper) { ApiHelper.new('https://jsonplaceholder.typicode.com') }

  describe 'GET requests' do
    it 'retrieves all posts' do
      response = api_helper.get('/posts')
      
      expect(api_helper.response_code).to eq(200)
      expect(api_helper.response_body).to be_an(Array)
      expect(api_helper.response_body.length).to be > 0
    end

    it 'retrieves a specific post' do
      response = api_helper.get('/posts/1')
      
      expect(api_helper.response_code).to eq(200)
      body = api_helper.response_body
      expect(body['id']).to eq(1)
      expect(body).to have_key('title')
      expect(body).to have_key('body')
    end

    it 'handles non-existent resources' do
      response = api_helper.get('/posts/99999')
      
      expect(api_helper.response_code).to eq(404)
    end
  end

  describe 'POST requests' do
    it 'creates a new post' do
      new_post = {
        title: 'Test Post',
        body: 'This is a test',
        userId: 1
      }
      
      response = api_helper.post('/posts', new_post)
      
      expect(api_helper.response_code).to eq(201)
      body = api_helper.response_body
      expect(body['title']).to eq('Test Post')
      expect(body['body']).to eq('This is a test')
    end
  end

  describe 'PUT requests' do
    it 'updates an existing post' do
      updated_post = {
        id: 1,
        title: 'Updated Title',
        body: 'Updated content',
        userId: 1
      }
      
      response = api_helper.put('/posts/1', updated_post)
      
      expect(api_helper.response_code).to eq(200)
      body = api_helper.response_body
      expect(body['title']).to eq('Updated Title')
    end
  end

  describe 'DELETE requests' do
    it 'deletes a post' do
      response = api_helper.delete('/posts/1')
      
      expect(api_helper.response_code).to eq(200)
    end
  end

  describe 'Response time validation' do
    it 'responds within acceptable time' do
      api_helper.get('/posts')
      
      expect(api_helper.last_response_time).to be < 3000
    end
  end

  describe 'Schema validation' do
    it 'validates post schema' do
      api_helper.get('/posts/1')
      body = api_helper.response_body
      
      expect(body).to have_key('userId')
      expect(body).to have_key('id')
      expect(body).to have_key('title')
      expect(body).to have_key('body')
      
      expect(body['userId']).to be_a(Integer)
      expect(body['id']).to be_a(Integer)
      expect(body['title']).to be_a(String)
      expect(body['body']).to be_a(String)
    end
  end
end
