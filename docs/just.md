# Usage with just command runner

If you don't want to use the [GUI](gui.md) we provide the following recipes
via [just command runner](https://github.com/casey/just).

<!-- markdownlint-disable MD013 -->

| Just recipe           | Input argument          | Description                                  |
| --------------------- | ----------------------- | -------------------------------------------- |
| `forge_project-clone` | `forge_config_var_file` | Clone git project repository                 |
| `forge_project-build` | `forge_config_var_file` | Build container image and upload to registry |

<!-- markdownlint-enable MD013 -->

All available settings for the `forge_config_var_file` are documented in the [variables.md](./variables.md)
file. To launch a recipe you simple run:

```sh
just -f forge.just {{ recipe_name }} {{ forge_config_var_file }}
```

**_Example:_**

```sh
just -f forge.just forge_project-clone ~/ublue-os_forge/my-forge-project.env
```

In case you don't have [just command runner](https://github.com/casey/just) available.
Have a look at the [forge.just](../forge.just) file. It easy enough to understand which commands
are executed via the just recipes.
