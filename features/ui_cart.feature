@ui @mobile @cart
Feature: Shopping Cart
  As a user
  I want to manage my shopping cart
  So that I can review and modify my order

  Background:
    Given the app is launched
    And I login with username "standard_user" and password "secret_sauce"
    And I add the first product to cart

  @smoke @positive
  Scenario: View cart
    When I open the cart
    Then I should see the cart page
    And I should see "1" item in the cart

  @positive
  Scenario: Remove item from cart
    When I open the cart
    And I remove the first item from cart
    Then I should see "0" items in the cart

  @positive
  Scenario: Continue shopping from cart
    When I open the cart
    And I tap continue shopping
    Then I should see the products page

  @positive
  Scenario: View cart total
    When I open the cart
    Then I should see the total price
