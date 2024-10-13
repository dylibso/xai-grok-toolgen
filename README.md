# xAI & Grok Toolgen

For context, see this thread: https://x.com/getxtp/status/1845278087749173641

> [!WARNING] The output from the scripts calling the xAI API is raw and can be
> hard to parse. If you are planning to run these commands, just know you may
> need to pick apart the JSON responses quite a bit.

## Usage

#### 1. You'll first need a [xAI account](https://console.x.ai) and API token to run against the API.

Export it to the session where you'll run these scripts:

```sh
export XAI_API_TOKEN=...
```

#### 2. Generate the XTP Schema

```sh
sh curl.generate-schema.sh
```

The file `gen.geometricMean.yaml` in the root of the repo is the extracted
output from this API.

> NOTE: Change the prompt inside this script to have a different kind of schema
> generated.

#### 3. Use the generated schema to then create XTP plugin boilerplate

```sh
xtp plugin init --schema-file gen.geometricMean.yaml
```

The directory `plugins/geometricMean` contains the fully implemented code
(including the output from the next step). Your output will not contain the
implementation -- but we'll use all this boilerplate code to ask Grok to write
the implementation.

#### 4. Prompt the API to implement the plugin function

```sh
sh curl.generate-code.sh
```

This will collect all the boilerplate code provided by `xtp` CLI, along with
some context, and prompt Grok to implement the plugin function.

#### 5. Compile and test the plugin

```sh
xtp plugin build
xtp plugin call dist/plugin.wasm calculateGeometricMean --wasi --input '{"numbers": [1, 2, 3, 4, 5, 6]}'
{"geometricMean":2.9937952}
```

🎉🎉🎉
