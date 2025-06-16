# Joule Concur Request Assistant Capabilities

- request_cost_estimate_capability: Estimate cost of business trip for preferred services (ie flight, hotel, train, taxi, etc.)
- concur_request_capability: Create, update, delete Concur Request
- concur_request_workflow_capabilitiy : submit, recall, approve, sentback Concur Request

## Prerequisites
- Joule development setup guide:  https://help.sap.com/docs/joule/service-guide/development

# Login (DAS Command Line Interface)
sapdas login --default-idp 
--authurl "https://joule-functions-pilot-v4r4l1j7.authentication.eu12.hana.ondemand.com" 
--clientid "sb-das-designer!b347846|das-application-canary!b305237" 
--clientsecret "<secret of service inssb-das-designer!b347846|das-application-canary!b305237tance>" 
--username "user.name@sap.com" 
--password "<sap password>"

For clientsecret have a look at BTP Cockpit (https://canary.cockpit.btp.int.sap/cockpit , concur-spend-research-> Joule Functions Pilot) -> 'Instances and Subscriptions' -> Instances, Service 'joule-pilot-functions-other' -> View Credentials