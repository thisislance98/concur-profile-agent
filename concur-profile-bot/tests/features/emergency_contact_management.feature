Feature: Emergency Contact Management
  Test the scenario that manages emergency contact information in Concur Travel Profile.

  Background:
    Given I log in
    And I start a new conversation

  @test_view
  Scenario: View current emergency contact
    When I say "manage emergency contact"
    Then response has 1 message
    And first message has type text
    And first message content contains "Emergency Contact Information"

  Scenario: Add complete emergency contact
    When I say "Add emergency contact John Smith, spouse, daytime phone 555-123-4567, 123 Main St, Boston, MA 02101"
    Then response has 1 message
    And first message has type text
    And first message content contains "Emergency Contact Added Successfully"
    And first message content contains "John Smith"
    And first message content contains "spouse"

  Scenario: Update emergency contact name only
    When I say "Update my emergency contact name to Jane Doe"
    Then response has 1 message
    And first message has type text
    And first message content contains "Emergency Contact Updated Successfully"
    And first message content contains "Jane Doe"

  Scenario: Update emergency contact daytime phone only
    When I say "Update emergency contact daytime phone to 555-987-6543"
    Then response has 1 message
    And first message has type text
    And first message content contains "Emergency Contact Updated Successfully"

  Scenario: Update emergency contact street address only
    When I say "Update emergency contact street to 456 Oak Street"
    Then response has 1 message
    And first message has type text
    And first message content contains "Emergency Contact Updated Successfully"

  Scenario: Update emergency contact city only
    When I say "Update emergency contact city to Cambridge"
    Then response has 1 message
    And first message has type text
    And first message content contains "Emergency Contact Updated Successfully"

  Scenario: Add alternate phone to existing contact
    When I say "Update emergency contact alternate phone to 555-111-2222"
    Then response has 1 message
    And first message has type text
    And first message content contains "Emergency Contact Updated Successfully"

  Scenario: Update emergency contact relationship only
    When I say "Update my emergency contact relationship to brother"
    Then response has 1 message
    And first message has type text
    And first message content contains "Emergency Contact Updated Successfully"
    And first message content contains "brother"

  Scenario: View emergency contact after multiple updates
    When I say "Show my emergency contact"
    Then response has 1 message
    And first message has type text
    And first message content contains "Emergency Contact Information"
    And first message content contains "Jane Doe"
    And first message content contains "brother"

  Scenario: Delete emergency contact daytime phone
    When I say "Delete my emergency contact daytime phone"
    Then response has 1 message
    And first message has type text
    And first message content contains "Emergency Contact Deleted Successfully"

  Scenario: Delete emergency contact alternate phone
    When I say "Delete my emergency contact alternate phone"
    Then response has 1 message
    And first message has type text
    And first message content contains "Emergency Contact Deleted Successfully"

  Scenario: Delete emergency contact address
    When I say "Delete my emergency contact address"
    Then response has 1 message
    And first message has type text
    And first message content contains "Emergency Contact Deleted Successfully"

  Scenario: Delete entire emergency contact
    When I say "Delete my emergency contact"
    Then response has 1 message
    And first message has type text
    And first message content contains "Emergency Contact Deleted Successfully"

  Scenario: Verify emergency contact is deleted
    When I say "Show my emergency contact"
    Then response has 1 message
    And first message has type text
    And first message content contains "No emergency contact on file"
