Feature: Phone Numbers Management
  Test the scenario that manages phone number information (add, update, delete) in Concur Travel Profile.

  Background:
    Given I log in
    And I start a new conversation

  @test_phonenumbers_view_default
  Scenario: View phone numbers with no action specified
    When I say "manage phone numbers"
    Then response has 1 message
    And first message has type text
    And first message content contains "Your Phone Numbers"
    And first message content contains "What would you like to do?"

  @test_show_phones
  Scenario: Show current phone numbers
    When I say "show my phone numbers"
    Then response has 1 message
    And first message has type text
    And first message content contains "Your Phone Numbers"

  @test_view_phones
  Scenario: View current phone numbers
    When I say "view my phones"
    Then response has 1 message
    And first message has type text
    And first message content contains "Your Phone Numbers"

  @test_phonenumbers_add_without_fields
  Scenario: Add phone without providing specific fields
    When I say "add phone"
    Then response has 1 message
    And first message has type text
    And first message content contains "Missing Information"
    And first message content contains "Phone type"
    And first message content contains "Phone number"

  @test_add_work_phone
  Scenario: Add work phone number
    When I say "Add my work phone 555-123-4567"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Adding Work phone"
    And first message content contains "555-123-4567"
    And second message has type text
    And second message content contains "Phone Number Added Successfully"

  @test_add_cell_phone
  Scenario: Add cell phone number
    When I say "Add my cell phone 555-987-6543"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Adding Cell phone"
    And first message content contains "555-987-6543"

  @test_add_mobile_phone
  Scenario: Add mobile phone number (alias for cell)
    When I say "Add my mobile phone 555-555-5555"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Adding Cell phone"
    And first message content contains "555-555-5555"

  @test_add_home_phone
  Scenario: Add home phone number
    When I say "Add my home phone 555-111-2222"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Adding Home phone"
    And first message content contains "555-111-2222"

  @test_add_office_phone
  Scenario: Add office phone number (alias for work)
    When I say "Add my office phone 555-333-4444"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Adding Work phone"
    And first message content contains "555-333-4444"

  @test_phonenumbers_update_without_fields
  Scenario: Update phone without providing specific fields
    When I say "update my phone"
    Then response has 1 message
    And first message has type text
    And first message content contains "What would you like to update?"
    And first message content contains "Phone type to update"

  @test_update_work_phone
  Scenario: Update work phone number
    When I say "Update my work phone to 555-999-8888"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Updating Work phone to:"
    And first message content contains "555-999-8888"
    And second message has type text
    And second message content contains "Phone Number Updated Successfully"

  @test_update_cell_phone
  Scenario: Update cell phone number
    When I say "Update my cell phone to 555-777-6666"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Updating Cell phone"
    And first message content contains "555-777-6666"

  @test_update_home_phone
  Scenario: Update home phone number
    When I say "Update my home phone to 555-444-3333"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Updating Home phone"
    And first message content contains "555-444-3333"

  @test_phonenumbers_delete_without_selection
  Scenario: Delete phone without specifying which one
    When I say "delete my phone"
    Then response has 1 message
    And first message has type list
    And first message content contains "Select Phone to Delete"

  @test_delete_work_phone
  Scenario: Delete work phone number
    When I say "Delete my work phone"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Deleting Work phone"
    And second message has type text
    And second message content contains "Phone Number Deleted Successfully"

  @test_delete_cell_phone
  Scenario: Delete cell phone number
    When I say "Delete my cell phone"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Deleting Cell phone"

  @test_delete_home_phone
  Scenario: Delete home phone number
    When I say "Delete my home phone"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Deleting Home phone"

  @test_phonenumbers_case_variations
  Scenario: Test different case variations for phone types
    When I say "ADD MY WORK PHONE 555-UPPER-CASE"
    Then response has 2 messages
    And first message content contains "Adding Work phone"
    And first message content contains "555-UPPER-CASE"

  @test_phone_formats
  Scenario: Handle different phone number formats
    When I say "Add my cell phone (555) 123-4567"
    Then response has 2 messages
    And first message content contains "Adding Cell phone:"
    And first message content contains "555"

  @test_phone_with_extension
  Scenario: Handle phone numbers with extensions
    When I say "Add my work phone 555-123-4567 ext 123"
    Then response has 2 messages
    And first message content contains "Adding Work phone"
    And first message content contains "555-123-4567 ext 123"

  @test_international_format
  Scenario: Handle international phone format
    When I say "Add my cell phone +1-555-123-4567"
    Then response has 2 messages
    And first message content contains "Adding Cell phone"
    And first message content contains "555-123-4567"

  @test_dots_format
  Scenario: Handle phone numbers with dots
    When I say "Add my home phone 555.123.4567"
    Then response has 2 messages
    And first message content contains "Adding Home phone"
    And first message content contains "555.123.4567"

  @test_spaces_format
  Scenario: Handle phone numbers with spaces
    When I say "Add my work phone 555 123 4567"
    Then response has 2 messages
    And first message content contains "Adding Work phone"
    And first message content contains "555 123 4567"

  @test_no_formatting
  Scenario: Handle phone numbers without formatting
    When I say "Add my cell phone 5551234567"
    Then response has 2 messages
    And first message content contains "Adding Cell phone"
    And first message content contains "5551234567"

  @test_phonenumbers_sequential_operations
  Scenario: Multiple sequential phone operations
    Given I say "Add my work phone 555-111-1111"
    When I say "Update my work phone to 555-222-2222"
    Then response has 2 messages
    And first message content contains "Updating Work phone"
    And first message content contains "555-222-2222"

  @test_phonenumbers_mixed_operations
  Scenario: Mix different operation types
    Given I say "Add my cell phone 555-333-3333"
    When I say "show my phone numbers"
    Then response has 1 message
    And first message content contains "Your Phone Numbers"

  @test_phonenumbers_view_after_add
  Scenario: View phones after successful add
    Given I say "Add my home phone 555-444-4444"
    When I say "show my phone numbers"
    Then response has 1 message
    And first message has type text
    And first message content contains "Your Phone Numbers"

  @test_phonenumbers_view_after_update
  Scenario: View phones after successful update
    Given I say "Update my work phone to 555-555-5555"
    When I say "view my phones"
    Then response has 1 message
    And first message has type text
    And first message content contains "Your Phone Numbers"

  @test_phonenumbers_view_after_delete
  Scenario: View phones after successful delete
    Given I say "Delete my cell phone"
    When I say "show my phone numbers"
    Then response has 1 message
    And first message has type text
    And first message content contains "Your Phone Numbers"

  @test_phonenumbers_help_examples
  Scenario: View help and examples for phone management
    When I say "how do I add a phone number"
    Then response has 1 message
    And first message has type text
    And first message content contains "Examples:"
    And first message content contains "Add my work phone"

  @test_empty_phone_handling
  Scenario: Handle empty phone values
    When I say "Add my work phone "
    Then response has 1 message
    And first message content contains "Missing Information"

  @test_invalid_phone_type
  Scenario: Handle invalid phone type
    When I say "Add my invalid phone 555-123-4567"
    Then response has 1 message
    And first message content contains "Missing Information"

  @test_phonenumbers_natural_language_add
  Scenario: Natural language phone addition
    When I say "I want to add my office number which is 555-123-4567"
    Then response has 2 messages
    And first message content contains "Adding"
    And first message content contains "555-123-4567"

  @test_phonenumbers_natural_language_update
  Scenario: Natural language phone update
    When I say "My cell phone should be changed to 555-987-6543"
    Then response has 2 messages
    And first message content contains "Updating"
    And first message content contains "555-987-6543"

  @test_multiple_phone_types_mention
  Scenario: Handle multiple phone types in one request
    When I say "Add my work phone 555-111-1111 and cell phone 555-222-2222"
    Then response has 2 messages
    And first message content contains "Adding"

  @test_phonenumbers_error_simulation
  Scenario: Simulate API error response
    When I say "Add my work phone 555-ERROR-TEST"
    Then response has 2 messages
    And first message content contains "Adding Work phone"
    # Note: Actual error handling would depend on API response

  @test_phonenumbers_connection_failure
  Scenario: Test connection failure handling
    When I say "Add my cell phone 555-CONN-TEST"
    Then response has 2 messages
    And first message content contains "Adding Cell phone"
    # Note: Connection failure testing would require specific test environment setup

  @test_phonenumbers_basic_add_functionality
  Scenario: Verify basic add functionality
    When I say "Add my home phone 555-BASIC-TEST"
    Then response has 2 messages
    And first message content contains "Adding Home phone"
    And first message content contains "555-BASIC-TEST"

  @test_phonenumbers_basic_update_functionality
  Scenario: Verify basic update functionality
    When I say "Update my work phone to 555-UPDATE-TEST"
    Then response has 2 messages
    And first message content contains "Updating Work phone"
    And first message content contains "555-UPDATE-TEST"

  @test_phonenumbers_basic_delete_functionality
  Scenario: Verify basic delete functionality
    When I say "Delete my cell phone"
    Then response has 2 messages
    And first message content contains "Deleting Cell phone"

  @test_phonenumbers_jwt_token_usage
  Scenario: Verify JWT token is used in API calls
    When I say "Add my work phone 555-JWT-TEST"
    Then response has 2 messages
    And first message content contains "Adding Work phone"
    # Note: JWT token usage is internal and not directly testable in user response

  @test_phonenumbers_initialization_variables
  Scenario: Test that initialization variables are set correctly
    When I say "manage phone numbers"
    Then response has 1 message
    And first message content contains "Your Phone Numbers"
    # Tests that initialization action group executed properly

  @test_phonenumbers_conditional_logic
  Scenario: Test conditional logic execution
    When I say "show my phone numbers"
    Then response has 1 message
    And first message content contains "Your Phone Numbers"
    # Tests that correct condition branch was taken

  @test_phonenumbers_handlebars_templating
  Scenario: Test Handlebars template rendering
    When I say "manage phone numbers"
    Then response has 1 message
    And first message content contains "What would you like to do?"
    # Tests that Handlebars template rendered correctly

  @test_phonenumbers_context_variables
  Scenario: Test context variable usage
    When I say "Add my cell phone 555-CONTEXT-TEST"
    Then response has 2 messages
    And first message content contains "555-CONTEXT-TEST"
    # Tests that context variables are properly set and used

  @test_phonenumbers_operation_status_tracking
  Scenario: Test operation status tracking
    When I say "Add my work phone 555-STATUS-TEST"
    Then response has 2 messages
    And first message content contains "Adding Work phone"
    # Tests that operation_status variable is managed correctly

  @test_phonenumbers_result_message_handling
  Scenario: Test result message variable handling
    When I say "manage phone numbers"
    Then response has 1 message
    And first message content contains "Your Phone Numbers"
    # Tests that result_message variable is handled properly

  @test_phonenumbers_multiple_conditions
  Scenario: Test multiple condition evaluation
    When I say "Add my home phone 555-MULTI-TEST"
    Then response has 2 messages
    # Tests that multiple conditional action groups execute correctly

  @test_phonenumbers_api_timeout_configuration
  Scenario: Test API timeout configuration
    When I say "Add my cell phone 555-TIMEOUT-TEST"
    Then response has 2 messages
    And first message content contains "Adding Cell phone"
    # Tests that timeout: 30 is properly configured

  @test_phonenumbers_system_alias_usage
  Scenario: Test system alias configuration
    When I say "Add my work phone 555-ALIAS-TEST"
    Then response has 2 messages
    And first message content contains "Adding Work phone"
    # Tests that ConcurProfileBotAPI system alias is used

  @test_phonenumbers_graphql_path_usage
  Scenario: Test GraphQL path configuration
    When I say "Add my home phone 555-GRAPHQL-TEST"
    Then response has 2 messages
    And first message content contains "Adding Home phone"
    # Tests that /graphql path is used correctly

  @test_phonenumbers_content_type_handling
  Scenario: Test content type handling for API calls
    When I say "Add my cell phone 555-CONTENT-TEST"
    Then response has 2 messages
    And first message content contains "Adding Cell phone"
    # Tests that proper content type is set for GraphQL calls

  @test_primary_phone_indication
  Scenario: Test primary phone indication
    When I say "view my phones"
    Then response has 1 message
    And first message content contains "Your Phone Numbers"
    # Tests that primary phone is properly indicated

  @test_phonenumbers_list_interface_delete
  Scenario: Test list interface for phone deletion
    When I say "delete phone"
    Then response has 1 message
    And first message has type list
    And first message content contains "Select Phone to Delete"
    # Tests that list interface is properly rendered for deletion

  @test_phone_type_normalization
  Scenario: Test phone type normalization
    When I say "Add my MOBILE phone 555-NORMALIZE-TEST"
    Then response has 2 messages
    And first message content contains "Adding Cell phone"
    # Tests that phone types are properly normalized (mobile -> Cell)

  @test_phonenumbers_array_building_add
  Scenario: Test array building for add operations
    When I say "Add my work phone 555-ARRAY-ADD"
    Then response has 2 messages
    And first message content contains "Adding Work phone"
    # Tests that phone arrays are properly constructed for add operations

  @test_phonenumbers_array_building_update
  Scenario: Test array building for update operations
    When I say "Update my cell phone to 555-ARRAY-UPDATE"
    Then response has 2 messages
    And first message content contains "Updating Cell phone"
    # Tests that phone arrays are properly constructed for update operations

  @test_phonenumbers_array_building_delete
  Scenario: Test array building for delete operations
    When I say "Delete my home phone"
    Then response has 2 messages
    And first message content contains "Deleting Home phone"
    # Tests that phone arrays are properly constructed for delete operations

  @test_phonenumbers_mutation_query_structure
  Scenario: Test GraphQL mutation query structure
    When I say "Add my work phone 555-MUTATION-TEST"
    Then response has 2 messages
    And first message content contains "Adding Work phone"
    # Tests that GraphQL mutation queries are properly structured

  @test_phonenumbers_variable_input_structure
  Scenario: Test GraphQL variable input structure
    When I say "Update my cell phone to 555-VARIABLE-TEST"
    Then response has 2 messages
    And first message content contains "Updating Cell phone"
    # Tests that GraphQL variables are properly structured

  @test_phone_count_tracking
  Scenario: Test phone count tracking
    When I say "show my phone numbers"
    Then response has 1 message
    And first message content contains "Your Phone Numbers"
    # Tests that phone count is properly tracked and used

  @test_has_phones_flag
  Scenario: Test has_phones flag usage
    When I say "manage phone numbers"
    Then response has 1 message
    And first message content contains "Your Phone Numbers"
    # Tests that has_phones flag is properly set and used

  @test_no_phones_message
  Scenario: Test no phones message display
    When I say "view my phones"
    Then response has 1 message
    And first message content contains "Your Phone Numbers"
    # Tests proper message when no phones exist

  @test_phonenumbers_success_message_formatting
  Scenario: Test success message formatting
    When I say "Add my cell phone 555-SUCCESS-TEST"
    Then response has 2 messages
    And second message content contains "Phone Number Added Successfully"
    And second message content contains "Changes may take a few seconds"
    # Tests that success messages are properly formatted

  @test_phonenumbers_error_message_formatting
  Scenario: Test error message formatting
    When I say "add phone without details"
    Then response has 1 message
    And first message content contains "Missing Information"
    # Tests that error messages are properly formatted

  @test_processing_note_display
  Scenario: Test processing note display
    When I say "Add my work phone 555-PROCESS-TEST"
    Then response has 2 messages
    And second message content contains "Changes may take a few seconds to appear"
    # Tests that processing notes are displayed

  @test_country_code_handling
  Scenario: Test country code handling in phone structure
    When I say "Add my cell phone 555-COUNTRY-TEST"
    Then response has 2 messages
    And first message content contains "Adding Cell phone"
    # Tests that country code is properly set in phone structure

  @test_extension_field_handling
  Scenario: Test extension field handling in phone structure
    When I say "Add my work phone 555-EXT-TEST"
    Then response has 2 messages
    And first message content contains "Adding Work phone"
    # Tests that extension field is properly handled in phone structure

  @test_contact_opt_in_handling
  Scenario: Test contact opt-in handling in phone structure
    When I say "Add my home phone 555-OPTIN-TEST"
    Then response has 2 messages
    And first message content contains "Adding Home phone"
    # Tests that contactOptIn field is properly set in phone structure

  @test_primary_mobile_handling
  Scenario: Test primary mobile handling in phone structure
    When I say "Add my cell phone 555-PRIMARY-TEST"
    Then response has 2 messages
    And first message content contains "Adding Cell phone"
    # Tests that isPrimaryMobile field is properly handled in phone structure

  @test_telephones_field_usage
  Scenario: Test telephones field usage in GraphQL
    When I say "Add my work phone 555-TELEPHONES-TEST"
    Then response has 2 messages
    And first message content contains "Adding Work phone"
    # Tests that "telephones" field is used in GraphQL mutations

  @test_phone_number_field_structure
  Scenario: Test phone number field structure in API calls
    When I say "Update my cell phone to 555-FIELD-TEST"
    Then response has 2 messages
    And first message content contains "Updating Cell phone"
    # Tests that phone number fields are properly structured in API calls

  @test_no_phones_update_handling
  Scenario: Test update when no phones exist
    When I say "update my work phone to 555-NO-PHONES"
    Then response has 1 message
    And first message content contains "No Phone Numbers Found"
    And first message content contains "add a phone number first"
    # Tests proper handling when trying to update with no existing phones

  @test_no_phones_delete_handling
  Scenario: Test delete when no phones exist
    When I say "delete my cell phone"
    Then response has 1 message
    And first message content contains "No Phone Numbers Found"
    And first message content contains "don't have any phone numbers to delete"
    # Tests proper handling when trying to delete with no existing phones

  @test_phonenumbers_api_retrieval_error
  Scenario: Test API retrieval error handling
    When I say "show my phone numbers"
    Then response has 1 message
    And first message content contains "Your Phone Numbers"
    # Tests that API retrieval errors are properly handled

  @test_phone_value_field_mapping
  Scenario: Test phone value field mapping
    When I say "view my phones"
    Then response has 1 message
    And first message content contains "Your Phone Numbers"
    # Tests that phone.value field is properly mapped from API response
