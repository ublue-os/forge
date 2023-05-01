# Ansible Role - semaphore

This role is used to configure [Ansible Semaphore](https://www.ansible-semaphore.com/)
for the [Universal Blue Forge](https://github.com/ublue-os/forge).

It was inspired by the work documented here <https://github.com/ansible-semaphore/semaphore/discussions/1031>

## Usage

### Input Variables

This role has the following variables defined:

<!-- markdownlint-disable MD013 MD033-->

#TODO: Document input variables

| Name | Type | Default Value | Description |
| ---- | ---- | ------------- | ----------- |
|      |      |               |             |

<!-- markdownlint-enable MD013 MD033 -->

### Example Task

```yaml
- name: Configure Ansible Semaphore
  ansible.builtin.include_role:
    name: semaphore
```

## License

This work is licensed under the [Apache License](../../../../LICENSE)
