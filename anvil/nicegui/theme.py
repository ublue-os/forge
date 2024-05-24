from contextlib import contextmanager
from menu import menu
from nicegui import ui
from utils.helper import get_project_root


class GuiProgressSpinner(ui.spinner):
    def __init__(
        self,
        *,
        type: str = "dots",
        size: str = "lg",
        color: str | None = "red",
        thickness: float = 5,
    ) -> None:
        super().__init__(type, size=size, color=color, thickness=thickness)
        with self, ui.spinner():
            self.visible = False

    def enable(self) -> None:
        self.set_visibility(True)

    def disable(self) -> None:
        self.set_visibility(False)


@contextmanager
def frame(
    navigation_title: str,
):
    """Custom page frame to share the same styling and behavior across all pages"""
    project_root = get_project_root()
    ui.colors(primary="#4051b5", secondary="#dddbff", accent="#171d9a")
    with ui.header():
        with ui.grid(columns=3).classes("w-full gap-0"):
            with ui.row(wrap=False).classes("col-span-1 justify-start"):
                menu()
                ui.image(source=f"{project_root}/pages/assets/ublue-mini.svg").props(
                    "width=33px hight=auto"
                )
                ui.label(text="Forge").classes("text-h5")
            with ui.row(wrap=False).classes("col-span-1 justify-center"):
                ui.label(text=navigation_title).classes("text-h5")
            with ui.row(wrap=False).classes("col-span-1 justify-end"):
                with ui.link(target="https://github.com/ublue-os/forge", new_tab=True):
                    ui.icon("eva-github").classes("text-2xl")

    with ui.column().classes():
        yield

    with ui.footer(value=False):
        ui.add_head_html(
            '<link href="https://unpkg.com/eva-icons@1.1.3/style/eva-icons.css" rel="stylesheet"/>'
        )
