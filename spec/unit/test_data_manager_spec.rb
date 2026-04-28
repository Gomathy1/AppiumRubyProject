require 'spec_helper'
require_relative '../../lib/utils/test_data_manager'

RSpec.describe TestDataManager do
  describe '.generate_user_data' do
    it 'generates valid user data' do
      data = TestDataManager.generate_user_data
      
      expect(data).to have_key(:username)
      expect(data).to have_key(:password)
      expect(data).to have_key(:email)
      expect(data).to have_key(:first_name)
      expect(data).to have_key(:last_name)
      expect(data).to have_key(:phone)
      
      expect(data[:username]).to be_a(String)
      expect(data[:email]).to include('@')
      expect(data[:password].length).to be >= 8
    end

    it 'generates unique data on each call' do
      data1 = TestDataManager.generate_user_data
      data2 = TestDataManager.generate_user_data
      
      expect(data1[:username]).not_to eq(data2[:username])
    end
  end

  describe '.generate_address_data' do
    it 'generates valid address data' do
      data = TestDataManager.generate_address_data
      
      expect(data).to have_key(:full_name)
      expect(data).to have_key(:address_line1)
      expect(data).to have_key(:city)
      expect(data).to have_key(:state)
      expect(data).to have_key(:zip_code)
      expect(data).to have_key(:country)
      
      expect(data[:full_name]).to be_a(String)
      expect(data[:city]).to be_a(String)
    end
  end

  describe '.generate_product_data' do
    it 'generates valid product data' do
      data = TestDataManager.generate_product_data
      
      expect(data).to have_key(:name)
      expect(data).to have_key(:price)
      expect(data).to have_key(:description)
      expect(data).to have_key(:category)
    end
  end

  describe '.generate_credit_card_data' do
    it 'generates valid credit card data' do
      data = TestDataManager.generate_credit_card_data
      
      expect(data).to have_key(:number)
      expect(data).to have_key(:name)
      expect(data).to have_key(:expiry)
      expect(data).to have_key(:cvv)
      
      expect(data[:cvv].length).to eq(3)
      expect(data[:expiry]).to match(%r{\d{1,2}/\d{2}})
    end
  end

  describe '.valid_login_credentials' do
    it 'returns valid credentials' do
      creds = TestDataManager.valid_login_credentials
      
      expect(creds[:username]).to eq('standard_user')
      expect(creds[:password]).to eq('secret_sauce')
    end
  end

  describe '.invalid_login_credentials' do
    it 'returns invalid credentials' do
      creds = TestDataManager.invalid_login_credentials
      
      expect(creds[:username]).to eq('invalid_user')
      expect(creds[:password]).to eq('wrong_password')
    end
  end

  describe '.sql_injection_payloads' do
    it 'returns array of SQL injection payloads' do
      payloads = TestDataManager.sql_injection_payloads
      
      expect(payloads).to be_an(Array)
      expect(payloads).not_to be_empty
      expect(payloads).to include("admin' OR '1'='1")
    end
  end

  describe '.xss_payloads' do
    it 'returns array of XSS payloads' do
      payloads = TestDataManager.xss_payloads
      
      expect(payloads).to be_an(Array)
      expect(payloads).not_to be_empty
      expect(payloads.first).to include('script')
    end
  end

  describe '.special_characters' do
    it 'returns array of special characters' do
      chars = TestDataManager.special_characters
      
      expect(chars).to be_an(Array)
      expect(chars).to include('@', '#', '$', '%')
    end
  end
end
