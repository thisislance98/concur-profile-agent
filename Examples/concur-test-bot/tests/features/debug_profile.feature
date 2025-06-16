Feature: Debug Travel Profile Retrieval
  Single test to debug travel profile API call

  Background:
    Given I log in
    And I start a new conversation

  Scenario: Test travel profile retrieval
    When I say "Show my profile"
    Then response has 1 message 