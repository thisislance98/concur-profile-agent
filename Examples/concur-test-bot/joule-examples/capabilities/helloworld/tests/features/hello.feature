Feature: HelloWorld capability

Feature Description

  Background:
    Given I log in
    And I start a new conversation

  Scenario: Ask Hello
    When I say "Hello World"
    Then response has 1 message
    And first message has type text
    And first message content contains "Hello"

  Scenario: Ask Hello
    When I say "Hello, i am Michael"
    Then response has 1 message
    And first message has type text
    And first message content contains "Michael"