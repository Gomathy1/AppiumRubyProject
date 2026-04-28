require_relative 'base_page'

class LoginPage < BasePage
  # Locators
  def username_field
    if DriverManager.android?
      { accessibility_id: 'Username input field' }
    else
      { accessibility_id: 'test-Username' }
    end
  end

  def password_field
    if DriverManager.android?
      { accessibility_id: 'Password input field' }
    else
      { accessibility_id: 'test-Password' }
    end
  end

  def login_button
    if DriverManager.android?
      { accessibility_id: 'Login button' }
    else
      { accessibility_id: 'test-LOGIN' }
    end
  end

  def error_message
    if DriverManager.android?
      { xpath: '//*[@content-desc="generic-error-message"]' }
    else
      { accessibility_id: 'test-Error message' }
    end
  end

  # Actions
  def enter_username(username)
    clear_and_send_keys(username_field, username)
  end

  def enter_password(password)
    clear_and_send_keys(password_field, password)
  end

  def tap_login
    tap(login_button)
  end

  def login(username, password)
    enter_username(username)
    enter_password(password)
    hide_keyboard
    tap_login
  end

  def get_error_message
    get_text(error_message)
  end

  def is_login_button_displayed?
    is_displayed?(login_button)
  end
end
