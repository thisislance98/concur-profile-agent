# Fetch Weather - Step 5: Add response generation to your scenario

In this step, we will remove the static messages in our dialog function and enable dynamic and intelligent responses via GenAI response generation.

*Please note that this step requires the latest joule features and schema version `3.3.0`.
If the assistant does not compile, fall back to static response messages as defined in step 4!*

## Preview

![image](assets/preview.png)

*Our assistant is now capable of generating a response of various types specifically catered to the user utterance.*

## Steps

#### capabilities/weather/functions/fetch_weather_info.yaml

```yaml
parameters:
  - name: city
action_groups:
  - actions:
      - type: set-variables
        scripting_type: spel
        variables:
          - name: unit
            value: m
      - type: dialog-function
        name: lookup_location
        parameters:
          - name: city
            value: "<? city ?>"
        result_variable: weather_location
      - type: api-request
        method: GET
        system_alias: WeatherService
        path: /wx/forecast/daily/3day?placeid=<? weather_location.placeid ?>&units=<? unit ?>&language=en-US&format=json
        result_variable: weather_result
result:
  timestamp: <? weather_result.body.validTimeLocal ?>
  temperatureMax: <? weather_result.body.temperatureMax ?>
  temperatureMin: <? weather_result.body.temperatureMin ?>
  dayOfWeek: <? weather_result.body.dayOfWeek ?>
  narrative: <? weather_result.body.narrative ?>
  city: <? city ?>
```

Before we come to the actual response generation in the weather scenario, we will remove the two `condition` sections with the static responses in the dialog function.
Now we only expose the relevant parts of the weather API response as result variables and let the large language model create the response based on the user utterance.

### capabilities/weather/scenarios/fetch_weather_info.yaml

```yaml
description: This function fetches the weather for a given city and provides intelligent responses to weather related topics

slots:
  - name: city
    description: Weather information fetched for this city

target:
  type: function
  name: fetch_weather_info

response_context:
  - value: timestamp
    description: timestamp for next 4 days including today
  - value: temperatureMax
    description: maximum temperature for next 4 days incl. today
  - value: temperatureMin
    description: minimum temperature for next 4 days incl. today
  - value: dayOfWeek
    description: day of the week for next 4 days incl. today
  - value: narrative
    description: weather description for next 4 days incl. today
  - value: city
    description: city for which the weather has been fetched
```

In order to enable GenAI response generation, we will add a response context section to our weather scenario. In the response context, we can reference the subset of result variables in the target function that shall be used for response generation. 
Additionally, we will add one description per variable which explains its meaning to the LLM. The more accurate this description is, the better the results of the generated responses will be.

For your reference, we have added the result of this step to a separate folder `weather_response_generation` in the `capabilities` folder of this repository.

### Test your assistant in the standalone web client:

1. Run the following commands deploy the updated assistant and open the standalone web client:
```bash
joule deploy -c -n "weather"
joule launch weather
```
2. A Browser will open with the joule web client. You can now test your assistant in the chat window.
3. Play around with the intelligent and dynamic responses of your assistant. You may use utterances like "How is the weather today in <city>?", "Do I need a raincoat tomorrow?" or "Show me the weather for the upcoming days". Notice how we get a variety of responses for the same scenario depending on what exactly we want to know.

That's a wrap! You have successfully completed the Joule Weather tutorial.

* [Back to Overview](../index.md)

## Related Information 

[Test the capability](https://help.sap.com/docs/joule/service-guide/test-capability)
