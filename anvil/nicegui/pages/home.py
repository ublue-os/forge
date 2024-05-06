from nicegui import ui
from utils import get_project_root


def content() -> None:
    project_root = str(get_project_root())
    ui.label("Work in progress...").classes("text-h6")
    ui.image(project_root + "/nicegui/pages/assets/work-in-progress.png").classes(
        "w-[200%]"
    )
