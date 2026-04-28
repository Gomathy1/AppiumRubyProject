require 'dotenv/load'

module AppiumConfig
  def self.android_caps
    {
      platformName: 'Android',
      'appium:platformVersion': ENV['PLATFORM_VERSION'] || '13.0',
      'appium:deviceName': ENV['DEVICE_NAME'] || 'Pixel_7_API_33',
      'appium:app': ENV['ANDROID_APP_PATH'] || './apps/android/app-debug.apk',
      'appium:automationName': 'UiAutomator2',
      'appium:appPackage': 'com.saucelabs.mydemoapp.rn',
      'appium:appActivity': '.MainActivity',
      'appium:noReset': false,
      'appium:fullReset': false,
      'appium:newCommandTimeout': 300
    }
  end

  def self.ios_caps
    {
      platformName: 'iOS',
      'appium:platformVersion': ENV['IOS_PLATFORM_VERSION'] || '16.0',
      'appium:deviceName': ENV['IOS_DEVICE_NAME'] || 'iPhone 14',
      'appium:app': ENV['IOS_APP_PATH'] || './apps/ios/app.app',
      'appium:automationName': 'XCUITest',
      'appium:bundleId': 'com.saucelabs.mydemoapp.rn',
      'appium:noReset': false,
      'appium:fullReset': false,
      'appium:newCommandTimeout': 300
    }
  end

  def self.appium_server_url
    ENV['APPIUM_SERVER_URL'] || 'http://127.0.0.1:4723'
  end

  def self.platform
    (ENV['PLATFORM'] || 'android').downcase
  end

  def self.capabilities
    platform == 'ios' ? ios_caps : android_caps
  end
end
