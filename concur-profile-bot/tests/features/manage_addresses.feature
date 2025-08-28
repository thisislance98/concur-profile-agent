Feature: Address Management
  Test the scenario that manages address information (home and work addresses) in Concur Travel Profile.

  Background:
    Given I log in
    And I start a new conversation

  @test_view_addresses_default
  Scenario: View addresses with no action specified
    When I say "manage addresses"
    Then response has 1 message
    And first message has type text
    And first message content contains "Your Addresses"
    And first message content contains "What would you like to do?"

  @test_view_addresses_show
  Scenario: Show current addresses
    When I say "show my addresses"
    Then response has 1 message
    And first message has type empty

  @test_add_address_missing_type
  Scenario: Add address without specifying type
    When I say "add address 123 Main St"
    Then response has 1 message
    And first message has type text
    And first message content contains "Missing Address Type"
    And first message content contains "specify the address type"

  @test_add_address_missing_fields
  Scenario: Add address with type but missing required fields
    When I say "add my home address"
    Then response has 1 message
    And first message has type text
    And first message content contains "Missing Required Fields"
    And first message content contains "Street address"
    And first message content contains "City"

  @test_add_complete_home_address
  Scenario: Add complete home address
    When I say "Add my home address 123 Main St, San Francisco, CA 94105"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Adding home address"
    And second message has type text
    And second message content contains "Address Added Successfully"

  @test_add_complete_work_address
  Scenario: Add complete work address
    When I say "Add my work address 456 Business Ave, New York, NY 10001"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Adding work address"
    And second message has type text
    And second message content contains "Address Added Successfully"

  @test_add_address_with_country
  Scenario: Add address with country specified
    When I say "Add my home address 789 Oak St, Toronto, ON M5V 3A8, Canada"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Adding home address"

  @test_update_address_no_addresses
  Scenario: Update address when no addresses exist
    When I say "update my home address"
    Then response has 1 message
    And first message has type text
    And first message content contains "No Addresses Found"
    And first message content contains "add an address first"


  @test_update_address_multiple_exist
  Scenario: Update address when multiple addresses exist
    Given I say "Add my home address 123 Main St, San Francisco, CA 94105"
    When I say "update my address street to 789 Oak St"
    Then response has 1 message
    And first message has type text
    And first message content contains "Which address would you like to update?"
    And first message content contains "home:"
    And first message content contains "work:"

  @test_update_specific_address_type
  Scenario: Update specific address type
    Given I say "Add my home address 123 Main St, San Francisco, CA 94105"
    When I say "Update my home address city to Los Angeles"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Updating home address"
    And second message has type text
    And second message content contains "Address Updated Successfully"

  @test_update_nonexistent_address
  Scenario: Update address type that doesn't exist
    Given I say "Add my home address 123 Main St, San Francisco, CA 94105"
    When I say "Update my work address"
    Then response has 1 message
    And first message has type text
    And first message content contains "Address Not Found"
    And first message content contains "No work address found"

  @test_addresses_update_multiple_fields
  Scenario: Update multiple address fields at once
    Given I say "Add my home address 123 Main St, San Francisco, CA 94105"
    When I say "Update my home address street to 456 Oak Ave and city to Oakland"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Updating home address"
    And first message content contains "Street:"
    And first message content contains "City:"

  @test_delete_address_no_addresses
  Scenario: Delete address when no addresses exist
    When I say "delete my address"
    Then response has 1 message
    And first message has type text
    And first message content contains "No Addresses Found"
    And first message content contains "don't have any addresses to delete"

  @test_delete_address_show_selection
  Scenario: Delete address without specifying which one (shows selection list)
    Given I say "Add my home address 123 Main St, San Francisco, CA 94105"
    And I say "Add my work address 456 Business Ave, New York, NY 10001"
    When I say "delete my address"
    Then response has 1 message
    And first message has type list

  @test_delete_specific_address
  Scenario: Delete specific address type
    Given I say "Add my home address 123 Main St, San Francisco, CA 94105"
    When I say "Delete my home address"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Deleting home address"
    And second message has type text
    And second message content contains "Address Deleted Successfully"

  @test_address_type_variations
  Scenario: Handle different address type variations
    When I say "Add my HOME address 123 Main St, San Francisco, CA 94105"
    Then response has 2 messages
    And first message content contains "Adding home address"

  @test_address_with_apartment
  Scenario: Add address with apartment/unit number
    When I say "Add my home address 123 Main St Apt 4B, San Francisco, CA 94105"
    Then response has 2 messages
    And first message content contains "Adding home address"

  @test_address_international_format
  Scenario: Add international address
    When I say "Add my home address 10 Downing Street, London, UK SW1A 2AA"
    Then response has 2 messages
    And first message content contains "Adding home address"

  @test_addresses_partial_address_update
  Scenario: Update only one field of an address
    Given I say "Add my home address 123 Main St, San Francisco, CA 94105"
    When I say "Update my home address zip code to 94102"
    Then response has 2 messages
    And first message content contains "Updating home address"
    And first message content contains "Zip:"

  @test_state_abbreviations
  Scenario: Handle state abbreviations
    When I say "Add my work address 456 Business Ave, NYC, NY 10001"
    Then response has 2 messages
    And first message content contains "Adding work address"

  @test_zip_code_variations
  Scenario: Handle different zip code formats
    When I say "Add my home address 123 Main St, San Francisco, CA 94105-1234"
    Then response has 2 messages
    And first message content contains "Adding home address"

  @test_view_help_addresses
  Scenario: Get help for address management
    When I say "how do I add an address"
    Then response has 1 message
    And first message content contains "Examples:"
    And first message content contains "Add my home address"

  @test_addresses_natural_language_add
  Scenario: Natural language address addition
    When I say "I need to add my home address which is 123 Oak Street in Boston Massachusetts 02101"
    Then response has 2 messages
    And first message content contains "Adding home address"

  @test_addresses_natural_language_update
  Scenario: Natural language address update
    Given I say "Add my home address 123 Main St, San Francisco, CA 94105"
    When I say "I moved to a new place at 456 Oak Ave in the same city"
    Then response has 2 messages
    And first message content contains "Updating"

  @test_address_validation_edge_cases
  Scenario: Handle edge cases in address validation
    When I say "Add my home address at Main Street in California"
    Then response has 1 message
    And first message content contains "Missing Required Fields"

  @test_multiple_operations_sequence
  Scenario: Sequence of multiple address operations
    Given I say "Add my home address 123 Main St, San Francisco, CA 94105"
    And I say "Add my work address 456 Business Ave, New York, NY 10001"
    When I say "show my addresses"
    Then response has 1 message
    And first message has type empty

  @test_case_insensitive_operations
  Scenario: Case insensitive address operations
    When I say "ADD MY HOME ADDRESS 123 MAIN ST, SAN FRANCISCO, CA 94105"
    Then response has 2 messages
    And first message content contains "Adding home address"

  @test_special_characters_in_address
  Scenario: Handle special characters in addresses
    When I say "Add my home address 123 Main St. #4B, San Francisco, CA 94105"
    Then response has 2 messages
    And first message content contains "Adding home address"

  @test_error_handling_invalid_action
  Scenario: Handle invalid action gracefully
    When I say "remove my address completely"
    Then response has 1 message
    # Should either handle as delete or ask for clarification

  @test_context_preservation
  Scenario: Context preservation across operations
    Given I say "Add my home address 123 Main St, San Francisco, CA 94105"
    When I say "now update the city to Oakland"
    Then response has 2 messages
    And first message content contains "Updating"

  @test_address_format_consistency
  Scenario: Consistent address format display
    When I say "show my addresses"
    Then response has 1 message
    And first message has type text
    And first message content contains "addresses"

  @test_operation_confirmation
  Scenario: Operation confirmation messages
    When I say "Add my home address 123 Main St, San Francisco, CA 94105"
    Then response has 2 messages
    And second message content contains "successfully"
    And second message content contains "may take a few seconds"

  @test_comprehensive_address_management
  Scenario: Comprehensive address management workflow
    Given I say "Add my home address 123 Main St, San Francisco, CA 94105"
    And I say "Add my work address 456 Business Ave, New York, NY 10001"
    And I say "Update my home address city to Oakland"
    When I say "Delete my work address"
    Then response has 2 messages
    And second message content contains "Address Deleted Successfully"
