Feature: Futurama Info Bot
  Test Futurama information retrieval

  Background:
    Given I log in
    And I start a new conversation

  Scenario: Get Futurama information
    When I say "Tell me about Futurama"
    Then response has 2 messages
    And first message has type card
    And first message content contains "Futurama"
    And first message content contains "Philip J. Fry"

  Scenario: Ask for help
    When I say "Help"
    Then response has 2 messages
    And first message has type card
    And first message content contains "Help" 