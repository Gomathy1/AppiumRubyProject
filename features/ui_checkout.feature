@ui @mobile @checkout
Feature: Checkout Process
  As a user
  I want to complete the checkout process
  So that I can purchase my items

  Background:
    Given the app is launched
    And I login with username "standard_user" and password "secret_sauce"
    And I add the first product to cart
    And I open the cart
    And I proceed to checkout

  @smoke @positive
  Scenario: View checkout page
    Then I should see the checkout page

  @positive
  Scenario: Complete shipping information
    When I enter shipping information:
      | field      | value              |
      | full_name  | John Doe          |
      | address1   | 123 Main St       |
      | city       | San Francisco     |
      | zip        | 94105             |
      | country    | United States     |
    And I proceed to payment
    Then I should be on the payment page

  @negative
  Scenario: Checkout with missing required fields
    When I proceed to payment
    Then I should see validation errors
