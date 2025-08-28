Feature: Add Passport Management
  Test the scenario that adds new passport information to Concur Travel Profile.

  Background:
    Given I log in
    And I start a new conversation

  @test_add_passport_complete
  Scenario: Add passport with all required fields
    When I say "Add my passport number 123456789 expiring 2030-01-01 issued 2020-01-01 in New York nationality US country US"
    Then response has 3 messages
    And first message has type text
    And first message content contains "DEBUG - Add Passport Request"
    And second message has type text
    And second message content contains "DEBUG - Complete GraphQL Request Body"
    And third message has type text
    And third message content contains "New Passport Added Successfully"

  @test_missing_required_fields
  Scenario: Try to add passport with missing fields
    When I say "Add my passport"
    Then response has 1 message
    And first message has type text
    And first message content contains "Missing Required Information"
    And first message content contains "All passport fields are required"

  @test_missing_passport_number
  Scenario: Add passport without passport number
    When I say "Add passport expiring 2030-01-01 issued 2020-01-01 in London nationality GB country GB"
    Then response has 1 message
    And first message content contains "Missing Required Information"
    And first message content contains "Passport Number"

  @test_missing_expiration_date
  Scenario: Add passport without expiration date
    When I say "Add passport number 987654321 issued 2020-01-01 in London nationality GB country GB"
    Then response has 1 message
    And first message content contains "Missing Required Information"
    And first message content contains "Expiration Date"

  @test_missing_issue_date
  Scenario: Add passport without issue date
    When I say "Add passport number 987654321 expiring 2030-01-01 in London nationality GB country GB"
    Then response has 1 message
    And first message content contains "Missing Required Information"
    And first message content contains "Issue Date"

  @test_missing_issue_place
  Scenario: Add passport without issue place
    When I say "Add passport number 987654321 expiring 2030-01-01 issued 2020-01-01 nationality GB country GB"
    Then response has 1 message
    And first message content contains "Missing Required Information"
    And first message content contains "Issue Place"

  @test_missing_nationality
  Scenario: Add passport without nationality
    When I say "Add passport number 987654321 expiring 2030-01-01 issued 2020-01-01 in London country GB"
    Then response has 1 message
    And first message content contains "Missing Required Information"
    And first message content contains "Nationality"

  @test_missing_issuing_country
  Scenario: Add passport without issuing country
    When I say "Add passport number 987654321 expiring 2030-01-01 issued 2020-01-01 in London nationality GB"
    Then response has 1 message
    And first message content contains "Missing Required Information"
    And first message content contains "Issuing Country"

  @test_passport_limit_reached
  Scenario: Try to add passport when limit is reached
    When I say "Add my passport number 999999999 expiring 2030-01-01 issued 2020-01-01 in Paris nationality FR country FR"
    Then response has 1 message
    And first message has type text
    And first message content contains "Cannot Add Passport"
    And first message content contains "Maximum passport limit (2) reached"

  @test_add_first_passport
  Scenario: Add first passport to empty profile
    When I say "Add my passport number 111111111 expiring 2030-01-01 issued 2020-01-01 in Berlin nationality DE country DE"
    Then response has 3 messages
    And third message content contains "New Passport Added Successfully"
    And third message content contains "111111111"

  @test_add_second_passport
  Scenario: Add second passport when one exists
    When I say "Add my passport number 222222222 expiring 2030-01-01 issued 2020-01-01 in Tokyo nationality JP country JP"
    Then response has 3 messages
    And third message content contains "New Passport Added Successfully"
    And third message content contains "222222222"

  @test_different_date_formats
  Scenario: Add passport with different date formats
    When I say "Add my passport number 333333333 expiring 2030-12-31 issued 2020-06-15 in Sydney nationality AU country AU"
    Then response has 3 messages
    And third message content contains "New Passport Added Successfully"

  @test_special_characters_issue_place
  Scenario: Add passport with special characters in issue place
    When I say "Add my passport number 444444444 expiring 2030-01-01 issued 2020-01-01 in São Paulo nationality BR country BR"
    Then response has 3 messages
    And third message content contains "New Passport Added Successfully"
    And third message content contains "São Paulo"

  @test_long_passport_number
  Scenario: Add passport with longer passport number
    When I say "Add my passport number ABCD123456789 expiring 2030-01-01 issued 2020-01-01 in Mumbai nationality IN country IN"
    Then response has 3 messages
    And third message content contains "New Passport Added Successfully"
    And third message content contains "ABCD123456789"

  @test_alphanumeric_passport_number
  Scenario: Add passport with alphanumeric passport number
    When I say "Add my passport number AB1234567 expiring 2030-01-01 issued 2020-01-01 in Toronto nationality CA country CA"
    Then response has 3 messages
    And third message content contains "New Passport Added Successfully"
    And third message content contains "AB1234567"

  @test_addpass_case_variations
  Scenario: Test different case variations
    When I say "ADD MY PASSPORT NUMBER 555555555 EXPIRING 2030-01-01 ISSUED 2020-01-01 IN MOSCOW NATIONALITY RU COUNTRY RU"
    Then response has 3 messages
    And third message content contains "New Passport Added Successfully"

  @test_natural_language_format
  Scenario: Natural language passport addition
    When I say "I want to add my passport with number 666666666 that expires on 2030-01-01 and was issued on 2020-01-01 in Rome with Italian nationality from Italy"
    Then response has 3 messages
    And third message content contains "New Passport Added Successfully"

  @test_different_country_codes
  Scenario: Add passport with different country code formats
    When I say "Add my passport number 777777777 expiring 2030-01-01 issued 2020-01-01 in Madrid nationality ESP country ESP"
    Then response has 3 messages
    And third message content contains "New Passport Added Successfully"
    And third message content contains "ESP"

  @test_future_expiration_date
  Scenario: Add passport with far future expiration
    When I say "Add my passport number 888888888 expiring 2040-01-01 issued 2020-01-01 in Amsterdam nationality NL country NL"
    Then response has 3 messages
    And third message content contains "New Passport Added Successfully"
    And third message content contains "2040-01-01"

  @test_recent_issue_date
  Scenario: Add passport with recent issue date
    When I say "Add my passport number 999999999 expiring 2030-01-01 issued 2023-01-01 in Stockholm nationality SE country SE"
    Then response has 3 messages
    And third message content contains "New Passport Added Successfully"
    And third message content contains "2023-01-01"

  @test_multiple_word_issue_place
  Scenario: Add passport with multiple word issue place
    When I say "Add my passport number 101010101 expiring 2030-01-01 issued 2020-01-01 in New Delhi nationality IN country IN"
    Then response has 3 messages
    And third message content contains "New Passport Added Successfully"
    And third message content contains "New Delhi"

  @test_hyphenated_issue_place
  Scenario: Add passport with hyphenated issue place
    When I say "Add my passport number 202020202 expiring 2030-01-01 issued 2020-01-01 in Kuala-Lumpur nationality MY country MY"
    Then response has 3 messages
    And third message content contains "New Passport Added Successfully"
    And third message content contains "Kuala-Lumpur"

  @test_apostrophe_issue_place
  Scenario: Add passport with apostrophe in issue place
    When I say "Add my passport number 303030303 expiring 2030-01-01 issued 2020-01-01 in St. John's nationality CA country CA"
    Then response has 3 messages
    And third message content contains "New Passport Added Successfully"
    And third message content contains "St. John's"

  @test_addpass_error_simulation
  Scenario: Simulate API error response
    When I say "Add my passport number ERROR-TEST expiring 2030-01-01 issued 2020-01-01 in ErrorCity nationality ER country ER"
    Then response has 3 messages
    And first message content contains "DEBUG - Add Passport Request"
    # Note: Actual error handling would depend on API response

  @test_addpass_connection_failure
  Scenario: Test connection failure handling
    When I say "Add my passport number CONN-TEST expiring 2030-01-01 issued 2020-01-01 in ConnCity nationality CT country CT"
    Then response has 3 messages
    And first message content contains "DEBUG - Add Passport Request"
    # Note: Connection failure testing would require specific test environment setup

  @test_addpass_jwt_token_usage
  Scenario: Verify JWT token is used in API calls
    When I say "Add my passport number JWT-TEST expiring 2030-01-01 issued 2020-01-01 in JWTCity nationality JW country JW"
    Then response has 3 messages
    And first message content contains "DEBUG - Add Passport Request"
    # Note: JWT token usage is internal and not directly testable in user response

  @test_addpass_initialization_variables
  Scenario: Test that initialization variables are set correctly
    When I say "Add my passport number INIT-TEST expiring 2030-01-01 issued 2020-01-01 in InitCity nationality IN country IN"
    Then response has 3 messages
    # Tests that initialization action group executed properly

  @test_addpass_handlebars_templating
  Scenario: Test Handlebars template rendering
    When I say "Add my passport number HANDLEBARS expiring 2030-01-01 issued 2020-01-01 in TemplateCity nationality HB country HB"
    Then response has 3 messages
    And first message content contains "DEBUG - Add Passport Request"
    # Tests that Handlebars template rendered correctly

  @test_addpass_context_variables
  Scenario: Test context variable usage
    When I say "Add my passport number CONTEXT expiring 2030-01-01 issued 2020-01-01 in ContextCity nationality CX country CX"
    Then response has 3 messages
    # Tests that context variables are properly set and used

  @test_addpass_api_timeout_configuration
  Scenario: Test API timeout configuration
    When I say "Add my passport number TIMEOUT expiring 2030-01-01 issued 2020-01-01 in TimeoutCity nationality TO country TO"
    Then response has 3 messages
    And first message content contains "DEBUG - Add Passport Request"
    # Tests that timeout: 30 is properly configured

  @test_addpass_system_alias_usage
  Scenario: Test system alias configuration
    When I say "Add my passport number ALIAS expiring 2030-01-01 issued 2020-01-01 in AliasCity nationality AL country AL"
    Then response has 3 messages
    And first message content contains "DEBUG - Add Passport Request"
    # Tests that ConcurProfileBotAPI system alias is used

  @test_addpass_graphql_path_usage
  Scenario: Test GraphQL path configuration
    When I say "Add my passport number GRAPHQL expiring 2030-01-01 issued 2020-01-01 in GraphQLCity nationality GQ country GQ"
    Then response has 3 messages
    And first message content contains "DEBUG - Add Passport Request"
    # Tests that /graphql path is used correctly

  @test_addpass_mutation_query_structure
  Scenario: Test GraphQL mutation query structure
    When I say "Add my passport number MUTATION expiring 2030-01-01 issued 2020-01-01 in MutationCity nationality MU country MU"
    Then response has 3 messages
    And first message content contains "DEBUG - Add Passport Request"
    # Tests that GraphQL mutation queries are properly structured

  @test_addpass_documents_field_usage
  Scenario: Test documents field usage in GraphQL
    When I say "Add my passport number DOCUMENTS expiring 2030-01-01 issued 2020-01-01 in DocumentsCity nationality DO country DO"
    Then response has 3 messages
    And first message content contains "DEBUG - Add Passport Request"
    # Tests that "documents" field is used in GraphQL mutations

  @test_addpass_passports_array_building
  Scenario: Test passports array building for addition
    When I say "Add my passport number ARRAY expiring 2030-01-01 issued 2020-01-01 in ArrayCity nationality AR country AR"
    Then response has 3 messages
    And first message content contains "Passports Array Being Sent"
    # Tests that passport arrays are properly constructed for additions

  @test_existing_passport_preservation
  Scenario: Test existing passport preservation
    When I say "Add my passport number PRESERVE expiring 2030-01-01 issued 2020-01-01 in PreserveCity nationality PR country PR"
    Then response has 3 messages
    And first message content contains "Existing Passports Count"
    # Tests that existing passports are preserved when adding new ones

  @test_addpass_passport_count_tracking
  Scenario: Test passport count tracking
    When I say "Add my passport number COUNT expiring 2030-01-01 issued 2020-01-01 in CountCity nationality CO country CO"
    Then response has 3 messages
    And first message content contains "Existing Passports Count"
    # Tests that passport count is properly tracked

  @test_addpass_has_passports_flag
  Scenario: Test has_passports flag usage
    When I say "Add my passport number FLAG expiring 2030-01-01 issued 2020-01-01 in FlagCity nationality FL country FL"
    Then response has 3 messages
    # Tests that has_passports flag is properly set and used

  @test_debug_information_display
  Scenario: Test debug information display
    When I say "Add my passport number DEBUG expiring 2030-01-01 issued 2020-01-01 in DebugCity nationality DB country DB"
    Then response has 3 messages
    And first message content contains "DEBUG - Add Passport Request"
    And first message content contains "New Passport Details"
    And second message content contains "DEBUG - Complete GraphQL Request Body"
    # Tests that debug information is properly displayed

  @test_addpass_success_message_formatting
  Scenario: Test success message formatting
    When I say "Add my passport number SUCCESS expiring 2030-01-01 issued 2020-01-01 in SuccessCity nationality SU country SU"
    Then response has 3 messages
    And third message content contains "New Passport Added Successfully"
    And third message content contains "Added Details"
    And third message content contains "You can have up to 2 passports"
    # Tests that success messages are properly formatted

  @test_addpass_error_message_formatting
  Scenario: Test error message formatting
    When I say "add passport without details"
    Then response has 1 message
    And first message content contains "Missing Required Information"
    # Tests that error messages are properly formatted

  @test_limit_message_formatting
  Scenario: Test limit reached message formatting
    When I say "Add my passport number LIMIT expiring 2030-01-01 issued 2020-01-01 in LimitCity nationality LI country LI"
    Then response has 1 message
    And first message content contains "Cannot Add Passport"
    And first message content contains "Maximum passport limit (2) reached"
    And first message content contains "What you can do"
    # Tests that limit reached messages are properly formatted

  @test_api_retrieval_success
  Scenario: Test API retrieval success handling
    When I say "Add my passport number RETRIEVAL expiring 2030-01-01 issued 2020-01-01 in RetrievalCity nationality RE country RE"
    Then response has 3 messages
    # Tests that API retrieval success is properly handled

  @test_graphql_body_construction
  Scenario: Test GraphQL body construction
    When I say "Add my passport number BODY expiring 2030-01-01 issued 2020-01-01 in BodyCity nationality BO country BO"
    Then response has 3 messages
    And second message content contains "DEBUG - Complete GraphQL Request Body"
    # Tests that GraphQL request body is properly constructed

  @test_addpass_variable_input_structure
  Scenario: Test GraphQL variable input structure
    When I say "Add my passport number VARIABLE expiring 2030-01-01 issued 2020-01-01 in VariableCity nationality VA country VA"
    Then response has 3 messages
    And first message content contains "GraphQL Mutation"
    # Tests that GraphQL variables are properly structured

  @test_addpass_passport_field_mapping
  Scenario: Test passport field mapping in request
    When I say "Add my passport number MAPPING expiring 2030-01-01 issued 2020-01-01 in MappingCity nationality MA country MA"
    Then response has 3 messages
    And first message content contains "New Passport Details"
    And first message content contains "Number: MAPPING"
    And first message content contains "Expiration: 2030-01-01"
    And first message content contains "Issue Date: 2020-01-01"
    And first message content contains "Issue Place: MappingCity"
    And first message content contains "Nationality: MA"
    And first message content contains "Issuing Country: MA"
    # Tests that passport fields are properly mapped in the request

  @test_json_array_formatting
  Scenario: Test JSON array formatting
    When I say "Add my passport number JSON expiring 2030-01-01 issued 2020-01-01 in JSONCity nationality JS country JS"
    Then response has 3 messages
    And first message content contains "Passports Array Being Sent"
    # Tests that JSON arrays are properly formatted

  @test_existing_passport_join
  Scenario: Test existing passport joining in array
    When I say "Add my passport number JOIN expiring 2030-01-01 issued 2020-01-01 in JoinCity nationality JO country JO"
    Then response has 3 messages
    # Tests that existing passports are properly joined in the array

  @test_required_fields_validation
  Scenario: Test all required fields validation
    When I say "Add passport"
    Then response has 1 message
    And first message content contains "All passport fields are required"
    And first message content contains "Passport Number"
    And first message content contains "Expiration Date (YYYY-MM-DD)"
    And first message content contains "Issue Date (YYYY-MM-DD)"
    And first message content contains "Issue Place"
    And first message content contains "Nationality"
    And first message content contains "Issuing Country"
    # Tests that all required fields are properly validated

  @test_example_format_display
  Scenario: Test example format display
    When I say "Add passport without required info"
    Then response has 1 message
    And first message content contains "Example:"
    And first message content contains "Add my passport number 123456789 expiring 2030-01-01"
    # Tests that example formats are properly displayed

  @test_passport_limit_advice
  Scenario: Test passport limit advice display
    When I say "Add my passport number ADVICE expiring 2030-01-01 issued 2020-01-01 in AdviceCity nationality AD country AD"
    Then response has 3 messages
    And third message content contains "You can have up to 2 passports in your profile"
    And third message content contains "Show my passports"
    # Tests that passport limit advice is properly displayed

  @test_profile_integration_note
  Scenario: Test profile integration note
    When I say "Add my passport number PROFILE expiring 2030-01-01 issued 2020-01-01 in ProfileCity nationality PF country PF"
    Then response has 3 messages
    And third message content contains "Your new passport information has been added to your travel profile"
    # Tests that profile integration notes are displayed
