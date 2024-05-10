# Usage with just command runner

If you don't want to use the [GUI](./gui.md) we provide the following recipes
via [just command runner](https://github.com/casey/just).

<!-- markdownlint-disable MD013 -->

| Just recipe           | Input argument          | Description                                  |
| --------------------- | ----------------------- | -------------------------------------------- |
| `forge_project-clone` | `forge_config_var_file` | Clone git project repository                 |
| `forge_project-build` | `forge_config_var_file` | Build container image and upload to registry |

<!-- markdownlint-enable MD013 -->

The input argument expects a [configuration](./index.md#configuration) file from the data store.

To launch a recipe you simple run:

```sh
just -f forge.just {{ recipe_name }} {{ forge_config_var_file }}
```

**_Example:_**

The path to the [configuration](./index.md#configuration) data directory is pre set. So you just
have to specify the configuration yaml.

```sh
just -f forge.just forge_project-build bluefin.yml
```

In case you don't have [just command runner](https://github.com/casey/just) available.
Have a look at the [forge.just](../forge.just) file. It easy enough to understand which commands
are executed via the just recipes.
