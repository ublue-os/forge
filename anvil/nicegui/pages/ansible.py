import ansible_runner
import re
import asyncio
import os
from nicegui import ui
from theme import GuiProgressSpinner
from utils.filepicker import local_file_picker

ANSIBLE_EXTRA_VARS = None


# Ansible integration
@ui.refreshable  # https://www.reddit.com/r/nicegui/comments/1bphjk5/comment/kx7l5kj/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
async def load_configuration_file() -> None:
    global ANSIBLE_EXTRA_VARS
    result = await local_file_picker(
        directory="/data",
        multiple=False,
        # file_name_filter=".yml", # TODO: limit to yml files but make sure folders are visible as well
    )
    file_path = result[0]
    with open(file_path, "r") as file:
        data = file.read()
    ## Give feedback to user
    ui.notify(f"You chose {file_path}")
    ## Display content
    ui.code(content=data, language="yaml")
    ## Preserve configuration file path for ansible-playbook --extra-vars
    ANSIBLE_EXTRA_VARS = f"@{file_path}"


async def run_ansible_playbook(
    playbook_name: str, gui_log: ui.log, gui_spinner: GuiProgressSpinner
) -> None:
    # Clear log console
    gui_log.clear()
    # Enable spinner
    gui_spinner.enable()
    # Run ansible playbook
    project_root = os.environ["ANSIBLE_DIR"]
    playbook_path = f"{project_root}/playbooks/"
    extra_vars_file = ANSIBLE_EXTRA_VARS
    thread, runner = ansible_runner.interface.run_command_async(
        executable_cmd="ansible-playbook",
        cmdline_args=[
            f"{playbook_path}/{playbook_name}",
            # playbook_path + playbook_name,
            "--extra-vars",
            extra_vars_file,
        ],
    )
    # Parse and display output from ansible playbook
    ## Remove color characters from response until clear how to display them in a log
    output_parser = re.compile(r"\x1B(?:[@-Z\\-_]|\[[0-9;#]+[mGK]?)")
    # show log from asynchronous job
    processed_events = set()  # Set to store processed events
    while runner.rc is None:
        for event in runner.events:
            # Make sure log is displayed during playbook run
            await asyncio.sleep(0.1)
            # Check if event has been processed already
            event_key = (event["uuid"], event["counter"])
            if event_key not in processed_events:
                # Add event to processed set
                processed_events.add(event_key)
                # Process event
                ansible_log = format(output_parser.sub("", event["stdout"]))
                # Push log to ui
                gui_log.push(ansible_log)
    # Disable spinner
    gui_spinner.disable()


# Page content
def content() -> None:
    with ui.row().classes("w-full"):
        with ui.row().classes("w-full"):
            with ui.card().classes("h-full"):
                ui.button(
                    text="Load configuration file",
                    on_click=lambda: load_configuration_file.refresh(),
                    icon="folder",
                )
                ## show configuration file with ui.code
                load_configuration_file()
        with ui.row().classes("w-full"):
            # First Row
            with ui.card().classes("h-full"):
                with ui.row().classes("no-wrap"):
                    ui.label("Build").classes("text-h5")
                    gui_build_progress = GuiProgressSpinner()
                ui.button(
                    text="Clone project",
                    on_click=lambda: run_ansible_playbook(
                        playbook_name="project_clone.yml",
                        gui_log=gui_playbook_log,
                        gui_spinner=gui_build_progress,
                    ),
                )
                ui.button(
                    text="Build project",
                    on_click=lambda: run_ansible_playbook(
                        "project_build.yml",
                        gui_log=gui_playbook_log,
                        gui_spinner=gui_build_progress,
                    ),
                )
            # Second Row
            with ui.card().classes("h-full"):
                with ui.row().classes("no-wrap"):
                    ui.label("Deploy").classes("text-h6")
                    gui_deploy_progress = GuiProgressSpinner
                ui.button(
                    "Deploy VM",
                    on_click=lambda: ui.notify("This playbook is not implemented yet"),
                )

        with ui.row().classes("w-full"):
            with ui.card().classes("w-full"):
                ui.label("Playbook Log").classes("text-h6")
                ui.button("Clear Log", on_click=lambda: gui_playbook_log.clear())
                gui_playbook_log = ui.log().classes("w-full h-full")
