require_relative 'base_page'

class CheckoutPage < BasePage
  def checkout_title
    if DriverManager.android?
      { accessibility_id: 'Checkout' }
    else
      { accessibility_id: 'test-Checkout' }
    end
  end

  def full_name_field
    if DriverManager.android?
      { accessibility_id: 'Full Name* input field' }
    else
      { accessibility_id: 'test-Full Name' }
    end
  end

  def address_line1_field
    if DriverManager.android?
      { accessibility_id: 'Address Line 1* input field' }
    else
      { accessibility_id: 'test-Address Line 1' }
    end
  end

  def address_line2_field
    if DriverManager.android?
      { accessibility_id: 'Address Line 2 input field' }
    else
      { accessibility_id: 'test-Address Line 2' }
    end
  end

  def city_field
    if DriverManager.android?
      { accessibility_id: 'City* input field' }
    else
      { accessibility_id: 'test-City' }
    end
  end

  def state_field
    if DriverManager.android?
      { accessibility_id: 'State/Region input field' }
    else
      { accessibility_id: 'test-State/Region' }
    end
  end

  def zip_code_field
    if DriverManager.android?
      { accessibility_id: 'Zip Code* input field' }
    else
      { accessibility_id: 'test-Zip Code' }
    end
  end

  def country_field
    if DriverManager.android?
      { accessibility_id: 'Country* input field' }
    else
      { accessibility_id: 'test-Country' }
    end
  end

  def payment_button
    if DriverManager.android?
      { accessibility_id: 'To Payment button' }
    else
      { accessibility_id: 'test-To Payment' }
    end
  end

  def is_checkout_page_displayed?
    is_displayed?(checkout_title)
  end

  def enter_full_name(name)
    clear_and_send_keys(full_name_field, name)
  end

  def enter_address_line1(address)
    clear_and_send_keys(address_line1_field, address)
  end

  def enter_address_line2(address)
    clear_and_send_keys(address_line2_field, address)
  end

  def enter_city(city)
    clear_and_send_keys(city_field, city)
  end

  def enter_state(state)
    clear_and_send_keys(state_field, state)
  end

  def enter_zip_code(zip)
    clear_and_send_keys(zip_code_field, zip)
  end

  def enter_country(country)
    clear_and_send_keys(country_field, country)
  end

  def fill_shipping_info(full_name:, address1:, city:, zip:, country:, address2: '', state: '')
    enter_full_name(full_name)
    enter_address_line1(address1)
    enter_address_line2(address2) unless address2.empty?
    enter_city(city)
    enter_state(state) unless state.empty?
    enter_zip_code(zip)
    enter_country(country)
    hide_keyboard
  end

  def proceed_to_payment
    tap(payment_button)
  end
end
