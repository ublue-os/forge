import ansible_runner
import re
from nicegui import ui
from utils import get_project_root


# Ansible integration
def run_ansible_playbook(playbook_name: str, ngui_log: ui.log):
    project_root = str(get_project_root())
    playbook_path = project_root + "/ansible/playbooks/"
    inventory_path = project_root + "/ansible/inventory.yml"
    response, error, return_code = ansible_runner.interface.run_command(
        executable_cmd="ansible-playbook",
        cmdline_args=[playbook_path + playbook_name, "-i", inventory_path],
    )
    # remove color characters from response until clear how to display them in a log
    ansi_escape = re.compile(r"\x1B(?:[@-Z\\-_]|\[[0-9;#]+[mGK]?)")
    ansible_log = format(ansi_escape.sub("", response))
    ngui_log.clear()
    ngui_log.push(ansible_log)


# Page content
def content() -> None:
    with ui.row().classes("w-full"):
        with ui.row().classes("w-full"):
            # First Row
            with ui.card().classes("h-full"):
                ui.label("Build").classes("text-h6")
                ui.button(
                    text="Clone project",
                    on_click=lambda: run_ansible_playbook(
                        "project_clone.yml", ngui_log=log
                    ),
                )
                ui.button(
                    text="Build project",
                    on_click=lambda: run_ansible_playbook(
                        "project_build.yml", ngui_log=log
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
                ui.button("Clear Log", on_click=lambda: log.clear())
                log = ui.log().classes("w-full h-full")
