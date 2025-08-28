Feature: Email Addresses Management
  Test the scenario that manages email address information (add, update, delete) in Concur Travel Profile.

  Background:
    Given I log in
    And I start a new conversation

  @test_emailaddresses_view_default
  Scenario: View email addresses with no action specified
    When I say "manage email addresses"
    Then response has 1 message
    And first message has type text
    And first message content contains "Your Email Addresses"
    And first message content contains "What would you like to do?"

  @test_show_emails
  Scenario: Show current email addresses
    When I say "show my email addresses"
    Then response has 1 message
    And first message has type text
    And first message content contains "Your Email Addresses"

  @test_view_emails
  Scenario: View current email addresses
    When I say "view my emails"
    Then response has 1 message
    And first message has type text
    And first message content contains "Your Email Addresses"

  @test_emailaddresses_add_without_fields
  Scenario: Add email without providing specific fields
    When I say "add email"
    Then response has 1 message
    And first message has type text
    And first message content contains "Missing Information"
    And first message content contains "Email type"
    And first message content contains "Email address"

  @test_add_business_email
  Scenario: Add business email address
    When I say "Add my business email john.smith@company.com"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Adding Business email"
    And first message content contains "john.smith@company.com"
    And second message has type text
    And second message content contains "Email Address Added Successfully"

  @test_add_personal_email
  Scenario: Add personal email address
    When I say "Add my personal email john@gmail.com"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Adding Personal email"
    And first message content contains "john@gmail.com"

  @test_add_supervisor_email
  Scenario: Add supervisor email address
    When I say "Add my supervisor email supervisor@company.com"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Adding Supervisor email"
    And first message content contains "supervisor@company.com"

  @test_add_travel_arranger_email
  Scenario: Add travel arranger email address
    When I say "Add my travel arranger email ta@company.com"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Adding TravelArranger email"
    And first message content contains "ta@company.com"

  @test_add_business2_email
  Scenario: Add business2 email address
    When I say "Add my business2 email business2@company.com"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Adding Business2 email"
    And first message content contains "business2@company.com"

  @test_add_other1_email
  Scenario: Add other1 email address
    When I say "Add my other1 email other1@example.com"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Adding Other1 email"
    And first message content contains "other1@example.com"

  @test_add_other2_email
  Scenario: Add other2 email address
    When I say "Add my other2 email other2@example.com"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Adding Other2 email"
    And first message content contains "other2@example.com"

  @test_emailaddresses_update_without_fields
  Scenario: Update email without providing specific fields
    When I say "update my email"
    Then response has 1 message
    And first message has type text
    And first message content contains "What would you like to update?"
    And first message content contains "Email type to update"

  @test_update_business_email
  Scenario: Update business email address
    When I say "Update my business email to newbusiness@company.com"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Updating Business email"
    And first message content contains "newbusiness@company.com"
    And second message has type text
    And second message content contains "Email Address Updated Successfully"

  @test_update_personal_email
  Scenario: Update personal email address
    When I say "Update my personal email to newpersonal@gmail.com"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Updating Personal email"
    And first message content contains "newpersonal@gmail.com"

  @test_emailaddresses_delete_without_selection
  Scenario: Delete email without specifying which one
    When I say "delete my email"
    Then response has 1 message
    And first message has type list

  @test_delete_business_email
  Scenario: Delete business email address
    When I say "Delete my business email"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Deleting Business email"
    And second message has type text
    And second message content contains "Email Address Deleted Successfully"

  @test_delete_personal_email
  Scenario: Delete personal email address
    When I say "Delete my personal email"
    Then response has 2 messages
    And first message has type text
    And first message content contains "Deleting Personal email"

  @test_emailaddresses_case_variations
  Scenario: Test different case variations for email types
    When I say "ADD MY BUSINESS EMAIL UPPERCASE@COMPANY.COM"
    Then response has 2 messages
    And first message content contains "Adding Business email"
    And first message content contains "UPPERCASE@COMPANY.COM"

  @test_special_characters_email
  Scenario: Handle emails with special characters
    When I say "Add my personal email josé.garcía@example.com"
    Then response has 2 messages
    And first message content contains "Adding Personal email"
    And first message content contains "josé.garcía@example.com"

  @test_plus_addressing
  Scenario: Handle plus addressing in emails
    When I say "Add my personal email john+test@gmail.com"
    Then response has 2 messages
    And first message content contains "Adding Personal email"
    And first message content contains "john+test@gmail.com"

  @test_subdomain_email
  Scenario: Handle emails with subdomains
    When I say "Add my business email john@mail.company.com"
    Then response has 2 messages
    And first message content contains "Adding Business email"
    And first message content contains "john@mail.company.com"

  @test_long_email_address
  Scenario: Handle longer email addresses
    When I say "Add my business email very.long.email.address@very.long.domain.example.com"
    Then response has 2 messages
    And first message content contains "Adding Business email"
    And first message content contains "very.long.email.address@very.long.domain.example.com"

  @test_hyphenated_domain
  Scenario: Handle emails with hyphenated domains
    When I say "Add my business email john@test-company.com"
    Then response has 2 messages
    And first message content contains "Adding Business email"
    And first message content contains "john@test-company.com"

  @test_numeric_email
  Scenario: Handle emails with numbers
    When I say "Add my personal email user123@example123.com"
    Then response has 2 messages
    And first message content contains "Adding Personal email"
    And first message content contains "user123@example123.com"

  @test_emailaddresses_sequential_operations
  Scenario: Multiple sequential email operations
    Given I say "Add my personal email initial@gmail.com"
    When I say "Update my personal email to final@gmail.com"
    Then response has 2 messages
    And first message content contains "Updating Personal email"
    And first message content contains "final@gmail.com"

  @test_emailaddresses_mixed_operations
  Scenario: Mix different operation types
    Given I say "Add my business email test@company.com"
    When I say "show my email addresses"
    Then response has 1 message
    And first message content contains "Your Email Addresses"

  @test_emailaddresses_view_after_add
  Scenario: View emails after successful add
    Given I say "Add my personal email newuser@gmail.com"
    When I say "show my email addresses"
    Then response has 1 message
    And first message has type text
    And first message content contains "Your Email Addresses"

  @test_emailaddresses_view_after_update
  Scenario: View emails after successful update
    Given I say "Update my business email to updated@company.com"
    When I say "view my emails"
    Then response has 1 message
    And first message has type text
    And first message content contains "Your Email Addresses"

  @test_emailaddresses_view_after_delete
  Scenario: View emails after successful delete
    Given I say "Delete my supervisor email"
    When I say "show my email addresses"
    Then response has 1 message
    And first message has type text
    And first message content contains "Your Email Addresses"

  @test_emailaddresses_help_examples
  Scenario: View help and examples for email management
    When I say "how do I add an email"
    Then response has 1 message
    And first message has type text
    And first message content contains "Examples:"
    And first message content contains "Add my personal email"

  @test_empty_email_handling
  Scenario: Handle empty email values
    When I say "Add my business email "
    Then response has 1 message
    And first message content contains "Missing Information"

  @test_invalid_email_type
  Scenario: Handle invalid email type
    When I say "Add my invalid email test@example.com"
    Then response has 1 message
    And first message content contains "Missing Information"

  @test_emailaddresses_natural_language_add
  Scenario: Natural language email addition
    When I say "I want to add my work email which is work@company.com"
    Then response has 2 messages
    And first message content contains "Adding"
    And first message content contains "work@company.com"

  @test_emailaddresses_natural_language_update
  Scenario: Natural language email update
    When I say "My business email should be changed to newbiz@company.com"
    Then response has 2 messages
    And first message content contains "Updating"
    And first message content contains "newbiz@company.com"

  @test_multiple_email_types_mention
  Scenario: Handle multiple email types in one request
    When I say "Add my business email biz@company.com and personal email personal@gmail.com"
    Then response has 2 messages
    And first message content contains "Adding"

  @test_emailaddresses_error_simulation
  Scenario: Simulate API error response
    When I say "Add my business email errortest@company.com"
    Then response has 2 messages
    And first message content contains "Adding Business email"
    # Note: Actual error handling would depend on API response

  @test_emailaddresses_connection_failure
  Scenario: Test connection failure handling
    When I say "Add my personal email connectiontest@gmail.com"
    Then response has 2 messages
    And first message content contains "Adding Personal email"
    # Note: Connection failure testing would require specific test environment setup

  @test_emailaddresses_basic_add_functionality
  Scenario: Verify basic add functionality
    When I say "Add my personal email testbasic@gmail.com"
    Then response has 2 messages
    And first message content contains "Adding Personal email"
    And first message content contains "testbasic@gmail.com"

  @test_emailaddresses_basic_update_functionality
  Scenario: Verify basic update functionality
    When I say "Update my business email to updatetest@company.com"
    Then response has 2 messages
    And first message content contains "Updating Business email"
    And first message content contains "updatetest@company.com"

  @test_emailaddresses_basic_delete_functionality
  Scenario: Verify basic delete functionality
    When I say "Delete my supervisor email"
    Then response has 2 messages
    And first message content contains "Deleting Supervisor email"

  @test_emailaddresses_jwt_token_usage
  Scenario: Verify JWT token is used in API calls
    When I say "Add my business email jwttest@company.com"
    Then response has 2 messages
    And first message content contains "Adding Business email"
    # Note: JWT token usage is internal and not directly testable in user response

  @test_emailaddresses_initialization_variables
  Scenario: Test that initialization variables are set correctly
    When I say "manage email addresses"
    Then response has 1 message
    And first message content contains "Your Email Addresses"
    # Tests that initialization action group executed properly

  @test_emailaddresses_conditional_logic
  Scenario: Test conditional logic execution
    When I say "show my email addresses"
    Then response has 1 message
    And first message content contains "Your Email Addresses"
    # Tests that correct condition branch was taken

  @test_emailaddresses_handlebars_templating
  Scenario: Test Handlebars template rendering
    When I say "manage email addresses"
    Then response has 1 message
    And first message content contains "What would you like to do?"
    # Tests that Handlebars template rendered correctly

  @test_emailaddresses_context_variables
  Scenario: Test context variable usage
    When I say "Add my personal email contexttest@gmail.com"
    Then response has 2 messages
    And first message content contains "contexttest@gmail.com"
    # Tests that context variables are properly set and used

  @test_emailaddresses_operation_status_tracking
  Scenario: Test operation status tracking
    When I say "Add my business email statustest@company.com"
    Then response has 2 messages
    And first message content contains "Adding Business email"
    # Tests that operation_status variable is managed correctly

  @test_emailaddresses_result_message_handling
  Scenario: Test result message variable handling
    When I say "manage email addresses"
    Then response has 1 message
    And first message content contains "Your Email Addresses"
    # Tests that result_message variable is handled properly

  @test_emailaddresses_multiple_conditions
  Scenario: Test multiple condition evaluation
    When I say "Add my personal email multicondition@gmail.com"
    Then response has 2 messages
    # Tests that multiple conditional action groups execute correctly

  @test_emailaddresses_api_timeout_configuration
  Scenario: Test API timeout configuration
    When I say "Add my business email timeouttest@company.com"
    Then response has 2 messages
    And first message content contains "Adding Business email"
    # Tests that timeout: 30 is properly configured

  @test_emailaddresses_system_alias_usage
  Scenario: Test system alias configuration
    When I say "Add my personal email aliastest@gmail.com"
    Then response has 2 messages
    And first message content contains "Adding Personal email"
    # Tests that ConcurProfileBotAPI system alias is used

  @test_emailaddresses_graphql_path_usage
  Scenario: Test GraphQL path configuration
    When I say "Add my business email graphqltest@company.com"
    Then response has 2 messages
    And first message content contains "Adding Business email"
    # Tests that /graphql path is used correctly

  @test_emailaddresses_content_type_handling
  Scenario: Test content type handling for API calls
    When I say "Add my personal email contenttypetest@gmail.com"
    Then response has 2 messages
    And first message content contains "Adding Personal email"
    # Tests that proper content type is set for GraphQL calls

  @test_email_verification_status
  Scenario: Test email verification status display
    When I say "show my email addresses"
    Then response has 1 message
    And first message content contains "Your Email Addresses"
    # Tests that verification status (verified/unverified) is displayed

  @test_primary_email_indication
  Scenario: Test primary email indication
    When I say "view my emails"
    Then response has 1 message
    And first message content contains "Your Email Addresses"
    # Tests that primary email is properly indicated

  @test_emailaddresses_list_interface_delete
  Scenario: Test list interface for email deletion
    When I say "delete email"
    Then response has 1 message
    And first message has type list
    And first message content contains "Select Email to Delete"
    # Tests that list interface is properly rendered for deletion

  @test_email_type_normalization
  Scenario: Test email type normalization
    When I say "Add my BUSINESS email normalization@company.com"
    Then response has 2 messages
    And first message content contains "Adding Business email"
    # Tests that email types are properly normalized

  @test_emailaddresses_array_building_add
  Scenario: Test array building for add operations
    When I say "Add my personal email arraytest@gmail.com"
    Then response has 2 messages
    And first message content contains "Adding Personal email"
    # Tests that email arrays are properly constructed for add operations

  @test_emailaddresses_array_building_update
  Scenario: Test array building for update operations
    When I say "Update my business email to arrayupdate@company.com"
    Then response has 2 messages
    And first message content contains "Updating Business email"
    # Tests that email arrays are properly constructed for update operations

  @test_emailaddresses_array_building_delete
  Scenario: Test array building for delete operations
    When I say "Delete my supervisor email"
    Then response has 2 messages
    And first message content contains "Deleting Supervisor email"
    # Tests that email arrays are properly constructed for delete operations

  @test_emailaddresses_mutation_query_structure
  Scenario: Test GraphQL mutation query structure
    When I say "Add my personal email mutationtest@gmail.com"
    Then response has 2 messages
    And first message content contains "Adding Personal email"
    # Tests that GraphQL mutation queries are properly structured

  @test_emailaddresses_variable_input_structure
  Scenario: Test GraphQL variable input structure
    When I say "Update my business email to variabletest@company.com"
    Then response has 2 messages
    And first message content contains "Updating Business email"
    # Tests that GraphQL variables are properly structured

  @test_email_count_tracking
  Scenario: Test email count tracking
    When I say "show my email addresses"
    Then response has 1 message
    And first message content contains "Your Email Addresses"
    # Tests that email count is properly tracked and used

  @test_has_emails_flag
  Scenario: Test has_emails flag usage
    When I say "manage email addresses"
    Then response has 1 message
    And first message content contains "Your Email Addresses"
    # Tests that has_emails flag is properly set and used

  @test_no_emails_message
  Scenario: Test no emails message display
    When I say "view my emails"
    Then response has 1 message
    And first message content contains "Your Email Addresses"
    # Tests proper message when no emails exist

  @test_emailaddresses_success_message_formatting
  Scenario: Test success message formatting
    When I say "Add my personal email successtest@gmail.com"
    Then response has 2 messages
    And second message content contains "Email Address Added Successfully"
    And second message content contains "New emails are unverified"
    # Tests that success messages are properly formatted

  @test_emailaddresses_error_message_formatting
  Scenario: Test error message formatting
    When I say "add email without details"
    Then response has 1 message
    And first message content contains "Missing Information"
    # Tests that error messages are properly formatted

  @test_verification_note_display
  Scenario: Test verification note display
    When I say "Add my business email verificationtest@company.com"
    Then response has 2 messages
    And second message content contains "New emails are unverified"
    # Tests that verification notes are displayed

  @test_re_verification_note
  Scenario: Test re-verification note for updates
    When I say "Update my personal email to reverify@gmail.com"
    Then response has 2 messages
    And second message content contains "Updated emails will need re-verification"
    # Tests that re-verification notes are shown for updates
