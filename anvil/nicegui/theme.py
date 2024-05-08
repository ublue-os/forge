from contextlib import contextmanager
from menu import menu
from nicegui import ui


class GuiProgressSpinner(ui.spinner):
    def __init__(
        self,
        *,
        type: str = "dots",
        size: str = "lg",
        color: str | None = "red",
        thickness: float = 5
    ) -> None:
        super().__init__(type, size=size, color=color, thickness=thickness)
        with self, ui.spinner():
            self.visible = False

    def enable(self) -> None:
        self.set_visibility(True)

    def disable(self) -> None:
        self.set_visibility(False)


@contextmanager
def frame(navigation_title: str, enable_right_drawer: bool = False):
    """Custom page frame to share the same styling and behavior across all pages"""
    ui.colors(primary="#4051b5", secondary="#dddbff", accent="#171d9a")
    with ui.header():
        with ui.row():
            menu()
        ui.space()
        with ui.link(target="https://github.com/ublue-os/forge", new_tab=True):
            ui.icon("eva-github").classes("text-2xl")

    with ui.column().classes():
        ui.label(navigation_title).classes("text-h4")
        yield

    with ui.footer(value=False):
        ui.add_head_html(
            '<link href="https://unpkg.com/eva-icons@1.1.3/style/eva-icons.css" rel="stylesheet" />'
        )
