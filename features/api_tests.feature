@api
Feature: API Testing
  As a QA engineer
  I want to test REST APIs
  So that I can validate backend functionality

  @smoke @positive
  Scenario: Get all posts
    When I send a GET request to "/posts"
    Then the response status should be 200
    And the response should contain a list of posts

  @positive
  Scenario: Get a specific post
    When I send a GET request to "/posts/1"
    Then the response status should be 200
    And the response should contain:
      | field  | value              |
      | userId | 1                  |
      | id     | 1                  |
    And the response should have field "title"
    And the response should have field "body"

  @positive
  Scenario: Create a new post
    When I send a POST request to "/posts" with body:
      """
      {
        "title": "Test Post",
        "body": "This is a test post",
        "userId": 1
      }
      """
    Then the response status should be 201
    And the response should contain:
      | field  | value         |
      | title  | Test Post     |
      | body   | This is a test post |
      | userId | 1             |

  @positive
  Scenario: Update a post
    When I send a PUT request to "/posts/1" with body:
      """
      {
        "id": 1,
        "title": "Updated Title",
        "body": "Updated body",
        "userId": 1
      }
      """
    Then the response status should be 200
    And the response should contain:
      | field  | value          |
      | title  | Updated Title  |

  @positive
  Scenario: Delete a post
    When I send a DELETE request to "/posts/1"
    Then the response status should be 200

  @negative
  Scenario: Get non-existent post
    When I send a GET request to "/posts/99999"
    Then the response status should be 404

  @validation
  Scenario: Validate response schema
    When I send a GET request to "/posts/1"
    Then the response status should be 200
    And the response should match the post schema

  @performance
  Scenario: API response time validation
    When I send a GET request to "/posts"
    Then the response status should be 200
    And the response time should be less than 2000 ms
