require 'faker'
require 'json'

class TestDataManager
  def self.generate_user_data
    {
      username: Faker::Internet.username(specifier: 5..10),
      password: Faker::Internet.password(min_length: 8, max_length: 16),
      email: Faker::Internet.email,
      first_name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      phone: Faker::PhoneNumber.phone_number
    }
  end

  def self.generate_address_data
    {
      full_name: Faker::Name.name,
      address_line1: Faker::Address.street_address,
      address_line2: Faker::Address.secondary_address,
      city: Faker::Address.city,
      state: Faker::Address.state,
      zip_code: Faker::Address.zip_code,
      country: Faker::Address.country
    }
  end

  def self.generate_product_data
    {
      name: Faker::Commerce.product_name,
      price: Faker::Commerce.price,
      description: Faker::Lorem.paragraph,
      category: Faker::Commerce.department
    }
  end

  def self.generate_credit_card_data
    {
      number: Faker::Finance.credit_card,
      name: Faker::Name.name,
      expiry: "#{Faker::Number.between(from: 1, to: 12)}/#{Faker::Number.between(from: 24, to: 30)}",
      cvv: Faker::Number.number(digits: 3).to_s
    }
  end

  def self.load_test_data(file_path)
    JSON.parse(File.read(file_path))
  rescue StandardError => e
    puts "Error loading test data: #{e.message}"
    {}
  end

  def self.save_test_data(data, file_path)
    File.write(file_path, JSON.pretty_generate(data))
  rescue StandardError => e
    puts "Error saving test data: #{e.message}"
  end

  def self.valid_login_credentials
    {
      username: 'standard_user',
      password: 'secret_sauce'
    }
  end

  def self.invalid_login_credentials
    {
      username: 'invalid_user',
      password: 'wrong_password'
    }
  end

  def self.locked_user_credentials
    {
      username: 'locked_out_user',
      password: 'secret_sauce'
    }
  end

  def self.sql_injection_payloads
    [
      "admin' OR '1'='1",
      "admin'--",
      "admin' #",
      "' OR 1=1--",
      "' UNION SELECT NULL--"
    ]
  end

  def self.xss_payloads
    [
      "<script>alert('XSS')</script>",
      "<img src=x onerror=alert('XSS')>",
      "javascript:alert('XSS')",
      "<svg/onload=alert('XSS')>"
    ]
  end

  def self.special_characters
    ['@', '#', '$', '%', '^', '&', '*', '(', ')', '<', '>', '/', '\\', '"', "'"]
  end
end
