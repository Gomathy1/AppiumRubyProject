Given('the app is launched') do
  @login_page = LoginPage.new
  expect(@login_page.is_login_button_displayed?).to be true
end

When('I enter username {string}') do |username|
  @login_page.enter_username(username)
end

When('I enter password {string}') do |password|
  @login_page.enter_password(password)
end

When('I tap the login button') do
  @login_page.tap_login
  sleep 2 # Wait for response
end

Then('I should be logged in successfully') do
  # Verify we're on the products page (implementation depends on app)
  expect(DriverManager.driver.current_activity).not_to include('Login')
end

Then('I should see an error message {string}') do |expected_message|
  actual_message = @login_page.get_error_message
  expect(actual_message).to include(expected_message)
end

Then('I should see {string}') do |result|
  if result == 'success'
    expect(DriverManager.driver.current_activity).not_to include('Login')
  else
    actual_message = @login_page.get_error_message
    expect(actual_message).to include(result)
  end
end
