require 'appium_lib'
require_relative '../../config/appium_config'

class DriverManager
  @driver = nil

  def self.start_driver
    opts = {
      caps: AppiumConfig.capabilities,
      appium_lib: {
        server_url: AppiumConfig.appium_server_url,
        wait_timeout: ENV['EXPLICIT_WAIT']&.to_i || 20,
        wait_interval: 1
      }
    }

    @driver = Appium::Driver.new(opts, true)
    @driver.start_driver
    @driver.manage.timeouts.implicit_wait = ENV['IMPLICIT_WAIT']&.to_i || 10
    @driver
  end

  def self.driver
    @driver
  end

  def self.quit_driver
    @driver&.quit
    @driver = nil
  end

  def self.reset_app
    @driver&.reset if @driver
  end

  def self.platform
    AppiumConfig.platform
  end

  def self.android?
    platform == 'android'
  end

  def self.ios?
    platform == 'ios'
  end
end
