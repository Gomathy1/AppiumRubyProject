Given('I login with username {string} and password {string}') do |username, password|
  @login_page = LoginPage.new
  @login_page.login(username, password)
  sleep 2
  @products_page = ProductsPage.new
end

Then('I should see the products page') do
  expect(@products_page.is_products_page_displayed?).to be true
end

Then('I should see product items') do
  product_title = @products_page.get_product_title(0)
  expect(product_title).not_to be_empty
end

When('I add the first product to cart') do
  @products_page = ProductsPage.new unless @products_page
  @products_page.add_product_to_cart(0)
  sleep 1
end

When('I add the second product to cart') do
  @products_page.add_product_to_cart(1)
  sleep 1
end

Then('the cart badge should show {string}') do |count|
  badge_count = @products_page.get_cart_badge_count
  expect(badge_count).to eq(count)
end

When('I view the first product') do
  @product_title = @products_page.get_product_title(0)
  @product_price = @products_page.get_product_price(0)
end

Then('I should see the product title') do
  expect(@product_title).not_to be_empty
end

Then('I should see the product price') do
  expect(@product_price).to match(/\$\d+\.\d{2}/)
end
