When('I open the cart') do
  @products_page = ProductsPage.new unless @products_page
  @products_page.open_cart
  sleep 1
  @cart_page = CartPage.new
end

Then('I should see the cart page') do
  expect(@cart_page.is_cart_page_displayed?).to be true
end

Then('I should see {string} item(s) in the cart') do |count|
  item_count = @cart_page.get_cart_item_count
  expect(item_count).to eq(count.to_i)
end

When('I remove the first item from cart') do
  @cart_page.remove_cart_item(0)
  sleep 1
end

When('I tap continue shopping') do
  @cart_page.continue_shopping
  sleep 1
  @products_page = ProductsPage.new
end

Then('I should see the total price') do
  total = @cart_page.get_total_price
  expect(total).to match(/\$\d+\.\d{2}/)
end

When('I proceed to checkout') do
  @cart_page = CartPage.new unless @cart_page
  @cart_page.proceed_to_checkout
  sleep 1
  @checkout_page = CheckoutPage.new
end
