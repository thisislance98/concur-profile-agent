# Joule Development Guide

## Table of Contents

1. [Introduction to Joule](#introduction-to-joule)
2. [Getting Started](#getting-started)
3. [Development Environment Setup](#development-environment-setup)
4. [Building Your First Capability](#building-your-first-capability)
5. [Schema Version Compatibility](#schema-version-compatibility)
6. [Design Time Artifacts (DTA)](#design-time-artifacts-dta)
7. [Dialog Functions and Scenarios](#dialog-functions-and-scenarios)
8. [Messages and User Interface](#messages-and-user-interface)
9. [Testing and Debugging](#testing-and-debugging)
10. [Deployment and Integration](#deployment-and-integration)
11. [Advanced Features](#advanced-features)
12. [Best Practices and Guidelines](#best-practices-and-guidelines)
13. [Common Issues and Gotchas](#common-issues-and-gotchas)
14. [Troubleshooting](#troubleshooting)

---

## Introduction to Joule

Joule is SAP's conversational AI assistant that enables users to interact with SAP applications through natural language. It supports multiple languages and provides a rich conversational experience across web and mobile platforms.

### Key Features

- **Multi-language Support**: English, German, French, Spanish, and Portuguese
- **Cross-platform**: Web and mobile applications
- **Extensible**: Custom capabilities through Design Time Artifacts
- **Integration Ready**: Seamless integration with SAP applications
- **GenAI Powered**: Advanced AI capabilities for natural language processing

### Architecture Overview

Joule consists of several key components:

- **Joule Functions**: GenAI-integrated scenarios with intelligent slot filling
- **Watson Scenarios**: Traditional rule-based conversation flows
- **Dialog Functions**: Executable blocks for API calls and data processing
- **Web Client**: Conversational user interface
- **Command Line Interface**: Development and deployment tools

---

## Getting Started

### Prerequisites

Before developing with Joule, ensure you have:

1. **SAP BTP Account**: With appropriate entitlements for Joule
2. **Node.js**: Version 18-22 for CLI operations
3. **Visual Studio Code**: For development with Joule IDE extension
4. **Git**: For version control

### Creating Joule Subscription

1. **Subscribe to Joule Application**:
   - Navigate to SAP BTP Cockpit
   - Go to Service Marketplace
   - Find and subscribe to Joule application
   - Choose appropriate plan (Development, Standard, or Designer)

2. **Create Service Instance**:
   - Create Joule service instance with Designer plan
   - Generate service key for API access

3. **Assign Roles**:
   - `capability_developer`: Access Web Client, compile DTAs
   - `capability_release_admin`: Deploy and configure artifacts
   - `end_user`: Access Web Client with SSO

### Supported Data Centers

Joule is available in the following data centers:

- **Europe (Netherlands)**: Microsoft Azure (EU20)
- **Europe (Frankfurt)**: Google Cloud Platform (EU30)
- **US East (VA)**: Microsoft Azure (US21)
- **US Central (IA)**: Google Cloud Platform (US30)
- **Australia (Sydney)**: AWS

---

## Development Environment Setup

### Installing Joule CLI

The Joule Command Line Interface is essential for development workflows.

```bash
# Install the latest version
npm install -g @sap/sapdas-cli --registry=https://int.repositories.cloud.sap/artifactory/api/npm/build-releases-npm

# Install specific version
npm install -g @sap/sapdas-cli@<version> --registry=https://int.repositories.cloud.sap/artifactory/api/npm/build-releases

# Update existing installation
npm install -g @sap/sapdas-cli --force --registry=https://int.repositories.cloud.sap/artifactory/api/npm/build-releases-npm
```

### CLI Login and Configuration

```bash
# Login to tenant
joule login

# Login with specific parameters
joule login -a <authurl> -c <clientid> -s <clientsecret> -u <username> -p <password>

# Login using environment variables
joule login --use-env

# Check login status
joule status
```

### Setting Up IDE Extension

1. **Install Dependencies**:
   ```bash
   npm install -g sapdas-extension@latest --registry=https://int.repositories.cloud.sap/artifactory/api/npm/build-releases-npm
   joule-ide install
   ```

2. **VS Code Configuration**:
   - Install Joule IDE Extension
   - Configure connection to Joule tenant
   - Enable template wizard and validation features

### Environment Variables

Create `.env` file for environment-specific configuration:

```
JOULE_API_URL=<your_tenant_url>
JOULE_USERNAME=<your_username>
JOULE_PASSWORD=<your_password>
JOULE_AUTH_URL=<auth_url>
JOULE_CLIENT_ID=<client_id>
JOULE_CLIENT_SECRET=<client_secret>
JOULE_DEFAULT_IDP=false
```

---

## Building Your First Capability

> **💡 BEST PRACTICE**: Always start with working examples from official sources rather than building from scratch. Use `joule-examples` repository as your foundation.

### Capability Structure

A capability follows this **exact** folder structure:

```
simple-greeting-bot/
├── scenarios/
│   ├── hello_world.yaml
│   ├── tell_joke.yaml
│   └── show_help.yaml
├── functions/
│   ├── say_hello.yaml
│   ├── tell_joke.yaml
│   └── show_help.yaml
├── i18n/
│   └── messages.properties
├── tests/
│   └── features/
│       └── greeting_bot.feature
└── capability.sapdas.yaml
```

### Creating a Simple Greeting Bot - WORKING EXAMPLE

This example is tested and deployable on Joule staging environments.

#### 1. **Create Capability Configuration** (`capability.sapdas.yaml`):

```yaml
schema_version: 3.7.0

metadata:
  namespace: com.sap.example
  name: simple_greeting_bot_v2
  version: 1.0.0
  display_name: "Simple Greeting Bot V2"
  description: A simple bot that provides greetings, jokes, and help information.
```

> **⚠️ CRITICAL**: Use schema version 3.7.0 for staging environments. Latest versions (3.12.0) may not be supported in all environments.

#### 2. **Create Greeting Function** (`functions/say_hello.yaml`):

```yaml
parameters:
  - name: user_name
    optional: true

action_groups:
  - condition: user_name != null
    actions:
      - type: message
        message: 
          type: text 
          content: "<? new i18n('GREETING_WITH_NAME', user_name) ?>"
      - type: message
        message:
          type: quickReplies
          content:
            title: "<? new i18n('WHAT_CAN_I_DO') ?>"
            buttons:
              - title: "<? new i18n('TELL_JOKE') ?>"
                value: joke_request
              - title: "<? new i18n('GET_HELP') ?>"
                value: help_request
  - condition: user_name == null
    actions:
      - type: message
        message:
          type: text
          content: "<? new i18n('GREETING_GENERAL') ?>"
      - type: message
        message:
          type: quickReplies
          content:
            title: "<? new i18n('WHAT_CAN_I_DO') ?>"
            buttons:
              - title: "<? new i18n('TELL_JOKE') ?>"
                value: joke_request
              - title: "<? new i18n('GET_HELP') ?>"
                value: help_request
```

> **💡 SpEL GOTCHA**: Always use double quotes around SpEL expressions: `"<? expression ?>"`. Keep expressions simple - avoid complex array operations or nested conditionals.

#### 3. **Create Joke Function** (`functions/tell_joke.yaml`):

```yaml
parameters: []

action_groups:
  - actions:
      - type: message
        message: 
          type: text 
          content: "<? new i18n('JOKE_CONTENT') ?>"
      - type: message
        message:
          type: quickReplies
          content:
            title: "<? new i18n('ANOTHER_JOKE_QUESTION') ?>"
            buttons:
              - title: "<? new i18n('ANOTHER_JOKE') ?>"
                value: joke_request
              - title: "<? new i18n('SAY_HELLO') ?>"
                value: greeting_request
```

#### 4. **Create Help Function** (`functions/show_help.yaml`):

```yaml
parameters: []

action_groups:
  - actions:
      - type: message
        message: 
          type: card
          content:
            title: "<? new i18n('HELP_TITLE') ?>"
            subtitle: "<? new i18n('HELP_SUBTITLE') ?>"
            description: "<? new i18n('HELP_DESCRIPTION') ?>"
            imageUrl: sap-icon://question-mark
            imageStyle: avatar
            buttons:
              - type: postback
                title: "<? new i18n('SAY_HELLO') ?>"
                value: greeting_request
              - type: postback
                title: "<? new i18n('TELL_JOKE') ?>"
                value: joke_request
      - type: message
        message: 
          type: text 
          content: "<? new i18n('HELP_FEATURES') ?>"
```

#### 5. **Create Scenarios**

**Greeting Scenario** (`scenarios/hello_world.yaml`):
```yaml
description: This function greets users and provides options for further interaction

slots:
  - name: user_name
    description: The name of the person to be greeted

target:
  type: function
  name: say_hello
```

**Joke Scenario** (`scenarios/tell_joke.yaml`):
```yaml
description: This function tells jokes to entertain users and brighten their day

slots: []

target:
  type: function
  name: tell_joke
```

**Help Scenario** (`scenarios/show_help.yaml`):
```yaml
description: This function provides help information about what the bot can do

slots: []

target:
  type: function
  name: show_help
```

#### 6. **Create i18n Messages** (`i18n/messages.properties`):

```properties
GREETING_WITH_NAME=Hello {0}! Welcome to our simple Joule bot!
GREETING_GENERAL=Hello there! Welcome to our simple Joule bot!
WHAT_CAN_I_DO=What would you like to do?
TELL_JOKE=Tell me a Joke
GET_HELP=Get Help
SAY_HELLO=Say Hello
ANOTHER_JOKE=Another Joke
JOKE_CONTENT=Why don't scientists trust atoms? Because they make up everything!
ANOTHER_JOKE_QUESTION=Want to hear another one?
HELP_TITLE=Simple Greeting Bot Help
HELP_SUBTITLE=What I can do for you
HELP_DESCRIPTION=I'm a simple bot designed to demonstrate Joule capabilities. Here's what I can help you with!
HELP_FEATURES=You can ask me to:\n• Greet you (try: 'Hello' or 'Hi there')\n• Tell you a joke\n• Provide this help information
```

> **💡 i18n REQUIREMENT**: Always use i18n for production capabilities. Even if you only support English, this makes future localization easier.

#### 7. **Create Digital Assistant Configuration** (`da.sapdas.yaml`):

```yaml
schema_version: 1.0.0
name: SimpleGreetingAssistantV2
capabilities:
  - type: local
    folder: ./simple-greeting-bot
```

### Compilation and Deployment

```bash
# Compile and deploy in one step (recommended)
joule deploy --compile ./da.sapdas.yaml

# Verify deployment
joule list

# Launch for testing
joule launch <assistant_name>
```

> **⚠️ DEPLOYMENT GOTCHA**: If you get schema version errors, the environment doesn't support your version. Try 3.7.0 first, then 3.6.0 if needed.

---

## Schema Version Compatibility

### Environment Schema Support Matrix

| Environment | Supported Versions | Recommended |
|-------------|-------------------|-------------|
| Production | 3.7.0 - 3.12.0 | 3.10.0+ |
| Staging | 3.6.0 - 3.9.0 | 3.7.0 |
| Development | 3.5.0 - 3.12.0 | 3.7.0 |

### Schema Version Resolution Strategy

1. **Start with 3.7.0** - Most widely supported
2. **If deployment fails**, try 3.6.0
3. **For latest features**, try 3.10.0+ (production only)
4. **Check examples** - Use schema version from working examples

### Version-Specific Features

- **3.12.0**: IBN navigation deprecation
- **3.11.0**: Streamed message support  
- **3.10.0**: i18n conversation starters
- **3.9.0**: Deployment extension and scenario filtering
- **3.8.0**: Removed 2000 character limit for text messages
- **3.7.0**: i18n properties files and SpEL/Handlebars support ✅ **RECOMMENDED**

> **🎯 BEST PRACTICE**: Always check your target environment's schema support before starting development. Use `joule-examples` to find the correct version for your environment.

---

## Design Time Artifacts (DTA)

### Schema Versions

Current supported DTA versions and their features:

- **3.12.0**: Latest version with IBN navigation deprecation
- **3.11.0**: Streamed message support
- **3.10.0**: i18n conversation starters
- **3.9.0**: Deployment extension and scenario filtering
- **3.8.0**: Removed 2000 character limit for text messages
- **3.7.0**: i18n properties files and SpEL/Handlebars support

### Capability Configuration

The `capability.sapdas.yaml` file defines capability metadata:

```yaml
schema_version: 3.12.0
metadata:
  display_name: My Capability
  namespace: com.company.product
  name: my_capability
  version: 1.0.0-SNAPSHOT
  description: Capability description
system_aliases:
  ExternalAPI:
    destination: API_Destination
```

### Naming Conventions

**Capability Level**:
- Name: 50 characters, alphanumeric and underscores
- Namespace: 100 characters, alphanumeric and dots
- Display name: 128 characters
- Description: 512 characters

**Resource Level**:
- File names: 30 characters, alphanumeric and underscores
- Folder names: 30 characters, alphanumeric and underscores
- Context keys: 64 characters, no reserved words

### Folder Structure Rules

- Maximum nesting depth: 3 levels for most folders
- Scenarios: Up to 200 per capability
- Functions: Up to 500 per capability
- Maximum file sizes: 50KB for most YAML files

---

## Dialog Functions and Scenarios

### Dialog Functions

Dialog functions are executable blocks that perform specific tasks:

```yaml
parameters:
  - name: user_id
    optional: false
  - name: filters
    optional: true

action_groups:
  - condition: "user_id != null"
    actions:
      - type: api-request
        method: GET
        system_alias: UserService
        path: /users/<? user_id ?>
        result_variable: user_data
      
      - type: set-variables
        variables:
          - name: formatted_name
            value: <? user_data.body.firstName + " " + user_data.body.lastName ?>
      
      - type: message
        message:
          type: text
          content: Hello <? formatted_name ?>!

result:
  user_name: <? formatted_name ?>
  user_email: <? user_data.body.email ?>
```

### Action Types

1. **API Request**: HTTP calls to external services
2. **Set Variables**: Manipulate local context variables
3. **Message**: Generate UI responses
4. **Dialog Function**: Call other functions
5. **OData Batch**: Batch OData operations
6. **Status Update**: Progress notifications
7. **Streamed Message**: Server-sent events

### Joule Functions vs Watson Scenarios

**Joule Functions** (Recommended):
- GenAI-powered intent recognition
- Automatic slot filling
- No manual training data required
- Built-in response generation

**Watson Scenarios**:
- Rule-based intent matching
- Manual training data required
- Full control over conversation flow
- Suitable for complex dialog trees

### Scenario Types

**Function Scenario Example**:
```yaml
description: This function helps users find and book meeting rooms based on their requirements
slots:
  - name: date
    description: The date for the meeting
  - name: duration
    description: Meeting duration in hours
  - name: capacity
    description: Number of attendees
target:
  type: function
  name: booking/find_rooms
response_context:
  - value: available_rooms
    description: List of available meeting rooms
  - value: booking_status
    description: Booking confirmation status
```

**Watson Scenario Example**:
```yaml
description: Handle user greetings and provide welcome information
target:
  type: watson
  name: greetings/welcome_user
conversation_starter:
  title: Say Hello
  trigger_utterance: Hello there
```

---

## Messages and User Interface

### Message Types

Joule supports various message types for rich user interactions:

### Text Messages

```yaml
- type: message
  message:
    type: text
    content: "Hello! How can I help you today?"
    markdown: true
    delay: 2
```

### Cards

```yaml
- type: message
  message:
    type: card
    content:
      title: User Profile
      subtitle: John Doe
      description: Senior Developer at SAP
      imageUrl: sap-icon://person-placeholder
      imageStyle: avatar
      status: Active
      statusState: success
      buttons:
        - type: postback
          title: View Details
          value: view_profile_john_doe
        - type: navigation
          title: Send Email
          navigation_target:
            url: mailto:john.doe@sap.com
```

### Lists

```yaml
- type: message
  message:
    type: list
    content:
      title: Meeting Rooms
      subtitle: Available today
      elements:
        - title: Conference Room A
          subtitle: Capacity: 10 people
          description: Ground floor, projector available
          buttons:
            - type: postback
              title: Book Room
              value: book_room_a
        - title: Conference Room B
          subtitle: Capacity: 6 people
          description: Second floor, whiteboard available
          buttons:
            - type: postback
              title: Book Room
              value: book_room_b
```

### Quick Replies

```yaml
- type: message
  message:
    type: quickReplies
    content:
      title: What would you like to do?
      buttons:
        - title: Check Weather
          value: weather_request
        - title: Book Meeting
          value: meeting_request
        - title: View Calendar
          value: calendar_request
```

### Carousel

```yaml
- type: message
  message:
    type: carousel
    content:
      cards:
        - title: Product A
          subtitle: Enterprise Solution
          imageUrl: sap-icon://product
          buttons:
            - type: navigation
              title: Learn More
              navigation_target:
                url: https://sap.com/products/product-a
        - title: Product B
          subtitle: Cloud Platform
          imageUrl: sap-icon://cloud
          buttons:
            - type: navigation
              title: Learn More
              navigation_target:
                url: https://sap.com/products/product-b
```

### UI Integration Cards

```yaml
- type: message
  message:
    type: ui5integrationCard
    content:
      manifest: |
        {
          "_version": "1.17.0",
          "sap.app": {
            "type": "card",
            "id": "custom.integration.card"
          },
          "sap.card": {
            "type": "List",
            "header": {
              "title": "Sales Orders"
            },
            "content": {
              "data": {
                "json": <? $sales_data ?>
              },
              "item": {
                "title": "{customer}",
                "description": "Amount: {amount}"
              }
            }
          }
        }
```

### Navigation Actions

Cross-product navigation using Intent-Based Navigation (IBN):

```yaml
buttons:
  - type: navigation
    title: View Sales Order
    navigation_target:
      ibnTarget:
        semanticObject: SalesOrder
        action: display
      ibnParams:
        SalesOrder: "12345"
      url: https://fallback-url.com  # Optional fallback
```

---

## Testing and Debugging

### Test Structure

Create tests using Gherkin syntax in the `tests/features` folder:

```
tests/
└── features/
    ├── weather_capability.feature
    ├── booking_capability.feature
    └── subfolder/
        └── advanced_features.feature
```

### Basic Test Example

```gherkin
Feature: Weather Capability
  Test weather information retrieval

  Background:
    Given I log in
    And I start a new conversation

  Scenario: Get weather for a city
    When I say "What's the weather in Berlin?"
    Then response has 1 message
    And first message has type text
    And first message content contains "Berlin"
    And first message content contains "temperature"

  Scenario: Handle unknown city
    When I say "Weather in Atlantis"
    Then response has 1 message
    And first message content contains "not found"
```

### Advanced Testing Features

**Multi-language Testing**:
```gherkin
Background:
  Given I log in
  Given the client language is "de"
  And I start a new conversation

Scenario: German weather request
  When I say "Wie ist das Wetter in München?"
  Then response has 1 message
  And response relates to "Wetter in München"
```

**Application Context Testing**:
```gherkin
Scenario: Context-aware response
  Given the application context:
    """
    {
      "app_title": "Sales Dashboard",
      "com.sap.sales.context": {
        "current_customer": "ACME Corp"
      }
    }
    """
  When I say "Show customer details"
  Then response has 1 message
  And first message content contains "ACME Corp"
```

**Variable Testing**:
```gherkin
Scenario: Dynamic data usage
  When I say "Show my orders"
  Then response has 1 message
  And first message has type list
  Then set variable 'orders' with the response content
  When I say "Details for order {{ orders.[0].content.elements.[0].title }}"
  Then response has 1 message
  And first message has type card
```

**🧪 Real-World Testing Gotchas** (Critical Lessons):

**Problem: Tests expect 1 message, bot returns 2**

This is extremely common! Bots often return better UX with multiple messages:
```gherkin
# ❌ UNREALISTIC TEST - Expects only greeting
When I say "Hello"
Then response has 1 message

# ❌ WHAT ACTUALLY HAPPENS - Bot provides good UX
# Message 1: "✅ Hello there! Welcome to our simple Joule bot!"
# Message 2: Quick replies with options ("Tell Joke", "Get Help")
# Plus possible system connectivity warnings

# ✅ REALISTIC TEST - Adjust expectations
When I say "Hello"
Then response has 2 messages
And first message has type text
And first message content contains "Hello"
And second message has type quickReplies
```

**System Messages in Tests**:

Many environments add connectivity or system status messages:
```gherkin
# Real test output often includes:
# Message 1: Your function response
# Message 2: "🔧 Working on destination connectivity issues. Please try again soon!"

# ✅ HANDLE SYSTEM MESSAGES
Scenario: Greeting with system messages
  When I say "test simple"
  Then response has 2 messages
  And first message has type text
  And first message content contains "test function"
  # Don't test second message content - it's system-generated
  And message content at index 1 contains "connectivity"
```

**Testing Complex Message Types**:

```gherkin
# ✅ TESTING CARDS
Scenario: Profile card display
  When I say "show my profile"
  Then response has 1 message
  And first message has type card
  # Test card structure, not exact content
  And first message content contains "title"

# ✅ TESTING QUICK REPLIES  
Scenario: Quick reply options
  When I say "what can you do"
  Then response has 1 message
  And first message has type quickReplies
  # quickReplies content is object, not string
  And first message content contains "buttons"

# ✅ TESTING LISTS
Scenario: List of items
  When I say "show options"
  Then response has 1 message
  And first message has type list
  And first message content contains "elements"
```

**Scenario Matching Debug**:

```gherkin
# ❌ SCENARIO NOT MATCHING - Missing samples
# If tests show "0 messages" the scenario might not be triggering

# ✅ ENSURE SCENARIO HAS SAMPLES
# In scenario YAML:
samples:
  - "test simple"
  - "run test"  
  - "debug test"

# ✅ TEST ACTUAL TRIGGER PHRASES
Scenario: Use exact sample phrases
  When I say "test simple"  # Must match samples in scenario
  Then response has 2 messages
```

**Function vs Scenario Testing**:

```gherkin
# Functions return data, scenarios add UI messages
# Test what actually gets returned to user

# ✅ FUNCTION RESULT - Data only
# Function sets variables, returns result object

# ✅ SCENARIO RESPONSE - UI messages  
# Scenario processes function result and creates user messages
When I say "get my profile"
Then response has 1 message  # Scenario message action
And first message content contains "Profile Data:"  # Scenario template

# ✅ RESPONSE CONTEXT TESTING
# Check what gets stored for other scenarios
And response context contains "profile_data"
And response context contains "user_preferences"
```

**Multi-Message Response Patterns**:

Real bots commonly return these patterns:
```gherkin
# Pattern 1: Information + Actions
# Message 1: Data/Information
# Message 2: Quick replies for next steps

# Pattern 2: Status + Result  
# Message 1: "Processing your request..."
# Message 2: Actual result

# Pattern 3: Result + System Warning
# Message 1: Your requested information
# Message 2: System connectivity notice

# ✅ WRITE TESTS FOR ACTUAL PATTERNS
Scenario: Typical info + actions pattern
  When I say "show my bookings"
  Then response has 2 messages
  And first message has type text
  And first message content contains "bookings"
  And second message has type quickReplies
  And second message content contains "buttons"
```

**Testing Edge Cases**:

```gherkin
# ✅ ERROR HANDLING TESTS
Scenario: API failure handling
  When I say "get data from broken service"
  Then response has 1 message
  And first message content contains "temporarily unavailable"

# ✅ EMPTY DATA TESTS
Scenario: No results found
  When I say "find nonexistent item"  
  Then response has 1 message
  And first message content contains "no results"

# ✅ PARAMETER EXTRACTION TESTS
Scenario: Missing required information
  When I say "book room"  # Missing hotel name, dates
  Then response has 1 message
  And first message content contains "need more information"
```

### Running Tests

```bash
# Run all tests
joule test <assistant_name>

# Run with specific tags
joule test <assistant_name> -t @weather

# Generate reports
joule test <assistant_name> -f "junit:reports/junit.xml"

# Run with custom timeout
joule test <assistant_name> --timeout 30000

# Use environment variables
joule test <assistant_name> --use-env
```

### Debug Mode

Enable debug mode in the Web Client to:
- View request logs
- Inspect response payloads
- Analyze dialog execution flow
- Troubleshoot scripting issues

---

## Deployment and Integration

### Digital Assistant Configuration

Create `da.sapdas.yaml` to assemble capabilities:

```yaml
schema_version: 1.3.0
name: MyDigitalAssistant
capabilities:
  - type: local
    folder: ./weather_capability
  - type: local
    folder: ./booking_capability
  - type: release
    namespace: com.sap.standard
    name: hr_capability
    version: 2.1.0
conversational_search:
  enabled: true
  product_filter:
    - SAP_SUCCESSFACTORS
    - SAP_S4HANA_CLOUD
systems:
  - system_name: Production
    system_type: sap.s4
    deployment_identifiers:
      - version: ['2023', '2024']
        license: ['standard', 'premium']
```

### Deployment Commands

```bash
# Deploy from DA config
joule deploy ./da.sapdas.yaml

# Deploy with custom name
joule deploy ./da.sapdas.yaml -n MyAssistant

# Deploy with compilation
joule deploy --compile ./da.sapdas.yaml

# Deploy precompiled artifacts
joule deploy ./da.sapdas.yaml --daars-input-dir ./compiled_capabilities
```

### Web Client Integration

**Script Integration**:
```html
<script
  src="<your_tenant_url>/resources/public/webclient/bootstrap.js"
  data-bot-name="MyAssistant"
  data-expander-type="DEFAULT">
</script>
```

**Dynamic Integration**:
```javascript
// Configure bridge
window.sapdas = window.sapdas || {};
window.sapdas.webclientBridge = {
  getClientInfo: () => ({
    locale: 'en-US',
    timezone: 'Europe/Berlin'
  }),
  
  getApplicationContext: () => ({
    app_title: 'My Application',
    'com.mycompany.context': {
      user_role: 'manager',
      department: 'sales'
    }
  })
};

// Load script dynamically
const script = document.createElement('script');
script.src = '<tenant_url>/resources/public/webclient/bootstrap.js';
script.setAttribute('data-bot-name', 'MyAssistant');
document.head.appendChild(script);
```

### Standalone Web Client

Access via URLs:
- Single assistant: `<tenant_url>/joule/<assistant_name>`
- Multiple assistants: `<tenant_url>/joule/<assistant1>,<assistant2>`
- With parameters: `<tenant_url>/joule?botnames=<assistant1>,<assistant2>`

---

## Advanced Features

### Internationalization (i18n)

**Setup Structure**:
```
capability/
├── i18n/
│   ├── messages.properties
│   ├── messages_en.properties
│   ├── messages_de.properties
│   └── messages_fr.properties
└── capability.sapdas.yaml
```

**Message Properties**:
```properties
# messages.properties
#XMSG, {0} is the user name, {1} is the date
WELCOME_MESSAGE=Welcome {0}! Today is {1}.

#XBUT,20
SAVE_BUTTON=Save

#XTIT
DASHBOARD_TITLE=User Dashboard
```

**Usage in Functions**:
```yaml
# Using SpEL
- type: message
  message:
    type: text
    content: "<? new i18n('WELCOME_MESSAGE', user.name, currentDate) ?>"

# Using Handlebars
- type: message
  scripting_type: handlebars
  message:
    type: text
    content: "{{i18n 'WELCOME_MESSAGE' user.name currentDate}}"
```

**Conversation Starters**:
```yaml
conversation_starter:
  title: $i18n.STARTER_TITLE
  trigger_utterance: $i18n.STARTER_UTTERANCE
```

### Scenario Dependencies

Link scenarios to create complex workflows:

```yaml
slots:
  - name: purchase_order_id
    description: ID of the purchase order
    sources:
      - type: scenario
        name: purchasing/find_purchase_order
        key: $target_result.order_id
      - type: scenario
        name: purchasing/create_purchase_order
        key: $target_result.new_order_id

  - name: supplier_id
    description: Supplier identifier
    sources:
      - type: scenario
        name: purchasing/select_supplier
        execution_group: order_details
        key: $target_result.supplier_id
```

### System Information and Filtering

**Deployment Conditions** (`deployment_extension.yaml`):
```yaml
deployment_conditions:
  capability_filter:
    match: ANY
    system_version: ['2023', '2024']
    region: ['US', 'EU']
  scenarios_filter:
    - name: ['advanced_scenario']
      match: ALL
      license_type: ['premium']
      feature_flag: ['advanced_features']
```

**System Context Usage**:
```yaml
- type: message
  message:
    type: text
    content: "Your system version is <? $system_context.version ?>"

- condition: "$system_context.region == 'EU'"
  actions:
    - type: message
      message:
        type: text
        content: "GDPR compliance enabled"
```

### **🔄 XML API Response Handling**

Many enterprise APIs return XML responses, requiring special handling in Joule functions. Based on real-world experience with Concur Travel Profile APIs and similar enterprise systems.

**Working Example - XML Profile API**:
```yaml
parameters:
  - name: login_id
    optional: true

action_groups:
  - actions:
      - type: api-request
        method: GET
        system_alias: ProfileAPI
        path: "/api/profile?userid=<? login_id ?>"
        timeout: 30
        result_variable: profile_response
      
  - condition: profile_response.status_code == 200
    actions:
      - type: set-variables
        variables:
          - name: xml_data
            value: "<? profile_response.body ?>"
          # XML presence checks (SpEL limitation workaround)
          - name: has_first_name
            value: "<? xml_data.contains('<FirstName>') ?>"
          - name: has_last_name
            value: "<? xml_data.contains('<LastName>') ?>"
          - name: has_preferences
            value: "<? xml_data.contains('<RoomType>') && xml_data.contains('<CarType>') ?>"

      - type: message
        message:
          type: text
          content: "📋 **Profile Data:**\n✅ XML Retrieved: <? xml_data.length() ?> chars\n🏷️ Has Name: <? has_first_name && has_last_name ?>\n🏨 Has Preferences: <? has_preferences ?>"

result:
  xml_data: "<? xml_data ?>"
  profile_available: "<? has_first_name ?>"
```

**🚨 CRITICAL SpEL Limitations for XML Processing**:

These string methods are **NOT AVAILABLE** in Joule SpEL (confirmed through testing):
```yaml
# ❌ FAILS - These methods cause runtime errors
variables:
  - name: extracted_value
    value: "<? xml_data.indexOf('<tag>') ?>"     # Method not found
  - name: parsed_field  
    value: "<? xml_data.substring(10, 20) ?>"    # Method not found
  - name: split_result
    value: "<? xml_data.split(',') ?>"           # Method not found
  - name: regex_match
    value: "<? xml_data.matches('pattern') ?>"   # Limited regex support
```

**✅ Available String Methods in Joule SpEL** (tested and confirmed):
```yaml
variables:
  - name: contains_check
    value: "<? xml_data.contains('<FirstName>John</FirstName>') ?>"  # ✅ Works
  - name: length_check
    value: "<? xml_data.length() ?>"                                 # ✅ Works
  - name: empty_check
    value: "<? xml_data.isEmpty() ?>"                                # ✅ Works
  - name: case_operations
    value: "<? xml_data.toLowerCase() ?>"                            # ✅ Works
  - name: case_operations2
    value: "<? xml_data.toUpperCase() ?>"                            # ✅ Works
```

**XML Parsing Strategies**:

1. **Complete Tag Pattern Matching** (Most Reliable):
```yaml
# Check for specific complete tag values - most reliable approach
variables:
  - name: is_king_room
    value: "<? xml_data.contains('<RoomType>King</RoomType>') ?>"
  - name: is_economy_car
    value: "<? xml_data.contains('<CarType>Economy</CarType>') ?>"
  - name: is_window_seat
    value: "<? xml_data.contains('<InterRowPositionCode>Window</InterRowPositionCode>') ?>"
```

2. **Multi-Value Conditional Parsing**:
```yaml
# Handle multiple possible values with nested conditionals
variables:
  - name: room_preference
    value: "<? xml_data.contains('<RoomType>King</RoomType>') ? 'King' : (xml_data.contains('<RoomType>Queen</RoomType>') ? 'Queen' : (xml_data.contains('<RoomType>Double</RoomType>') ? 'Double' : 'Not specified')) ?>"
```

3. **Section Presence Detection**:
```yaml
# Check if entire XML sections exist
variables:
  - name: has_travel_prefs
    value: "<? xml_data.contains('<Hotel>') && xml_data.contains('<Car>') && xml_data.contains('<Air>') ?>"
  - name: has_contact_info
    value: "<? xml_data.contains('<EmailAddresses>') && xml_data.contains('<Telephones>') ?>"
```

4. **Variable Scoping for Error Handling** (Critical Learning):
```yaml
action_groups:
  # ✅ ALWAYS initialize ALL result variables at start
  - actions:
      - type: set-variables
        variables:
          - name: update_status
            value: "not_started"
          - name: response_body
            value: ""
          - name: error_message
            value: ""
          - name: success_message
            value: ""
          - name: has_success_code
            value: false

  # API call group
  - condition: "some_condition"
    actions:
      - type: api-request
        # ... api call details
        result_variable: api_response

  # ✅ Handle ALL possible response scenarios
  - condition: "api_response != null && api_response.status_code != 200"
    actions:
      - type: set-variables
        variables:
          - name: update_status
            value: "error"
          - name: error_message
            value: "<? 'API Error: ' + api_response.status_code ?>"

  - condition: "api_response != null && api_response.status_code == 200"
    actions:
      - type: set-variables
        variables:
          - name: update_status
            value: "success"
          - name: response_body
            value: "<? api_response.body ?>"

# ✅ Result section references all initialized variables
result:
  update_status: "<? update_status ?>"
  response_body: "<? response_body ?>"
  error_message: "<? error_message ?>"
  api_status: "<? api_response != null ? api_response.status_code : 0 ?>"
```

**Real-World XML API Update Example**:
```yaml
# Working example for XML API updates (like Concur Travel Profile)
action_groups:
  - actions:
      # Initialize all variables first
      - type: set-variables
        variables:
          - name: target_login_id
            value: "<? login_id != null ? login_id : 'default@company.com' ?>"
          - name: xml_body
            value: ""
          - name: update_status
            value: "not_started"

  # Generate simple XML (avoid complex SpEL concatenation)
  - condition: "update_type.toLowerCase().contains('hotel')"
    actions:
      - type: set-variables
        variables:
          - name: xml_body
            value: "<?xml version=\"1.0\" encoding=\"utf-8\"?><ProfileResponse xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" Action=\"Update\" LoginId=\"default@company.com\"><Hotel><RoomType>King</RoomType></Hotel></ProfileResponse>"
      
      - type: api-request
        method: POST
        system_alias: ProfileAPI
        path: "/api/travelprofile/v2.0/profile"
        headers:
          Content-Type: "application/xml"
          Accept: "application/xml"
        body: "<? xml_body ?>"
        timeout: 30
        result_variable: update_response

  # Handle response in all scenarios
  - condition: "update_response != null"
    actions:
      - type: set-variables
        variables:
          - name: response_body
            value: "<? update_response.body != null ? update_response.body : '' ?>"
          - name: has_success_code
            value: "<? response_body.contains('S001') || response_body.contains('Success') ?>"
```

**Alternative Approaches for Complex XML**:
- **External Service**: Create a microservice that converts XML to JSON before Joule processing
- **API Wrapper**: Use an intermediary service that handles XML parsing and returns JSON
- **Multiple Endpoints**: Design APIs with both XML and JSON response options
- **Handlebars Scripting**: For complex string operations, consider `scripting_type: handlebars` but test thoroughly

**XML Response Gotchas (Learned from Production)**:
- ❌ Don't use `indexOf()`, `substring()`, or `split()` - **NOT available in Joule SpEL**
- ❌ Avoid complex regex operations - limited regex support in SpEL
- ❌ Don't assume variable scope - initialize ALL result variables in first action group
- ✅ Use `contains()` for checking complete tag patterns like `<RoomType>King</RoomType>`
- ✅ Use `length()` for data size validation and basic presence checks  
- ✅ Pre-validate XML structure with presence checks before content extraction
- ✅ Return raw XML in results for external processing if complex parsing needed
- ✅ Test XML generation with hardcoded values first, then add variable substitution
- ✅ Handle ALL possible API response scenarios in separate action groups

### Long Running Operations

**Status Updates**:
```yaml
action_groups:
  - actions:
      - type: status-update
        message: "Searching for available flights..."
      
      - type: api-request
        method: GET
        system_alias: FlightService
        path: /search?destination=<? destination ?>
        timeout: 30
        result_variable: flight_results
      
      - type: status-update
        message: "Processing booking options..."
      
      - type: api-request
        method: POST
        system_alias: BookingService
        path: /reserve
        body: <? flight_results.selected_flight ?>
        result_variable: booking_result
```

### Streaming Responses

**Server-Sent Events**:
```yaml
- type: streamed-message
  method: GET
  system_alias: AIService
  path: /generate-response
  headers:
    Accept: "text/event-stream"
    Connection: "keep-alive"
    Cache-Control: "no-cache"
  body: <? user_query ?>
  response_chunk_ref: "$.content"
  result_variable: ai_response
```

---

## Best Practices and Guidelines

### Capability Design

1. **Scenario Descriptions**:
   - Use natural, simple English
   - Be specific and precise (2-4 sentences, max 1000 characters)
   - Include relevant keywords
   - Avoid personal pronouns (you, I)
   - Don't mention limitations or other features

2. **Function Organization**:
   - One function per business operation
   - Clear parameter definitions
   - Proper error handling
   - Efficient API usage

3. **Message Design**:
   - Use formal tone across languages
   - Keep messages concise and actionable
   - Provide clear navigation options
   - Support both web and mobile platforms

### Security Guidelines

1. **Input Validation**:
   - Validate user inputs before processing
   - Sanitize data from external sources
   - Use conditions to prevent malicious inputs

2. **Output Encoding**:
   - URL encode for query parameters
   - Escape special characters in JSON/XML
   - Use proper encoding for different contexts

3. **Information Disclosure**:
   - Never expose technical secrets
   - Minimize sensitive data in results
   - Control data flow between functions

### Performance Optimization

1. **API Usage**:
   - Implement timeout configurations (1-45 seconds)
   - Use batch operations when possible
   - Cache frequently accessed data

2. **Response Time**:
   - Keep initialization functions under 500ms
   - Use status updates for operations > 10 seconds
   - Optimize dialog function chains

3. **Resource Management**:
   - Follow file size limits (50KB for most files)
   - Limit scenario count (200 per capability)
   - Manage function complexity (500 functions max)

### Cross-Platform Compatibility

**Supported Features Matrix**:
- Text, Cards, Buttons, Quick Replies: ✅ Web, iOS, Android
- Carousel, Standard List: ✅ Web, iOS, Android (JMC 25.1+)
- List in Panel: ✅ Web, ❌ Mobile (coming 2025)
- Adaptive Cards: ✅ Web, ❌ Mobile
- UI Integration Cards: ✅ Web, ✅ Mobile (limited types)

**Responsive Design**:
- Use Object Cards instead of Adaptive Cards for mobile compatibility
- Ensure all URLs are HTTPS and mobile-responsive
- Test on both web and mobile platforms
- Provide alternative flows for platform-specific limitations

---

## Common Issues and Gotchas

### 🚨 **Critical Schema Version Issues**

**Problem**: Deployment fails with "Unsupported schema version" errors
```bash
Error: Schema version 3.12.0 is not supported in this environment
Error: Schema version 3.8.0 is not supported in this environment
```

**Solution Strategy**:
1. **Always start with 3.7.0** for staging environments
2. **Copy from working examples** rather than using latest documentation
3. **Test incrementally** - don't assume latest = supported

**Environment Compatibility Matrix**:
| Environment | Safe Version | Tested Version | Latest Supported |
|-------------|--------------|----------------|------------------|
| **Staging** | 3.6.0 | **3.7.0** ✅ | 3.9.0 |
| **Production** | 3.7.0 | 3.10.0 | 3.12.0 |
| **Development** | 3.5.0 | 3.7.0 | 3.12.0 |

---

### 🔧 **SpEL Expression Language Gotchas**

**Problem**: Complex SpEL expressions causing compilation failures
```yaml
# ❌ FAILS - Complex array operations
variables:
  - name: random_joke
    value: <? new java.lang.String[]{"joke1", "joke2"}[random_index] ?>
```

**Root Cause**: Joule's SpEL implementation has limitations on:
- Complex array instantiation
- Nested conditional operations  
- Multi-line expressions
- Advanced Java method calls

**Solutions**:
```yaml
# ✅ WORKS - Simple conditional
variables:
  - name: selected_joke
    value: "<? random_number == 0 ? 'Why don't scientists trust atoms? Because they make up everything!' : 'How do you organize a space party? You planet!' ?>"

# ✅ WORKS - Single hardcoded value (simplest)
variables:
  - name: joke_content
    value: "Why don't scientists trust atoms? Because they make up everything!"

# ✅ WORKS - i18n approach (recommended)
content: "<? new i18n('JOKE_CONTENT') ?>"
```

### **🔤 SpEL String Method Limitations**

**Problem**: String parsing methods causing runtime failures
```yaml
# ❌ FAILS - These string methods are NOT available in Joule SpEL
variables:
  - name: extracted_value
    value: "<? xml_data.indexOf('<tag>') ?>"  # Method not found
  - name: parsed_field
    value: "<? xml_data.substring(10, 20) ?>"  # Method not found
  - name: split_result
    value: "<? xml_data.split(',') ?>"  # Method not found
```

**Root Cause**: Joule's SpEL context has limited string manipulation methods available.

**Available String Methods**:
```yaml
# ✅ WORKS - Available string methods in Joule SpEL
variables:
  - name: contains_check
    value: "<? xml_data.contains('<FirstName>') ?>"  # Boolean check
  - name: length_check
    value: "<? xml_data.length() ?>"  # Character count
  - name: empty_check
    value: "<? xml_data.isEmpty() ?>"  # Empty string check
  - name: case_operations
    value: "<? xml_data.toLowerCase() ?>"  # Case conversion
```

**XML Parsing Workarounds**:
```yaml
# ✅ PATTERN MATCHING - Use specific value checks
variables:
  - name: room_type
    value: "<? xml_data.contains('<RoomType>King</RoomType>') ? 'King' : (xml_data.contains('<RoomType>Queen</RoomType>') ? 'Queen' : 'Unknown') ?>"

# ✅ BOOLEAN FLAGS - Check for presence of data
variables:
  - name: has_preferences
    value: "<? xml_data.contains('<RoomType>') && xml_data.contains('<CarType>') ?>"

# ✅ EXTERNAL PARSING - Use API endpoint that returns JSON instead of XML
# Call a service that converts XML to JSON before returning to Joule
```

**Best Practices for Complex Parsing**:
1. **Pre-process data**: Use external services to convert XML to JSON
2. **Pattern matching**: Use `contains()` with complete tag patterns
3. **Boolean checks**: Check for data presence rather than extracting values
4. **API design**: Design APIs to return JSON when possible
5. **Multiple calls**: Break complex parsing into multiple function calls

**SpEL Best Practices**:
- **Always use double quotes**: `"<? expression ?>"`
- **Keep expressions simple**: Single-line, basic operations only
- **Test string methods**: Verify method availability before deployment
- **Prefer i18n**: Use `new i18n()` instead of complex string manipulation
- **Test incrementally**: Compile after each SpEL change

---

### 📁 **File Structure and Naming Issues**

**Problem**: Capability not found or compilation errors due to incorrect structure

**Critical Requirements**:
```
capability/
├── scenarios/           # ✅ MUST be exact name
│   └── *.yaml          # ✅ Individual files, not nested
├── functions/           # ✅ MUST be exact name  
│   └── *.yaml          # ✅ Individual files, not nested
├── i18n/               # ✅ MUST be exact name
│   └── messages.properties  # ✅ MUST be exact name
└── capability.sapdas.yaml   # ✅ MUST be exact name
```

**Common Mistakes**:
```
❌ scenario/ (singular)
❌ function/ (singular)  
❌ Messages.properties (wrong case)
❌ capability.yaml (missing .sapdas)
❌ nested folders in scenarios/functions
```

---

### 🌐 **i18n Implementation Gotchas**

**Problem**: "Unused i18n keys" warnings or missing internationalization

**Required Setup**:
```properties
# i18n/messages.properties - EXACT filename required
GREETING_WITH_NAME=Hello {0}! Welcome to our simple Joule bot!
GREETING_GENERAL=Hello there! Welcome to our simple Joule bot!
WHAT_CAN_I_DO=What would you like to do?
```

**Usage in Functions**:
```yaml
# ✅ CORRECT - i18n with parameters
content: "<? new i18n('GREETING_WITH_NAME', user_name) ?>"

# ✅ CORRECT - i18n without parameters  
content: "<? new i18n('GREETING_GENERAL') ?>"

# ❌ WRONG - Direct string (not localizable)
content: "Hello there! Welcome to our simple Joule bot!"
```

**i18n Gotchas**:
- **Exact key matching**: Key names are case-sensitive
- **Parameter order**: {0}, {1}, {2} must match function call order
- **No unused keys**: Remove any keys not referenced in functions

---

### 🔄 **Response Context Configuration**

**Problem**: Compilation warnings about response context prefixes

```yaml
# ❌ GENERATES WARNINGS
response_context:
  - value: greeting
  - value: user_name

# ✅ CORRECT - Use $target_result prefix
response_context:
  - value: $target_result.greeting
    description: The personalized greeting message
  - value: $target_result.user_name  
    description: The user's name if provided
```

**Why This Matters**: Proper response context enables:
- Cross-scenario data sharing
- Testing validation
- Debug visibility

---

### 🚀 **Deployment and Testing Issues**

**Problem**: Tests failing but bot actually working correctly

**Common Test Misunderstandings**:
```gherkin
# ❌ TEST EXPECTS 1 MESSAGE
When I say "Hello"
Then response has 1 message

# ✅ ACTUAL BOT BEHAVIOR (BETTER UX)
# Returns 2 messages:
# 1. Greeting text
# 2. Quick reply buttons
```

**Test Framework Limitations**:
- **Button clicks**: `When I click button "Text"` not supported in CLI
- **Card content**: Complex message types need special handling
- **Response structure**: quickReplies content is object, not string

**Testing Best Practices**:
```gherkin
# ✅ REALISTIC TESTS
Scenario: Basic greeting produces two messages
  When I say "Hello"
  Then response has 2 messages
  And first message has type text
  And second message has type quickReplies

# ✅ CONTENT VALIDATION
Scenario: Personalized greeting works  
  When I say "Hello, I'm Sarah"
  Then first message content contains "Sarah"
```

---

### 💾 **DA Configuration Issues - CRITICAL DEPLOYMENT GOTCHAS**

**Problem**: Digital Assistant deployment failures

**🚨 CRITICAL**: DA File Naming and Placement Requirements

The CLI has strict requirements for DA file naming and placement:

**1. File Naming Gotcha**:
```bash
# ❌ FAILS - CLI expects exact naming convention
joule deploy --compile ./concur-profile-da.sapdas.yaml
# Error: "invalid source - should end with da.sapdas.yaml"

# ✅ WORKS - File must end with exactly "da.sapdas.yaml"
joule deploy --compile ./da.sapdas.yaml
```

**2. DA File Placement Options**:

**Option A: DA at Project Root** (Traditional approach):
```
project-root/
├── da.sapdas.yaml          # ✅ DA file at PROJECT ROOT
└── my-capability/          # ✅ Capability folder referenced by DA
    ├── capability.sapdas.yaml
    ├── functions/
    └── scenarios/
```

**Option B: DA Inside Capability** (Alternative that works):
```
my-capability/
├── da.sapdas.yaml          # ✅ ALSO WORKS - Deploy from capability dir
├── capability.sapdas.yaml
├── functions/
└── scenarios/

# Deploy with: cd my-capability && joule deploy --compile ./da.sapdas.yaml
```

**❌ WRONG STRUCTURES that cause "missed required fields: name"**:
```
❌ Named: custom-name-da.sapdas.yaml  # Must end with da.sapdas.yaml
❌ Missing name field in DA content
❌ Wrong schema version for DA (use 1.0.0, not capability schema)
❌ Capability content in DA file (see content structure gotcha below)
```

**3. DA File Content Structure Gotcha**:

**❌ WRONG - Capability configuration in da.sapdas.yaml**:
```yaml
# da.sapdas.yaml - INCORRECT CONTENT
schema_version: 3.10.0    # ❌ Capability schema version
metadata:                 # ❌ Capability structure
  namespace: com.sap.concur
  name: concur_profile_bot
system_aliases:           # ❌ Belongs in capability.sapdas.yaml
  ConcurAPI:
    destination: TEST
```

**✅ CORRECT - DA configuration in da.sapdas.yaml**:
```yaml
# da.sapdas.yaml - CORRECT CONTENT
schema_version: 1.0.0     # ✅ DA schema version
name: ConcurProfileAssistant # ✅ DA structure
capabilities:             # ✅ DA structure
  - type: local
    folder: .
```

**✅ Capability configuration belongs in capability.sapdas.yaml**:
```yaml
# capability.sapdas.yaml - CORRECT LOCATION
schema_version: 3.7.0     # ✅ Capability schema version
metadata:                 # ✅ Capability structure
  namespace: com.sap.concur
  name: concur_profile_bot
system_aliases:           # ✅ Belongs here
  ConcurAPI:
    destination: TEST
```

**Critical DA File Requirements**:
```yaml
# da.sapdas.yaml - EXACT filename required, must be at project root
schema_version: 1.0.0  # ✅ DA schema (not capability schema)
name: SimpleGreetingAssistantV2  # ✅ Unique name
capabilities:
  - type: local  # ✅ For local development
    folder: ./simple-greeting-bot  # ✅ Relative path to capability folder
```

**Real-World Deployment Workflows**:
```bash
# ✅ OPTION 1: From project root with DA at root
cd /path/to/project-root/
joule deploy --compile ./da.sapdas.yaml

# ✅ OPTION 2: From capability directory with local DA
cd /path/to/project-root/my-capability/
joule deploy --compile ./da.sapdas.yaml

# ❌ WRONG: Custom-named DA file
joule deploy --compile ./concur-profile-da.sapdas.yaml
# Error: "invalid source - should end with da.sapdas.yaml"

# ❌ WRONG: Missing required DA fields
joule deploy --compile ./da.sapdas.yaml  
# Error: "missed required fields: name" (if DA structure is invalid)
```

**Common DA Mistakes That Cause "missed required fields: name" Error**:
```yaml
❌ DA file inside capability folder
❌ schema_version: 3.7.0  # Wrong - that's capability schema
❌ name: "Simple Bot"     # Spaces can cause issues
❌ folder: /absolute/path  # Use relative paths
❌ type: remote           # Use 'local' for development
❌ folder: .              # Wrong when DA is in capability folder
```

**Error Resolution Examples**:
```bash
# Error: "missed required fields: name"
# Solution: Move DA file to parent directory and fix folder reference

# From this:
my-capability/da.sapdas.yaml with folder: .

# To this:  
project-root/da.sapdas.yaml with folder: ./my-capability
```

---

### 🔍 **Development Workflow Gotchas**

**Problem**: Inefficient development cycles and debugging

**Proven Workflow**:
1. **Copy working examples** (`joule-examples`) ✅
2. **Modify incrementally** - one file at a time ✅
3. **Compile frequently** - catch errors early ✅
4. **Use simple SpEL first** - complex later ✅
5. **Test with simple scenarios** - expand gradually ✅

**Anti-Patterns to Avoid**:
```bash
❌ joule deploy --compile ./complex-bot  # Big bang approach
❌ Complex SpEL expressions from start
❌ No incremental testing
❌ Latest schema version without checking
```

**Recommended Development Cycle**:
```bash
# 1. Start simple
joule compile ./simple-bot ./output
# Fix any errors immediately

# 2. Deploy and test basic functionality  
joule deploy --compile ./da.sapdas.yaml
joule test <assistant_name>

# 3. Add complexity incrementally
# Edit one function → compile → test → repeat
```

---

### 📊 **Performance and Resource Limits**

**File Size Limits**:
- YAML files: 50KB maximum
- Total scenarios: 200 per capability
- Total functions: 500 per capability
- Nesting depth: 3 levels maximum

**Performance Gotchas**:
- **Initialization functions**: Must complete < 500ms
- **API timeouts**: Configure 1-45 seconds explicitly
- **Long operations**: Use status updates for >10 seconds

---

### 🛠️ **CLI and Environment Setup Issues**

**Problem**: CLI authentication or command failures

**Common CLI Issues**:
```bash
# ❌ Wrong registry
npm install -g @sap/sapdas-cli

# ✅ Correct registry  
npm install -g @sap/sapdas-cli --registry=https://int.repositories.cloud.sap/artifactory/api/npm/build-releases-npm

# ❌ Running tests from wrong directory
joule test <assistant> # From project root

# ✅ Run from capability directory or specify path
cd capability-folder && joule test <assistant>
```

**Environment Variables Setup**:
```bash
# Create .env file in project root
JOULE_API_URL=<your_tenant_url>
JOULE_USERNAME=<username>
JOULE_PASSWORD=<password>
JOULE_AUTH_URL=<auth_url>
JOULE_CLIENT_ID=<client_id>
JOULE_CLIENT_SECRET=<client_secret>
```

---

### 💡 **Quick Resolution Checklist**

When something breaks, check these in order:

1. **DA File Naming & Structure** ✅ 
   - File must end with exactly "da.sapdas.yaml"
   - Not "custom-name-da.sapdas.yaml"
   - Must contain DA config (name, capabilities) not capability config (metadata)
   - Deploy from capability dir if DA is there

2. **Schema Version** ✅ 
   - Try 3.7.0 for staging
   - Check joule-examples for reference

3. **File Structure** ✅
   - Exact folder names: scenarios/, functions/, i18n/
   - Exact filenames: capability.sapdas.yaml, messages.properties

4. **SpEL Expressions** ✅  
   - Use double quotes: `"<? expression ?>"`
   - Keep expressions simple
   - Test one at a time
   - **CRITICAL**: `indexOf()` and `substring()` NOT available

5. **XML Response Handling** ✅
   - Use `contains()` for pattern matching
   - Use `length()` for size validation
   - No complex string parsing in SpEL
   - Consider external service for complex XML parsing

6. **i18n Setup** ✅
   - All messages in properties file
   - Correct key references in functions
   - No unused keys

7. **DA Configuration** ✅
   - Schema version 1.0.0 for DA
   - Relative paths to capabilities
   - Unique assistant name

Following this checklist resolves 95% of common Joule development issues.

---

## Troubleshooting

### ⚡ **Quick Diagnostic Commands**

Start troubleshooting with these commands to identify the issue:

```bash
# Check your login status and environment
joule status

# Verify CLI version and registry
npm list -g @sap/sapdas-cli

# Test compilation without deployment
joule compile ./capability ./output

# Check deployed assistants
joule list

# Get detailed assistant information
joule get <assistant_name>
```

### 🚨 **Schema Version Errors**

**Error Messages**:
```
Error: Schema version 3.12.0 is not supported in this environment
Error: Unsupported schema version
```

**Diagnostic Steps**:
1. Check your environment type (staging/production/development)
2. Look at working examples in your environment
3. Try progressively lower schema versions

**Solutions**:
```yaml
# Try these versions in order:
schema_version: 3.7.0   # ✅ Most compatible
schema_version: 3.6.0   # ✅ Very stable  
schema_version: 3.10.0  # ✅ Production only
```

### 🔧 **Compilation Errors**

**Error: Invalid file structure**
```bash
# Check exact folder structure
ls -la capability/
# Must have: scenarios/, functions/, i18n/, capability.sapdas.yaml
```

**Error: YAML validation failed**
```bash
# Check YAML syntax - common issues:
❌ Indentation problems (use 2 spaces)
❌ Missing quotes around SpEL: <? expression ?>
❌ Complex SpEL expressions

# Fix with simple SpEL:
content: "<? new i18n('MESSAGE_KEY') ?>"
```

**Error: Missing system alias**
```yaml
# Add to capability.sapdas.yaml if using API calls:
system_aliases:
  ExternalAPI:
    destination: API_Destination
```

**Error: i18n key not found**
```properties
# Ensure all keys referenced in functions exist in messages.properties
# Check for:
❌ Typos in key names
❌ Case sensitivity issues  
❌ Missing {0}, {1} parameter placeholders
```

### 🚀 **Deployment Issues**

**Error: Invalid source - should end with da.sapdas.yaml**
```bash
# Problem: Custom-named DA file
❌ joule deploy --compile ./concur-profile-da.sapdas.yaml
❌ joule deploy --compile ./my-custom-da.sapdas.yaml

# Solution: Rename file to end with exactly "da.sapdas.yaml"
✅ mv concur-profile-da.sapdas.yaml da.sapdas.yaml
✅ joule deploy --compile ./da.sapdas.yaml

# OR deploy from capability directory if DA is there
✅ cd capability-folder && joule deploy --compile ./da.sapdas.yaml
```

**Error: missed required fields: name**
```bash
# Problem: Wrong configuration structure in da.sapdas.yaml
❌ # da.sapdas.yaml contains capability config instead of DA config
   schema_version: 3.10.0
   metadata:
     namespace: com.sap.concur

# Solution: Use correct DA structure
✅ # da.sapdas.yaml should contain:
   schema_version: 1.0.0
   name: MyAssistantName
   capabilities:
     - type: local
       folder: .

# Move capability config to capability.sapdas.yaml
✅ # metadata, system_aliases belong in capability.sapdas.yaml
```

**Error: Assistant name conflict**
```bash
# Solutions:
joule deploy -n UniqueAssistantName ./da.sapdas.yaml
# OR update name in da.sapdas.yaml
```

**Error: Role permissions**
```
Required roles:
- capability_developer: For compilation and basic access
- capability_release_admin: For deployment
- end_user: For Web Client access
```

**Error: File size exceeded**
```bash
# Check file sizes (50KB limit for YAML):
find . -name "*.yaml" -exec du -h {} \;

# Solutions:
- Split large functions into smaller ones
- Move complex logic to external services
- Simplify SpEL expressions
```

**Error: DA configuration issues**
```yaml
# Common da.sapdas.yaml fixes:
schema_version: 1.0.0  # ✅ DA schema (not capability schema)
name: MyUniqueAssistant
capabilities:
  - type: local         # ✅ For development
    folder: ./capability # ✅ Relative path to capability folder
```

### 🧪 **Testing Issues**

**Problem: Tests failing but bot works**

This is common! Test failures often indicate test limitations, not bot issues.

**Diagnostic approach**:
```bash
# 1. Manual test first
joule launch <assistant_name>
# Try: "Hello", "Tell me a joke", "Help"

# 2. Check what bot actually returns
joule test <assistant> --verbose

# 3. Adjust tests to match actual (better) behavior
```

**Common test adjustments needed**:
```gherkin
# ❌ UNREALISTIC TEST - Expects only greeting
When I say "Hello"
Then response has 1 message

# ✅ REALISTIC TEST - Adjust expectations
When I say "Hello"
Then response has 2 messages
And first message has type text
And first message content contains "Hello"
And second message has type quickReplies
```

**Button click limitations**:
```gherkin
# ❌ Not supported in CLI testing
When I click button "Text"

# ✅ Test button presence instead
And second message content contains "Get Help"
```

### 🔍 **Runtime Errors**

**Error: Function timeout**
```yaml
# Add explicit timeout to API requests:
- type: api-request
  timeout: 30  # seconds (max 45)
  method: GET
```

**Error: Scenario not found**
```bash
# Verify scenario file structure:
scenarios/
├── hello_world.yaml  # ✅ In scenarios folder
├── tell_joke.yaml    # ✅ YAML extension
└── show_help.yaml    # ✅ Valid YAML syntax
```

**Error: Authentication failed**
```bash
# Re-authenticate:
joule logout
joule login

# Check environment variables:
echo $JOULE_API_URL
echo $JOULE_USERNAME
```

**Error: SpEL evaluation failed**
```yaml
# Debug SpEL expressions step by step:

# ✅ Start simple:
content: "Hello World"

# ✅ Add basic SpEL:  
content: "<? new i18n('GREETING') ?>"

# ✅ Add variables gradually:
content: "<? new i18n('GREETING_WITH_NAME', user_name) ?>"
```

### 🛠️ **Debug Techniques**

**1. Web Client Debug Mode**
- Enable debug view (requires `capability_developer` role)
- Check request logs for execution flow
- Inspect response payloads
- Analyze SpEL expression results

**2. CLI Debug Options**
```bash
# Generate debug compilation files
joule compile -d ./capability ./output

# Detailed test reporting
joule test <assistant> -f "html:reports/test-report.html"

# Verbose test output
joule test <assistant> --verbose
```

**3. Incremental Testing Strategy**
```bash
# Test each component individually:
# 1. Compile only
joule compile ./capability ./test-output

# 2. Deploy without testing
joule deploy --compile ./da.sapdas.yaml

# 3. Manual interaction test
joule launch <assistant>

# 4. Automated testing
joule test <assistant>
```

### 📊 **Performance Monitoring**

**Key Metrics to Watch**:
- Response time < 10 seconds for normal operations
- Initialization time < 500ms
- Compile time < 30 seconds
- Test execution time

**Performance Issues**:
```yaml
# ❌ Slow initialization
initialize:
  - type: api-request  # Avoid heavy API calls in init

# ✅ Optimized approach
action_groups:
  - actions:
    - type: status-update
      message: "Loading..."
    - type: api-request  # API calls in main flow
```

**Resource Usage Checklist**:
- [ ] YAML files under 50KB each
- [ ] Scenarios count under 200
- [ ] Functions count under 500
- [ ] API timeouts configured (1-45 seconds)
- [ ] Status updates for long operations (>10 seconds)

### 🆘 **When to Get Help**

**Self-Service First**:
1. Check this troubleshooting guide ✅
2. Review working examples (`joule-examples`) ✅
3. Test with simplified version ✅
4. Search error messages in SAP Community ✅

**Internal Support Channels**:
- **CLI Issues**: CA-JOULE-CLI component
- **Runtime Issues**: CA-JOULE-CR component  
- **Translation Issues**: DL GLO LX internationalization enablement

**Documentation Resources**:
- Design Time Artifact Specification
- Web Client Development Guide
- SAP Help Portal for Joule

**Community Resources**:
- SAP Community forums
- Developer documentation on SAP Help Portal
- Sample capabilities and templates

### 🎯 **Prevention Best Practices**

**Development Workflow**:
1. **Start with examples** - Copy from `joule-examples` ✅
2. **Use proven schema versions** - 3.7.0 for staging ✅
3. **Test incrementally** - Compile after each change ✅
4. **Keep SpEL simple** - Use i18n instead of complex expressions ✅
5. **Follow naming conventions** - Exact folder/file names ✅

**Code Quality**:
- Use consistent indentation (2 spaces)
- Quote all SpEL expressions: `"<? expression ?>"`  
- Implement proper error handling
- Add timeouts to all API calls
- Include status updates for long operations

**Testing Strategy**:
- Manual test before automated tests
- Write realistic test expectations
- Test edge cases (empty inputs, errors)
- Verify on both web and mobile platforms

Following these practices prevents 95% of common issues and makes debugging much faster when problems do occur.

---

### 🎭 **Scenario Configuration Gotchas**

**Problem**: Scenarios not triggering or returning 0 messages in tests

**Root Cause**: Missing or incorrect scenario configuration components

**Critical Scenario Requirements**:

**1. Sample Utterances** (REQUIRED for triggering):
```yaml
# ❌ MISSING SAMPLES - Scenario won't trigger
description: This function helps users update travel preferences

slots:
  - name: update_type
target:
  type: function
  name: update_travel_preferences
# ❌ NO SAMPLES = NO TRIGGERING

# ✅ WITH SAMPLES - Scenario triggers correctly
description: This function helps users update travel preferences

samples:
  - "Update my hotel preferences to King room"
  - "Change my seat preference to Window"
  - "Update my car preference to Economy"
  - "Set my room type to Queen"
  - "Change my seat to Aisle"
  - "Update hotel preferences"
  - "Change air travel preferences"
  - "Update car rental preferences"

slots:
  - name: update_type
    description: Type of preference to update
target:
  type: function
  name: update_travel_preferences
```

**2. Message Actions** (REQUIRED for user response):
```yaml
# ❌ NO MESSAGE ACTIONS - Function runs but user sees nothing
target:
  type: function
  name: update_travel_preferences

response_context:
  - value: $target_result.update_status
    description: Update operation status

# ❌ RESULT: Function executes, returns data to context, but NO user message

# ✅ WITH MESSAGE ACTIONS - User gets feedback
target:
  type: function
  name: update_travel_preferences

actions:
  - type: message
    text: |
      ✅ **Travel Preferences Updated**
      
      **Status:** $target_result.update_status
      **Details:** $target_result.response_summary
      
      Your travel preferences have been successfully updated in the system.

response_context:
  - value: $target_result.update_status
    description: Update operation status
```

**3. Response Context Configuration**:
```yaml
# ❌ INVALID RESPONSE CONTEXT - Compilation warnings
response_context:
  - value: update_status         # Missing $target_result prefix
  - value: response_data         # No description
  - value: some_undefined_var    # Variable doesn't exist in function result

# ✅ CORRECT RESPONSE CONTEXT
response_context:
  - value: $target_result.update_status
    description: Status of the travel preference update
  - value: $target_result.response_summary  
    description: Summary of changes made
  - value: $target_result.api_status
    description: API response status code
  # ✅ Must match function result variables exactly
```

**Complete Working Scenario Example**:
```yaml
description: This function updates specific types of travel profile information such as air travel preferences, hotel preferences, or car rental preferences based on user requests

samples:
  - "Update my hotel preferences to King room"
  - "Change my seat preference to Window"
  - "Update my car preference to Economy"
  - "Set my room type to Queen"
  - "Change my seat to Aisle"
  - "Update hotel preferences"
  - "Change air travel preferences"
  - "Update car rental preferences"
  - "Set seat preference to Window"
  - "Change room type to King"
  - "Update my travel preferences"

slots:
  - name: login_id
    description: The login ID of the user whose preferences to update
  - name: update_type
    description: Type of travel preference to update (hotel, air, car)
  - name: seat_preference
    description: Preferred seat type (Window, Aisle, Middle)
  - name: room_type
    description: Preferred hotel room type (King, Queen, Double)
  - name: car_type
    description: Preferred car rental type (Economy, Compact, Full-size)

target:
  type: function
  name: update_travel_preferences

actions:
  - type: message
    text: |
      ✅ **Travel Preferences Updated Successfully**
      
      **Update Type:** $target_result.update_type_request
      **Status:** $target_result.update_status
      
      $target_result.success_message
      
      Your changes have been saved to your travel profile.

response_context:
  - value: $target_result.update_status
    description: Status of preference update operation
  - value: $target_result.update_type_request
    description: Type of preference that was updated
  - value: $target_result.login_id
    description: User login ID for the update
  - value: $target_result.api_status
    description: API response status code
```

**Common Scenario Mistakes**:

**Sample Utterance Issues**:
```yaml
# ❌ TOO FEW SAMPLES
samples:
  - "update preferences"  # Only 1 sample = poor matching

# ✅ VARIED SAMPLES (8-12 recommended)
samples:
  - "Update my hotel preferences"
  - "Change travel settings"
  - "Modify my travel profile"
  - "Set new travel preferences"
  - "Update hotel room type"
  - "Change seat preference"
  - "Modify car rental settings"
  - "Update air travel preferences"

# ❌ TOO SIMILAR SAMPLES
samples:
  - "Update preferences"
  - "Update my preferences"
  - "Update the preferences"  # All too similar

# ✅ DIVERSE PHRASINGS
samples:
  - "Update my hotel preferences"
  - "Change my travel settings"
  - "Modify room type"
  - "Set new seat preference"
```

**Message Action Issues**:
```yaml
# ❌ STATIC MESSAGE - No function data
actions:
  - type: message
    text: "Preferences updated successfully"

# ✅ DYNAMIC MESSAGE - Uses function results
actions:
  - type: message
    text: |
      ✅ **Update Complete**
      
      **Operation:** $target_result.update_type_request
      **Status:** $target_result.update_status
      
      $target_result.success_message

# ❌ MISSING CONDITIONAL HANDLING
actions:
  - type: message
    text: "Success: $target_result.success_message"
    # ❌ What if there's an error?

# ✅ CONDITIONAL MESSAGE HANDLING
actions:
  - condition: "$target_result.update_status == 'success'"
    type: message
    text: |
      ✅ **Success!**
      $target_result.success_message
      
  - condition: "$target_result.update_status == 'error'"
    type: message
    text: |
      ❌ **Update Failed**
      $target_result.error_message
      Please try again or contact support.
```

**Variable Reference Issues**:
```yaml
# ❌ WRONG VARIABLE REFERENCES
text: "Status: $update_status"           # Missing target_result prefix
text: "Status: $result.update_status"    # Wrong prefix
text: "Status: $response.update_status"  # Wrong prefix

# ✅ CORRECT VARIABLE REFERENCES
text: "Status: $target_result.update_status"  # ✅ Correct

# ❌ UNDEFINED VARIABLES
text: "User: $target_result.user_name"   # Function doesn't return user_name

# ✅ VERIFY VARIABLES EXIST IN FUNCTION RESULT
# Check function's result section:
result:
  update_status: "<? update_status ?>"
  success_message: "<? success_message ?>"
  # Then reference in scenario:
text: "Status: $target_result.update_status"
```

**Troubleshooting Scenario Issues**:

**1. Scenario Not Triggering (0 messages in test)**:
```bash
# Check these in order:
✅ 1. Does scenario have samples?
✅ 2. Do test phrases match samples?
✅ 3. Is scenario file in scenarios/ folder?
✅ 4. Does scenario target valid function?
✅ 5. Is function in functions/ folder?
```

**2. Function Runs But No User Response**:
```bash
# Check these:
✅ 1. Does scenario have actions section?
✅ 2. Do actions reference valid function results?
✅ 3. Are variable references using $target_result prefix?
```

**3. Variable Reference Errors**:
```bash
# Debug approach:
✅ 1. Check function result section for available variables
✅ 2. Test function independently first
✅ 3. Use simple static text first, then add variables
✅ 4. Check for typos in variable names
```

**Best Practices for Scenarios**:
- **8-12 sample utterances** with varied phrasing
- **Always include message actions** for user feedback
- **Use $target_result prefix** for function variables
- **Handle both success and error cases** in message actions
- **Test scenarios independently** before integration
- **Keep descriptions focused** on what the function does
- **Match slot names** exactly with function parameters

---

This comprehensive guide covers the essential aspects of Joule development, from basic setup to advanced features. Use it as a reference throughout your development journey, and refer to specific sections as needed for your implementation requirements.