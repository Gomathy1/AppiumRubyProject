@ui @mobile @products
Feature: Product Catalog
  As a user
  I want to browse and manage products
  So that I can add items to my cart

  Background:
    Given the app is launched
    And I login with username "standard_user" and password "secret_sauce"

  @smoke @positive
  Scenario: View products page
    Then I should see the products page
    And I should see product items

  @positive
  Scenario: Add product to cart
    When I add the first product to cart
    Then the cart badge should show "1"

  @positive
  Scenario: Add multiple products to cart
    When I add the first product to cart
    And I add the second product to cart
    Then the cart badge should show "2"

  @positive
  Scenario: View product details
    When I view the first product
    Then I should see the product title
    And I should see the product price
