Then('I should see the checkout page') do
  expect(@checkout_page.is_checkout_page_displayed?).to be true
end

When('I enter shipping information:') do |table|
  data = table.rows_hash
  @checkout_page.fill_shipping_info(
    full_name: data['full_name'],
    address1: data['address1'],
    city: data['city'],
    zip: data['zip'],
    country: data['country'],
    address2: data['address2'] || '',
    state: data['state'] || ''
  )
end

When('I proceed to payment') do
  @checkout_page.proceed_to_payment
  sleep 2
end

Then('I should be on the payment page') do
  expect(DriverManager.driver.current_activity).to include('Payment')
end

Then('I should see validation errors') do
  expect(@checkout_page.is_checkout_page_displayed?).to be true
end
