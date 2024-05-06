import sys
import ansible_runner

# run ansible/generic commands in interactive mode locally
out, err, rc = ansible_runner.run_command(
    executable_cmd='ansible-playbook',
    cmdline_args=['../playbooks/project_clone.yml', '-i', '../inventory.yml'],
    input_fd=sys.stdin,
    output_fd=sys.stdout,
    error_fd=sys.stderr,
)
print("rc: {}".format(rc))
print("out: {}".format(out))
print("err: {}".format(err))