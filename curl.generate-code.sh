#!/bin/sh

# combine the generated code, output from the `xtp` CLI tooling, 
# using the generated schema from the xAI API. 
PDK=$(jq -Rs '.' plugins/geometricMean/pdk.gen.go)
MAIN=$(jq -Rs '.' plugins/geometricMean/main.go)
SCHEMA=$(jq -Rs '.' gen.geometricMean.yaml)
COMBINED="$PDK + $MAIN + $SCHEMA"


# add more instructions to guide the model to generate the code 
# that implements the TODO left by the `xtp` CLI.
FULL_PROMPT=$(\
  echo $COMBINED | \
  jq -Rs --arg addtext "generate the implementation of the \
  empty function stub in main - use the schema to guide the \
  implementation and the code samples to guide the exact \
  signature of the function as well as the PDK to understand \
  the types" '. + $addtext')


# prompt the model to generate the code, expecting the code in the output.
# we will manually compile the output code into the WebAssembly plugin, 
# but this could be done via an online build service.
curl https://api.x.ai/v1/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $XAI_API_TOKEN" \
  -d "{
    \"prompt\": $FULL_PROMPT,
    \"model\": \"grok-2-public\",
    \"stream\": false
  }"

  