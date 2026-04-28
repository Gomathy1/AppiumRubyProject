require_relative 'base_page'

class ProductsPage < BasePage
  def products_title
    if DriverManager.android?
      { accessibility_id: 'Products' }
    else
      { accessibility_id: 'test-Products' }
    end
  end

  def product_item(index = 0)
    if DriverManager.android?
      { xpath: "(//android.view.ViewGroup[@content-desc='store item'])[#{index + 1}]" }
    else
      { xpath: "(//XCUIElementTypeOther[@name='store item'])[#{index + 1}]" }
    end
  end

  def product_title(index = 0)
    if DriverManager.android?
      { xpath: "(//android.view.ViewGroup[@content-desc='store item'])[#{index + 1}]//android.widget.TextView[1]" }
    else
      { xpath: "(//XCUIElementTypeOther[@name='store item'])[#{index + 1}]//XCUIElementTypeStaticText[1]" }
    end
  end

  def product_price(index = 0)
    if DriverManager.android?
      { xpath: "(//android.view.ViewGroup[@content-desc='store item'])[#{index + 1}]//android.widget.TextView[2]" }
    else
      { xpath: "(//XCUIElementTypeOther[@name='store item'])[#{index + 1}]//XCUIElementTypeStaticText[2]" }
    end
  end

  def add_to_cart_button(index = 0)
    if DriverManager.android?
      { xpath: "(//android.view.ViewGroup[@content-desc='Add To Cart button'])[#{index + 1}]" }
    else
      { xpath: "(//XCUIElementTypeOther[@name='Add To Cart button'])[#{index + 1}]" }
    end
  end

  def cart_badge
    if DriverManager.android?
      { accessibility_id: 'cart badge' }
    else
      { accessibility_id: 'test-Cart badge' }
    end
  end

  def cart_icon
    if DriverManager.android?
      { accessibility_id: 'cart badge' }
    else
      { accessibility_id: 'test-Cart' }
    end
  end

  def sort_button
    if DriverManager.android?
      { accessibility_id: 'sort button' }
    else
      { accessibility_id: 'test-Modal Selector Button' }
    end
  end

  def is_products_page_displayed?
    is_displayed?(products_title)
  end

  def get_product_title(index = 0)
    get_text(product_title(index))
  end

  def get_product_price(index = 0)
    get_text(product_price(index))
  end

  def add_product_to_cart(index = 0)
    tap(add_to_cart_button(index))
  end

  def get_cart_badge_count
    get_text(cart_badge)
  rescue StandardError
    '0'
  end

  def open_cart
    tap(cart_icon)
  end

  def tap_sort
    tap(sort_button)
  end
end
