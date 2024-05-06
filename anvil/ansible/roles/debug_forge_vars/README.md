# Role - debug_forge_vars

This role is used for debugging purposes only.

## Variables

The role has the following variables defined.

### default/main.yml

In the [main.yml](./defaults/main.yml/) all variables are defined which are
used in the context of debugging. Usually end-users should not worry about them to much.

<!-- markdownlint-disable MD013 -->

| name                            | type | default value | description                                                                                 |
| ------------------------------- | ---- | ------------- | ------------------------------------------------------------------------------------------- |
| `forge_debug_vars_regex_search` | str  | ^forge\_.+    | Python regex search term. Useful if you want to print out all variables starting with `xyz` |

<!-- markdownlint-enable MD013 -->

## Example Playbook Usage

This role is best included in a playbook as pre-task:

```yaml
pre_tasks:
  - name: DEBUG - forge variables
    ansible.builtin.include_role:
      name: debug_forge_vars
```

With the role included you can launch the playbook in verbose mode `ansible-playbook -v`.
This will print all variables found with the regex search term defined in the `forge_debug_vars_regex_search`
variable.

You can modify the `forge_debug_vars_regex_search` term by changing it via the vars statement

```yaml
pre_tasks:
  - name: DEBUG - forge git variables
    ansible.builtin.include_role:
      name: debug_forge_vars
    vars:
      forge_debug_vars_regex_search: ^forge_git.+
```
