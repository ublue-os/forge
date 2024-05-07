import ansible_runner
import re
from nicegui import ui
from utils import get_project_root, local_file_picker
from multiprocessing import Manager, Queue

ANSIBLE_EXTRA_VARS = None


# Ansible integration
@ui.refreshable #https://www.reddit.com/r/nicegui/comments/1bphjk5/comment/kx7l5kj/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
async def load_configuration_file() -> None:
    result = await local_file_picker(
        directory="/data", multiple=False, file_name_filter=".yml"
    )
    file_path = result[0]
    with open(file_path, "r") as file:
        data = file.read()
    ## Give feedback to user
    ui.notify(f"You chose {file_path}")
    ## Display content
    ui.code(content=data, language="yaml")
    ## Preserve configuration file path for ansible-playbook --extra-vars
    ANSIBLE_EXTRA_VARS = f'"@{file_path}"'

async def run_ansible_playbook(playbook_name: str, ngui_log: ui.log):
    project_root = str(get_project_root())
    playbook_path = project_root + "/ansible/playbooks/"
    inventory_path = project_root + "/ansible/inventory.yml"
    extra_vars_file = str(ANSIBLE_EXTRA_VARS)
    thread, runner = ansible_runner.interface.run_command_async(
        executable_cmd="ansible-playbook",
        cmdline_args=[
            playbook_path + playbook_name,
            "-i",
            inventory_path,
            "--extra-vars",
            extra_vars_file,
        ]
    )
    # clear log
    ngui_log.clear()
    # regex to remove color characters from response until clear how to display them in a log
    ansi_escape = re.compile(r"\x1B(?:[@-Z\\-_]|\[[0-9;#]+[mGK]?)")
    # show log from asynchronous job
    while runner.rc is None:
        for event in runner.events:
            ansible_log = format(ansi_escape.sub("", event['stdout']))
            ngui_log.push(ansible_log)

# Page content
def content() -> None:
    with ui.row().classes("w-full"):
        with ui.row().classes("w-full"):
            with ui.card().classes("h-full"):
                ui.button(text=
                    "Load configuration file",
                    on_click=lambda: load_configuration_file.refresh(),
                    icon="folder",
                )
                ## show configuration file with ui.code
                load_configuration_file()
        with ui.row().classes("w-full"):
            # First Row
            with ui.card().classes("h-full"):
                ui.label("Build").classes("text-h6")
                ui.button(
                    text="Clone project",
                    on_click=lambda: run_ansible_playbook(
                        playbook_name="project_clone.yml", ngui_log=playbook_log
                    ),
                )
                ui.button(
                    text="Build project",
                    on_click=lambda: run_ansible_playbook(
                        "project_build.yml", ngui_log=playbook_log
                    ),
                )
            # Second Row
            with ui.card().classes("h-full"):
                ui.label("Deploy").classes("text-h6")
                ui.button(
                    "Deploy VM",
                    on_click=lambda: ui.notify("This playbook is not implemented yet"),
                )

        with ui.row().classes("w-full"):
            with ui.card().classes("w-full"):
                ui.label("Playbook Log").classes("text-h6")
                ui.button("Clear Log", on_click=lambda: playbook_log.clear())
                playbook_log = ui.log().classes("w-full h-full")
