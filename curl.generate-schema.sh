#!/bin/sh

# load some context to constrain the model and inform it of our goal
# TL;DR the model should understand it's able to define its own interface
# to create a "tool" that it can call. this initial step is to generate
# the schema for the tool. the next step is to generate the code for the tool,
# which will be executed securely within an embedded WebAssembly runtime.
FINETUNING=$(jq -Rs '.' fine-tuning.json)


# further instruct the model to create the schema accoding to the need of 
# the model or agent who will use the tool. in this case, we've hard-coded
# the need to "calculate the geometric mean of a list of numbers."
FULL_PROMPT=$(\
  echo $FINETUNING | \
  jq -Rs \
  --arg addtext " with this context, create a schema that would have \
  code to calculate the geometric mean of a list of numbers" '. + $addtext')


# in a single shot, prompt the model, expecting the schema in the output
curl https://api.x.ai/v1/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $XAI_API_TOKEN" \
  -d "{
    \"prompt\": $FULL_PROMPT,
    \"model\": \"grok-2-public\",
    \"stream\": false
  }"