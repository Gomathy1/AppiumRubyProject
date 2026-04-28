require_relative '../utils/driver_manager'

class BasePage
  attr_reader :driver

  def initialize
    @driver = DriverManager.driver
  end

  def find_element(locator)
    driver.find_element(locator)
  end

  def find_elements(locator)
    driver.find_elements(locator)
  end

  def tap(locator)
    find_element(locator).click
  end

  def send_keys(locator, text)
    find_element(locator).send_keys(text)
  end

  def clear_and_send_keys(locator, text)
    element = find_element(locator)
    element.clear
    element.send_keys(text)
  end

  def get_text(locator)
    find_element(locator).text
  end

  def is_displayed?(locator)
    find_element(locator).displayed?
  rescue StandardError
    false
  end

  def wait_for_element(locator, timeout = 10)
    wait = Selenium::WebDriver::Wait.new(timeout: timeout)
    wait.until { find_element(locator).displayed? }
  end

  def scroll_to_element(text)
    if DriverManager.android?
      driver.find_element(:uiautomator, "new UiScrollable(new UiSelector().scrollable(true)).scrollIntoView(text(\"#{text}\"))")
    else
      driver.execute_script('mobile: scroll', direction: 'down')
    end
  end

  def hide_keyboard
    driver.hide_keyboard if driver.is_keyboard_shown
  rescue StandardError
    # Keyboard not shown
  end
end
