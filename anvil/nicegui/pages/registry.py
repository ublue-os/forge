from nicegui import ui
import os


def content() -> None:
    project_root = os.environ['NICEGUI_DIR']
    ui.label("Work in progress...").classes("text-h6")
    ui.image(project_root + "/pages/assets/work-in-progress.png").classes(
        "w-[200%]"
    )
