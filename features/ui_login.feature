@ui @mobile
Feature: Login Functionality
  As a user
  I want to login to the app
  So that I can access my account

  Background:
    Given the app is launched

  @smoke @positive
  Scenario: Successful login with valid credentials
    When I enter username "standard_user"
    And I enter password "secret_sauce"
    And I tap the login button
    Then I should be logged in successfully

  @negative
  Scenario: Login with invalid credentials
    When I enter username "invalid_user"
    And I enter password "wrong_password"
    And I tap the login button
    Then I should see an error message "Username and password do not match"

  @validation
  Scenario Outline: Login with different credentials
    When I enter username "<username>"
    And I enter password "<password>"
    And I tap the login button
    Then I should see "<result>"

    Examples:
      | username      | password      | result                                  |
      | standard_user | secret_sauce  | success                                 |
      | locked_user   | secret_sauce  | Sorry, this user has been locked out    |
      |               | secret_sauce  | Username is required                    |
      | standard_user |               | Password is required                    |
