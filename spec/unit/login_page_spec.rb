require 'spec_helper'
require_relative '../../lib/pages/login_page'
require_relative '../../lib/utils/driver_manager'

RSpec.describe LoginPage do
  let(:mock_driver) { double('driver') }
  let(:mock_element) { double('element') }
  let(:login_page) { LoginPage.new }

  before do
    allow(DriverManager).to receive(:driver).and_return(mock_driver)
  end

  describe '#username_field' do
    it 'returns Android locator when platform is android' do
      allow(DriverManager).to receive(:android?).and_return(true)
      
      locator = login_page.username_field
      
      expect(locator).to eq({ accessibility_id: 'Username input field' })
    end

    it 'returns iOS locator when platform is ios' do
      allow(DriverManager).to receive(:android?).and_return(false)
      
      locator = login_page.username_field
      
      expect(locator).to eq({ accessibility_id: 'test-Username' })
    end
  end

  describe '#password_field' do
    it 'returns Android locator when platform is android' do
      allow(DriverManager).to receive(:android?).and_return(true)
      
      locator = login_page.password_field
      
      expect(locator).to eq({ accessibility_id: 'Password input field' })
    end

    it 'returns iOS locator when platform is ios' do
      allow(DriverManager).to receive(:android?).and_return(false)
      
      locator = login_page.password_field
      
      expect(locator).to eq({ accessibility_id: 'test-Password' })
    end
  end

  describe '#login_button' do
    it 'returns Android locator when platform is android' do
      allow(DriverManager).to receive(:android?).and_return(true)
      
      locator = login_page.login_button
      
      expect(locator).to eq({ accessibility_id: 'Login button' })
    end

    it 'returns iOS locator when platform is ios' do
      allow(DriverManager).to receive(:android?).and_return(false)
      
      locator = login_page.login_button
      
      expect(locator).to eq({ accessibility_id: 'test-LOGIN' })
    end
  end

  describe '#enter_username' do
    it 'clears and enters username' do
      allow(DriverManager).to receive(:android?).and_return(true)
      expect(mock_driver).to receive(:find_element).and_return(mock_element)
      expect(mock_element).to receive(:clear)
      expect(mock_element).to receive(:send_keys).with('testuser')
      
      login_page.enter_username('testuser')
    end
  end

  describe '#enter_password' do
    it 'clears and enters password' do
      allow(DriverManager).to receive(:android?).and_return(true)
      expect(mock_driver).to receive(:find_element).and_return(mock_element)
      expect(mock_element).to receive(:clear)
      expect(mock_element).to receive(:send_keys).with('password123')
      
      login_page.enter_password('password123')
    end
  end

  describe '#tap_login' do
    it 'taps the login button' do
      allow(DriverManager).to receive(:android?).and_return(true)
      expect(mock_driver).to receive(:find_element).and_return(mock_element)
      expect(mock_element).to receive(:click)
      
      login_page.tap_login
    end
  end

  describe '#login' do
    it 'performs complete login flow' do
      allow(DriverManager).to receive(:android?).and_return(true)
      allow(mock_driver).to receive(:find_element).and_return(mock_element)
      allow(mock_element).to receive(:clear)
      allow(mock_element).to receive(:send_keys)
      allow(mock_element).to receive(:click)
      allow(mock_driver).to receive(:is_keyboard_shown).and_return(false)
      
      expect { login_page.login('user', 'pass') }.not_to raise_error
    end
  end

  describe '#get_error_message' do
    it 'returns error message text' do
      allow(DriverManager).to receive(:android?).and_return(true)
      expect(mock_driver).to receive(:find_element).and_return(mock_element)
      expect(mock_element).to receive(:text).and_return('Invalid credentials')
      
      result = login_page.get_error_message
      
      expect(result).to eq('Invalid credentials')
    end
  end

  describe '#is_login_button_displayed?' do
    it 'returns true when login button is visible' do
      allow(DriverManager).to receive(:android?).and_return(true)
      expect(mock_driver).to receive(:find_element).and_return(mock_element)
      expect(mock_element).to receive(:displayed?).and_return(true)
      
      result = login_page.is_login_button_displayed?
      
      expect(result).to be true
    end
  end
end
