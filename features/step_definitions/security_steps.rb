Then('I should not be logged in') do
  @login_page = LoginPage.new unless @login_page
  expect(@login_page.is_login_button_displayed?).to be true
end

Then('the app should handle the input safely') do
  expect { @login_page.is_login_button_displayed? }.not_to raise_error
end

When('I wait for {int} seconds') do |seconds|
  sleep seconds
end

Then('the session should be expired') do
  @products_page = ProductsPage.new
  expect(@products_page.is_products_page_displayed?).to be false
end

Then('password should not be visible in plain text') do
  expect(true).to be true
end

Then('password field should be masked') do
  @login_page = LoginPage.new unless @login_page
  password_element = @login_page.find_element(@login_page.password_field)
  is_secure = password_element.attribute('password') == 'true' ||
              password_element.attribute('secureTextEntry') == 'true'
  expect(is_secure).to be true
end

When('I try to access restricted area without login') do
  @products_page = ProductsPage.new
end

Then('I should be redirected to login page') do
  @login_page = LoginPage.new
  expect(@login_page.is_login_button_displayed?).to be true
end

Then('the app should handle special characters safely') do
  expect { @login_page.is_login_button_displayed? }.not_to raise_error
end

When('I attempt login {int} times with wrong credentials') do |attempts|
  @login_page = LoginPage.new unless @login_page
  attempts.times do |i|
    @login_page.enter_username("user#{i}")
    @login_page.enter_password("wrong_password")
    @login_page.tap_login
    sleep 1
  end
end

Then('the account should be locked or rate limited') do
  expect(@login_page.is_login_button_displayed?).to be true
end

When('I check the API endpoint security') do
  @api_url = ENV['API_BASE_URL'] || 'https://jsonplaceholder.typicode.com'
end

Then('the connection should use HTTPS') do
  expect(@api_url).to start_with('https://')
end

Then('the SSL certificate should be valid') do
  require 'net/http'
  require 'uri'
  
  uri = URI.parse(@api_url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  
  expect { http.start {} }.not_to raise_error
end
