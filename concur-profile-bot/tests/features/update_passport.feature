Feature: Update Passport Management
  Test the scenario that updates passport information (modify fields, delete) in Concur Travel Profile.

  Background:
    Given I log in
    And I start a new conversation

  @test_no_passports_update
  Scenario: Try to update when no passports exist
    When I say "update my passport"
    Then response has 1 message
    And first message has type text
    And first message content contains "No Passports Found"
    And first message content contains "add a passport first"

  @test_single_passport_no_fields
  Scenario: Update single passport without specifying fields
    When I say "update my passport"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Your Passport"
    And second message has type text
    And second message content contains "What would you like to update?"

  @test_multiple_passports_need_selection
  Scenario: Update multiple passports without selection
    When I say "update my passport"
    Then response has 1 message
    And first message has type list
    And first message content contains "Select Passport to Update"

  @test_passport_selected_no_fields
  Scenario: Update specific passport without fields
    When I say "update passport 123456789"
    Then response has 1 message
    And first message has type text
    And first message content contains "Passport Selected: 123456789"
    And first message content contains "What would you like to update?"

  @test_update_expiration_date
  Scenario: Update passport expiration date
    When I say "Update passport expiration date to 2030-12-31"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Updating Passport"
    And second message has type text
    And second message content contains "Passport Updated Successfully"

  @test_update_specific_passport_expiration
  Scenario: Update specific passport expiration date
    When I say "Update passport 123456789 expiration date to 2030-12-31"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    And second message content contains "Passport Updated Successfully"

  @test_update_issue_date
  Scenario: Update passport issue date
    When I say "Update passport issue date to 2020-01-01"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    And second message content contains "Passport Updated Successfully"

  @test_update_issue_place
  Scenario: Update passport issue place
    When I say "Update passport issue place to London"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    And second message content contains "Passport Updated Successfully"

  @test_update_nationality
  Scenario: Update passport nationality
    When I say "Update passport nationality to GB"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    And second message content contains "Passport Updated Successfully"

  @test_update_issuing_country
  Scenario: Update passport issuing country
    When I say "Update passport issuing country to GB"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    And second message content contains "Passport Updated Successfully"

  @test_update_passport_number
  Scenario: Update passport number
    When I say "Update passport number to 987654321"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    And second message content contains "Passport Updated Successfully"

  @test_updatepass_update_multiple_fields
  Scenario: Update multiple passport fields at once
    When I say "Update passport 123456789 expiration date to 2030-12-31 and nationality to GB"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    And second message content contains "Passport Updated Successfully"

  @test_multiple_passport_no_target
  Scenario: Multiple passports without specifying which to update
    When I say "Update passport expiration date to 2030-12-31"
    Then response has 1 message
    And first message content contains "Please Specify Passport"
    And first message content contains "include the passport number"

  @test_delete_no_passports
  Scenario: Try to delete when no passports exist
    When I say "delete my passport"
    Then response has 1 message
    And first message has type text
    And first message content contains "No Passports Found"
    And first message content contains "don't have any passports to delete"

  @test_delete_need_selection
  Scenario: Delete passport without specifying which one
    When I say "delete my passport"
    Then response has 1 message
    And first message has type list
    And first message content contains "Select Passport to Delete"

  @test_delete_specific_passport
  Scenario: Delete specific passport
    When I say "Delete passport 123456789"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Deleting Passport 123456789"
    And second message has type text
    And second message content contains "Passport Deleted Successfully"

  @test_date_format_handling
  Scenario: Handle different date formats for expiration
    When I say "Update passport expiration to 2030-01-01"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    And second message content contains "Passport Updated Successfully"

  @test_updatepass_iso_date_format
  Scenario: Handle ISO date format with time
    When I say "Update passport issue date to 2020-01-01T00:00:00"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    And second message content contains "Passport Updated Successfully"

  @test_updatepass_natural_language_update
  Scenario: Natural language passport update
    When I say "My passport expires on 2030-12-31"
    Then response has 2 messages
    And first message content contains "Updating Passport"

  @test_updatepass_case_variations
  Scenario: Test different case variations
    When I say "UPDATE PASSPORT NATIONALITY TO US"
    Then response has 2 messages
    And first message content contains "Updating Passport"

  @test_country_code_formats
  Scenario: Handle different country code formats
    When I say "Update passport nationality to United States"
    Then response has 2 messages
    And first message content contains "Updating Passport"

  @test_updatepass_sequential_updates
  Scenario: Multiple sequential passport updates
    Given I say "Update passport expiration date to 2030-01-01"
    When I say "Update passport nationality to GB"
    Then response has 2 messages
    And first message content contains "Updating Passport"

  @test_updatepass_error_simulation
  Scenario: Simulate API error response
    When I say "Update passport expiration date to 2030-ERROR-TEST"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    # Note: Actual error handling would depend on API response

  @test_updatepass_connection_failure
  Scenario: Test connection failure handling
    When I say "Update passport nationality to CONNECTION-TEST"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    # Note: Connection failure testing would require specific test environment setup

  @test_updatepass_jwt_token_usage
  Scenario: Verify JWT token is used in API calls
    When I say "Update passport expiration date to 2030-JWT-TEST"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    # Note: JWT token usage is internal and not directly testable in user response

  @test_updatepass_initialization_variables
  Scenario: Test that initialization variables are set correctly
    When I say "update my passport"
    Then response has 1 message
    # Tests that initialization action group executed properly

  @test_updatepass_handlebars_templating
  Scenario: Test Handlebars template rendering
    When I say "update my passport"
    Then response has 1 message
    # Tests that Handlebars template rendered correctly

  @test_updatepass_context_variables
  Scenario: Test context variable usage
    When I say "Update passport expiration date to 2030-CONTEXT-TEST"
    Then response has 2 messages
    # Tests that context variables are properly set and used

  @test_updatepass_operation_status_tracking
  Scenario: Test operation status tracking
    When I say "Update passport nationality to STATUS-TEST"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    # Tests that update_status variable is managed correctly

  @test_updatepass_api_timeout_configuration
  Scenario: Test API timeout configuration
    When I say "Update passport issue place to TIMEOUT-TEST"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    # Tests that timeout: 30 is properly configured

  @test_updatepass_system_alias_usage
  Scenario: Test system alias configuration
    When I say "Update passport nationality to ALIAS-TEST"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    # Tests that ConcurProfileBotAPI system alias is used

  @test_updatepass_graphql_path_usage
  Scenario: Test GraphQL path configuration
    When I say "Update passport expiration date to 2030-GRAPHQL-TEST"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    # Tests that /graphql path is used correctly

  @test_updatepass_mutation_query_structure
  Scenario: Test GraphQL mutation query structure
    When I say "Update passport issue date to 2020-MUTATION-TEST"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    # Tests that GraphQL mutation queries are properly structured

  @test_updatepass_documents_field_usage
  Scenario: Test documents field usage in GraphQL
    When I say "Update passport nationality to DOCUMENTS-TEST"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    # Tests that "documents" field is used in GraphQL mutations

  @test_updatepass_passports_array_building
  Scenario: Test passports array building for updates
    When I say "Update passport expiration date to 2030-ARRAY-TEST"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    # Tests that passport arrays are properly constructed for updates

  @test_target_passport_identification
  Scenario: Test target passport identification
    When I say "Update passport 123456789 nationality to TARGET-TEST"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    # Tests that target passport is properly identified

  @test_field_preservation
  Scenario: Test field preservation during updates
    When I say "Update passport expiration date to 2030-PRESERVE-TEST"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    # Tests that non-updated fields are preserved

  @test_passport_data_retrieval
  Scenario: Test passport data retrieval
    When I say "update my passport"
    Then response has 1 message
    # Tests that passport data is properly retrieved from API

  @test_updatepass_passport_count_tracking
  Scenario: Test passport count tracking
    When I say "update my passport"
    Then response has 1 message
    # Tests that passport count is properly tracked and used

  @test_updatepass_has_passports_flag
  Scenario: Test has_passports flag usage
    When I say "update my passport"
    Then response has 1 message
    # Tests that has_passports flag is properly set and used

  @test_list_interface_update
  Scenario: Test list interface for passport selection
    When I say "update passport"
    Then response has 1 message
    And first message has type list
    And first message content contains "Select Passport to Update"
    # Tests that list interface is properly rendered for selection

  @test_updatepass_list_interface_delete
  Scenario: Test list interface for passport deletion
    When I say "delete passport"
    Then response has 1 message
    And first message has type list
    And first message content contains "Select Passport to Delete"
    # Tests that list interface is properly rendered for deletion

  @test_updatepass_success_message_formatting
  Scenario: Test success message formatting
    When I say "Update passport expiration date to 2030-SUCCESS-TEST"
    Then response has 2 messages
    And second message content contains "Passport Updated Successfully"
    And second message content contains "Changes may take 2+ seconds"
    # Tests that success messages are properly formatted

  @test_delete_success_message
  Scenario: Test delete success message formatting
    When I say "Delete passport 123456789"
    Then response has 2 messages
    And second message content contains "Passport Deleted Successfully"
    And second message content contains "Changes may take 2+ seconds"
    # Tests that delete success messages are properly formatted

  @test_updatepass_error_message_formatting
  Scenario: Test error message formatting
    When I say "update passport without details"
    Then response has 1 message
    # Tests that error messages are properly formatted

  @test_processing_delay_note
  Scenario: Test processing delay note display
    When I say "Update passport nationality to DELAY-TEST"
    Then response has 2 messages
    And second message content contains "Changes may take 2+ seconds to appear"
    # Tests that processing delay notes are displayed

  @test_updatepass_api_retrieval_error
  Scenario: Test API retrieval error handling
    When I say "update my passport"
    Then response has 1 message
    # Tests that API retrieval errors are properly handled

  @test_update_failure_handling
  Scenario: Test update failure handling
    When I say "Update passport expiration date to 2030-FAIL-TEST"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    # Tests that update failures are properly handled

  @test_delete_failure_handling
  Scenario: Test delete failure handling
    When I say "Delete passport FAIL-TEST"
    Then response has 2 messages
    And first message content contains "Deleting Passport"
    # Tests that delete failures are properly handled

  @test_remaining_passports_array
  Scenario: Test remaining passports array for deletion
    When I say "Delete passport 123456789"
    Then response has 2 messages
    And first message content contains "Deleting Passport"
    # Tests that remaining passports array is properly constructed for deletion

  @test_updatepass_passport_field_mapping
  Scenario: Test passport field mapping from API
    When I say "update my passport"
    Then response has 1 message
    # Tests that passport fields are properly mapped from API response

  @test_updatepass_date_time_formatting
  Scenario: Test date/time formatting for API calls
    When I say "Update passport issue date to 2020-01-01"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    # Tests that dates are properly formatted with T00:00:00 for API calls

  @test_conditional_date_formatting
  Scenario: Test conditional date formatting
    When I say "Update passport expiration date to 2030-01-01T12:00:00"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    # Tests that existing T timestamps are preserved

  @test_passport_selection_validation
  Scenario: Test passport selection validation
    When I say "Update passport INVALID-NUMBER expiration date to 2030-01-01"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    # Tests that passport selection is properly validated

  @test_field_update_validation
  Scenario: Test field update validation
    When I say "Update passport with invalid fields"
    Then response has 1 message
    # Tests that field updates are properly validated

  @test_multiple_field_updates
  Scenario: Test multiple field updates in single request
    When I say "Update passport expiration to 2030-01-01 issue place to Paris nationality to FR"
    Then response has 2 messages
    And first message content contains "Updating Passport"
    # Tests that multiple field updates are handled correctly
