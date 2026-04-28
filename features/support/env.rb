require 'appium_lib'
require 'rspec/expectations'
require 'cucumber'
require 'dotenv/load'
require 'allure-cucumber'
require_relative '../../lib/utils/driver_manager'
require_relative '../../lib/utils/logger'
require_relative '../../lib/utils/screenshot_helper'
require_relative '../../lib/utils/test_data_manager'
require_relative '../../lib/utils/api_helper'
require_relative '../../lib/pages/login_page'
require_relative '../../lib/pages/products_page'
require_relative '../../lib/pages/cart_page'
require_relative '../../lib/pages/checkout_page'

CustomLogger.setup

Before do |scenario|
  next if scenario.source_tag_names.include?('@api')
  
  CustomLogger.log_test_start(scenario.name)
  DriverManager.start_driver
end

After do |scenario|
  next if scenario.source_tag_names.include?('@api')
  
  if scenario.failed?
    ScreenshotHelper.take_screenshot_on_failure(DriverManager.driver, scenario.name)
  end
  
  status = scenario.failed? ? 'FAILED' : 'PASSED'
  CustomLogger.log_test_end(scenario.name, status)
  
  DriverManager.quit_driver
end

at_exit do
  DriverManager.quit_driver
  ScreenshotHelper.clear_old_screenshots(7)
end
