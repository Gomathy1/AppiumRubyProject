require_relative 'base_page'

class CartPage < BasePage
  def cart_title
    if DriverManager.android?
      { accessibility_id: 'My Cart' }
    else
      { accessibility_id: 'test-Cart' }
    end
  end

  def cart_item(index = 0)
    if DriverManager.android?
      { xpath: "(//android.view.ViewGroup[@content-desc='cart item'])[#{index + 1}]" }
    else
      { xpath: "(//XCUIElementTypeOther[@name='cart item'])[#{index + 1}]" }
    end
  end

  def cart_item_title(index = 0)
    if DriverManager.android?
      { xpath: "(//android.view.ViewGroup[@content-desc='cart item'])[#{index + 1}]//android.widget.TextView[1]" }
    else
      { xpath: "(//XCUIElementTypeOther[@name='cart item'])[#{index + 1}]//XCUIElementTypeStaticText[1]" }
    end
  end

  def cart_item_price(index = 0)
    if DriverManager.android?
      { xpath: "(//android.view.ViewGroup[@content-desc='cart item'])[#{index + 1}]//android.widget.TextView[contains(@text, '$')]" }
    else
      { xpath: "(//XCUIElementTypeOther[@name='cart item'])[#{index + 1}]//XCUIElementTypeStaticText[contains(@name, '$')]" }
    end
  end

  def remove_item_button(index = 0)
    if DriverManager.android?
      { xpath: "(//android.view.ViewGroup[@content-desc='remove item'])[#{index + 1}]" }
    else
      { xpath: "(//XCUIElementTypeOther[@name='remove item'])[#{index + 1}]" }
    end
  end

  def checkout_button
    if DriverManager.android?
      { accessibility_id: 'Proceed To Checkout button' }
    else
      { accessibility_id: 'test-Checkout' }
    end
  end

  def continue_shopping_button
    if DriverManager.android?
      { accessibility_id: 'Continue Shopping button' }
    else
      { accessibility_id: 'test-Continue Shopping' }
    end
  end

  def total_price
    if DriverManager.android?
      { accessibility_id: 'total price' }
    else
      { accessibility_id: 'test-Total' }
    end
  end

  def is_cart_page_displayed?
    is_displayed?(cart_title)
  end

  def get_cart_item_count
    find_elements(cart_item(0)).size
  end

  def get_cart_item_title(index = 0)
    get_text(cart_item_title(index))
  end

  def get_cart_item_price(index = 0)
    get_text(cart_item_price(index))
  end

  def remove_cart_item(index = 0)
    tap(remove_item_button(index))
  end

  def proceed_to_checkout
    tap(checkout_button)
  end

  def continue_shopping
    tap(continue_shopping_button)
  end

  def get_total_price
    get_text(total_price)
  end
end
