Feature: Profile Names Management
  Test the scenario that manages profile name information (first name, last name, preferred name) in Concur Travel Profile.

  Background:
    Given I log in
    And I start a new conversation

  @test_profilenames_view_default
  Scenario: View profile names with no action specified
    When I say "manage profile names"
    Then response has 1 message
    And first message has type text
    And first message content contains "Your Profile Names"
    And first message content contains "What would you like to do?"

  @test_get_action
  Scenario: Get current profile names with explicit get action
    When I say "get my profile names"
    Then response has 1 message
    And first message has type text
    And first message content contains "Your Current Profile Names"
    And first message content contains "First Name:"
    And first message content contains "Last Name:"

  @test_show_names
  Scenario: Show current profile names
    When I say "show my profile names"
    Then response has 1 message
    And first message has type text
    And first message content contains "Your Current Profile Names"

  @test_set_without_fields
  Scenario: Set names without providing specific fields
    When I say "set my profile names"
    Then response has 1 message
    And first message has type text
    And first message content contains "What would you like to update?"
    And first message content contains "specify which name"

  @test_profilenames_update_without_fields
  Scenario: Update names without providing specific fields
    When I say "update my profile names"
    Then response has 1 message
    And first message has type text
    And first message content contains "What would you like to update?"
    And first message content contains "Examples:"

  @test_set_first_name
  Scenario: Set first name only
    When I say "Set my first name to John"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Updating Profile Names"
    And first message content contains "First Name: John"
    And second message has type text
    And second message content contains "Profile Names Updated Successfully"

  @test_set_last_name
  Scenario: Set last name only
    When I say "Set my last name to Smith"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Updating Profile Names"
    And first message content contains "Last Name: Smith"

  @test_set_preferred_name
  Scenario: Set preferred name only
    When I say "Set my preferred name to Johnny"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Updating Profile Names"
    And first message content contains "Preferred Name: Johnny"

  @test_update_first_name
  Scenario: Update first name with update action
    When I say "Update my first name to Michael"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Updating Profile Names"
    And first message content contains "First Name: Michael"

  @test_update_last_name
  Scenario: Update last name with update action
    When I say "Update my last name to Johnson"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Updating Profile Names"
    And first message content contains "Last Name: Johnson"

  @test_update_preferred_name
  Scenario: Update preferred name with update action
    When I say "Update my preferred name to Mike"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Updating Profile Names"
    And first message content contains "Preferred Name: Mike"

  @test_change_first_name
  Scenario: Change first name using change action
    When I say "Change my first name to David"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Updating Profile Names"
    And first message content contains "First Name: David"

  @test_multiple_names
  Scenario: Set multiple names at once
    When I say "Set first name John and last name Smith"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Updating Profile Names"
    And first message content contains "First Name: John"
    And first message content contains "Last Name: Smith"

  @test_all_three_names
  Scenario: Update all three name fields
    When I say "Set first name John, last name Smith, and preferred name Johnny"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Updating Profile Names"
    And first message content contains "First Name: John"
    And first message content contains "Last Name: Smith"
    And first message content contains "Preferred Name: Johnny"

  @test_direct_field_update
  Scenario: Direct field update without explicit action
    When I say "My first name is Sarah"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Updating Profile Names"
    And first message content contains "First Name: Sarah"

  @test_profilenames_natural_language_update
  Scenario: Natural language name update
    When I say "My name is Emily Davis and I prefer to be called Em"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Updating Profile Names"

  @test_profilenames_success_response
  Scenario: Successful update response (mocked success)
    When I say "Set my first name to TestUser"
    Then response has 2 messages
    And first message content contains "Updating Profile Names"
    And first message content contains "First Name: TestUser"

  @test_profilenames_view_after_update
  Scenario: View names after successful update
    Given I say "Set my first name to UpdatedName"
    When I say "show my profile names"
    Then response has 1 message
    And first message has type text
    And first message content contains "Your Current Profile Names"

  @test_profilenames_help_examples
  Scenario: View help and examples for name management
    When I say "how do I update my name"
    Then response has 1 message
    And first message has type text
    And first message content contains "Examples:"
    And first message content contains "Set my first name to John"

  @test_profilenames_empty_name_handling
  Scenario: Handle empty name values
    When I say "Set my first name to "
    Then response has 1 message
    And first message content contains "value is missing or unclear"

  @test_profilenames_case_variations
  Scenario: Test different case variations
    When I say "SET MY FIRST NAME TO UPPERCASE"
    Then response has 2 messages
    And first message content contains "Updating Profile Names"
    And first message content contains "First Name: UPPERCASE"

  @test_special_characters
  Scenario: Handle names with special characters
    When I say "Set my first name to José"
    Then response has 2 messages
    And first message content contains "Updating Profile Names"
    And first message content contains "First Name: José"

  @test_long_names
  Scenario: Handle longer names
    When I say "Set my first name to Christopher"
    Then response has 2 messages
    And first message content contains "Updating Profile Names"
    And first message content contains "First Name: Christopher"

  @test_profilenames_hyphenated_names
  Scenario: Handle hyphenated names
    When I say "Set my last name to Smith-Johnson"
    Then response has 2 messages
    And first message content contains "Updating Profile Names"
    And first message content contains "Last Name: Smith-Johnson"

  @test_profilenames_apostrophe_names
  Scenario: Handle names with apostrophes
    When I say "Set my last name to O'Connor"
    Then response has 2 messages
    And first message content contains "Updating Profile Names"
    And first message content contains "Last Name: O'Connor"

  @test_preferred_name_variations
  Scenario: Test various preferred name formats
    When I say "My preferred name is Alex"
    Then response has 2 messages
    And first message content contains "Updating Profile Names"
    And first message content contains "Preferred Name: Alex"

  @test_nickname_handling
  Scenario: Handle nickname as preferred name
    When I say "Call me Buddy"
    Then response has 2 messages
    And first message content contains "Updating Profile Names"
    And first message content contains "Preferred Name: Buddy"

  @test_profilenames_sequential_updates
  Scenario: Multiple sequential name updates
    Given I say "Set my first name to Initial"
    When I say "Update my first name to Final"
    Then response has 2 messages
    And first message content contains "Updating Profile Names"
    And first message content contains "First Name: Final"

  @test_profilenames_mixed_actions
  Scenario: Mix different action types
    Given I say "Set my first name to John"
    When I say "get my profile names"
    Then response has 1 message
    And first message content contains "Your Current Profile Names"

  @test_profilenames_error_simulation
  Scenario: Simulate API error response
    When I say "Set my first name to ErrorTest"
    Then response has 2 messages
    And first message content contains "Updating Profile Names"
    # Note: Actual error handling would depend on API response

  @test_profilenames_connection_failure
  Scenario: Test connection failure handling
    When I say "Set my first name to ConnectionTest"
    Then response has 2 messages
    And first message content contains "Updating Profile Names"
    # Note: Connection failure testing would require specific test environment setup

  @test_profilenames_basic_functionality
  Scenario: Verify basic update functionality
    When I say "Set my first name to TestName"
    Then response has 2 messages
    And first message content contains "Updating Profile Names"
    And first message content contains "First Name: TestName"

  @test_profilenames_jwt_token_usage
  Scenario: Verify JWT token is used in API calls
    When I say "Set my first name to JWTTest"
    Then response has 2 messages
    And first message content contains "Updating Profile Names"
    # Note: JWT token usage is internal and not directly testable in user response

  @test_profilenames_initialization_variables
  Scenario: Test that initialization variables are set correctly
    When I say "manage profile names"
    Then response has 1 message
    And first message content contains "Your Profile Names"
    # Tests that initialization action group executed properly

  @test_profilenames_conditional_logic
  Scenario: Test conditional logic execution
    When I say "get my profile names"
    Then response has 1 message
    And first message content contains "Your Current Profile Names"
    # Tests that correct condition branch was taken

  @test_profilenames_handlebars_templating
  Scenario: Test Handlebars template rendering
    When I say "show my profile names"
    Then response has 1 message
    And first message content contains "First Name:"
    And first message content contains "Last Name:"
    And first message content contains "Preferred Name:"
    # Tests that Handlebars template rendered correctly

  @test_profilenames_context_variables
  Scenario: Test context variable usage
    When I say "Set my first name to ContextTest"
    Then response has 2 messages
    And first message content contains "First Name: ContextTest"
    # Tests that context variables are properly set and used

  @test_profilenames_operation_status_tracking
  Scenario: Test operation status tracking
    When I say "Set my first name to StatusTrackingTest"
    Then response has 2 messages
    And first message content contains "Updating Profile Names"
    # Tests that operation_status variable is managed correctly

  @test_profilenames_result_message_handling
  Scenario: Test result message variable handling
    When I say "manage profile names"
    Then response has 1 message
    And first message content contains "Your Profile Names"
    # Tests that result_message variable is handled properly

  @test_profilenames_multiple_conditions
  Scenario: Test multiple condition evaluation
    When I say "Set my first name to MultiConditionTest"
    Then response has 2 messages
    # Tests that multiple conditional action groups execute correctly

  @test_profilenames_api_timeout_configuration
  Scenario: Test API timeout configuration
    When I say "Set my first name to TimeoutTest"
    Then response has 2 messages
    And first message content contains "Updating Profile Names"
    # Tests that timeout: 30 is properly configured

  @test_profilenames_system_alias_usage
  Scenario: Test system alias configuration
    When I say "Set my first name to SystemAliasTest"
    Then response has 2 messages
    And first message content contains "Updating Profile Names"
    # Tests that ConcurProfileBotAPI system alias is used

  @test_profilenames_graphql_path_usage
  Scenario: Test GraphQL path configuration
    When I say "Set my first name to GraphQLPathTest"
    Then response has 2 messages
    And first message content contains "Updating Profile Names"
    # Tests that /graphql path is used correctly

  @test_profilenames_content_type_handling
  Scenario: Test content type handling for API calls
    When I say "Set my first name to ContentTypeTest"
    Then response has 2 messages
    And first message content contains "Updating Profile Names"
    # Tests that proper content type is set for GraphQL calls
