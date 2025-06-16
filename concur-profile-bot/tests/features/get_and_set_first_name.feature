Feature: Get and Set User First Name
  Test the scenario that gets and sets the user's first name in Concur Travel Profile.

  Background:
    Given I log in
    And I start a new conversation

  Scenario: Get the user's first name
    When I say "What is my first name?"
    Then response has 1 message
    And first message has type text
    And first message content contains "first name is"

  Scenario: Set the user's first name
    When I say "Set my first name to TestName"
    Then response has 1 message
    And first message has type text
    And first message content contains "Successfully updated the user's first name to TestName"

  Scenario: Get the user's first name after update
    When I say "What is my first name?"
    Then response has 1 message
    And first message has type text
    And first message content contains "TestName" 