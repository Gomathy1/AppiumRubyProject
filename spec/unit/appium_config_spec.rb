require 'spec_helper'
require_relative '../../config/appium_config'

RSpec.describe AppiumConfig do
  describe '.android_caps' do
    it 'returns Android capabilities' do
      caps = AppiumConfig.android_caps
      
      expect(caps[:platformName]).to eq('Android')
      expect(caps[:'appium:automationName']).to eq('UiAutomator2')
      expect(caps[:'appium:appPackage']).to eq('com.saucelabs.mydemoapp.rn')
      expect(caps[:'appium:appActivity']).to eq('.MainActivity')
    end

    it 'uses environment variables when available' do
      ENV['PLATFORM_VERSION'] = '12.0'
      ENV['DEVICE_NAME'] = 'TestDevice'
      
      caps = AppiumConfig.android_caps
      
      expect(caps[:'appium:platformVersion']).to eq('12.0')
      expect(caps[:'appium:deviceName']).to eq('TestDevice')
    end

    it 'uses default values when environment variables are not set' do
      ENV.delete('PLATFORM_VERSION')
      ENV.delete('DEVICE_NAME')
      
      caps = AppiumConfig.android_caps
      
      expect(caps[:'appium:platformVersion']).to eq('13.0')
      expect(caps[:'appium:deviceName']).to eq('Pixel_7_API_33')
    end
  end

  describe '.ios_caps' do
    it 'returns iOS capabilities' do
      caps = AppiumConfig.ios_caps
      
      expect(caps[:platformName]).to eq('iOS')
      expect(caps[:'appium:automationName']).to eq('XCUITest')
      expect(caps[:'appium:bundleId']).to eq('com.saucelabs.mydemoapp.rn')
    end

    it 'uses environment variables when available' do
      ENV['IOS_PLATFORM_VERSION'] = '15.0'
      ENV['IOS_DEVICE_NAME'] = 'iPhone 13'
      
      caps = AppiumConfig.ios_caps
      
      expect(caps[:'appium:platformVersion']).to eq('15.0')
      expect(caps[:'appium:deviceName']).to eq('iPhone 13')
    end
  end

  describe '.appium_server_url' do
    it 'returns default URL when environment variable is not set' do
      ENV.delete('APPIUM_SERVER_URL')
      
      expect(AppiumConfig.appium_server_url).to eq('http://127.0.0.1:4723')
    end

    it 'returns environment variable value when set' do
      ENV['APPIUM_SERVER_URL'] = 'http://localhost:4724'
      
      expect(AppiumConfig.appium_server_url).to eq('http://localhost:4724')
    end
  end

  describe '.platform' do
    it 'returns android by default' do
      ENV.delete('PLATFORM')
      
      expect(AppiumConfig.platform).to eq('android')
    end

    it 'returns ios when set' do
      ENV['PLATFORM'] = 'iOS'
      
      expect(AppiumConfig.platform).to eq('ios')
    end

    it 'converts platform to lowercase' do
      ENV['PLATFORM'] = 'ANDROID'
      
      expect(AppiumConfig.platform).to eq('android')
    end
  end

  describe '.capabilities' do
    it 'returns Android capabilities when platform is android' do
      ENV['PLATFORM'] = 'android'
      
      caps = AppiumConfig.capabilities
      
      expect(caps[:platformName]).to eq('Android')
    end

    it 'returns iOS capabilities when platform is ios' do
      ENV['PLATFORM'] = 'ios'
      
      caps = AppiumConfig.capabilities
      
      expect(caps[:platformName]).to eq('iOS')
    end
  end
end
