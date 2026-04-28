@security
Feature: Security Testing
  As a security tester
  I want to validate application security
  So that I can ensure the app is secure

  @security @authentication
  Scenario: SQL Injection in login
    Given the app is launched
    When I enter username "admin' OR '1'='1"
    And I enter password "password' OR '1'='1"
    And I tap the login button
    Then I should see an error message
    And I should not be logged in

  @security @authentication
  Scenario: XSS attempt in username field
    Given the app is launched
    When I enter username "<script>alert('XSS')</script>"
    And I enter password "password"
    And I tap the login button
    Then the app should handle the input safely

  @security @session
  Scenario: Session timeout validation
    Given the app is launched
    And I login with username "standard_user" and password "secret_sauce"
    When I wait for 300 seconds
    Then the session should be expired

  @security @data
  Scenario: Sensitive data exposure in logs
    Given the app is launched
    When I enter username "standard_user"
    And I enter password "secret_sauce"
    Then password should not be visible in plain text
    And password field should be masked

  @security @authorization
  Scenario: Unauthorized access attempt
    Given the app is launched
    When I try to access restricted area without login
    Then I should be redirected to login page

  @security @input_validation
  Scenario Outline: Input validation for special characters
    Given the app is launched
    When I enter username "<username>"
    And I enter password "<password>"
    And I tap the login button
    Then the app should handle special characters safely

    Examples:
      | username          | password          |
      | user@#$%          | pass@#$%          |
      | user<>            | pass<>            |
      | user&amp;         | pass&amp;         |
      | user"quotes"      | pass"quotes"      |
      | user'single'      | pass'single'      |

  @security @brute_force
  Scenario: Brute force protection
    Given the app is launched
    When I attempt login 5 times with wrong credentials
    Then the account should be locked or rate limited

  @security @ssl
  Scenario: SSL/TLS certificate validation
    When I check the API endpoint security
    Then the connection should use HTTPS
    And the SSL certificate should be valid
