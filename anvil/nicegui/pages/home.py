from nicegui import ui
from utils.helper import get_project_root


def content() -> None:
    project_root = get_project_root()
    with ui.row().classes("w-full"):
        with ui.card().classes("h-full"):
            with ui.row().classes("no-wrap"):
                with ui.link(target="/ansible"):
                    ui.image(source=f"{project_root}/pages/assets/ansible.png").classes(
                        "w-32"
                    )

        with ui.card().classes("h-full"):
            with ui.row().classes("no-wrap"):
                with ui.link(target="/registry"):
                    ui.image(
                        source=f"{project_root}/pages/assets/registry.png"
                    ).classes("w-32")

    with ui.row().classes("w-full"):
        with ui.card().classes("h-full"):
            with ui.row().classes("no-wrap"):
                ui.markdown(
                    content="""
                            ### Welcome to Universal Blue Forge

                            Ublue-OS Forge is your self-hosted OS forge for custom images.

                            To get started have a look at the latest [documentation](https://github.com/ublue-os/forge/blob/main/docs/index.md).
                            
                            For feedback and discussion join the [Discourse Forum](https://universal-blue.discourse.group/).

                            Found a bug, feel free to file an [issue](https://github.com/ublue-os/forge/issues).

                            Thanks and enjoy!
                            """
                ).classes("text-base")
    with ui.row():
        ui.space
