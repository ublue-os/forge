from pathlib import Path
import platform
from typing import Optional
from nicegui import events, ui


# most of the local_file_picker class is from https://github.com/zauberzeug/nicegui/blob/main/examples/local_file_picker/local_file_picker.py
# i just added the file_name_filter
class local_file_picker(ui.dialog):

    def __init__(
        self,
        directory: str,
        *,
        upper_limit: Optional[str] = ...,
        multiple: bool = False,
        show_hidden_files: bool = False,
        file_name_filter: Optional[str] = None,
    ) -> None:
        """Local File Picker

        This is a simple file picker that allows you to select a file from the local filesystem where NiceGUI is running.

        :param directory: The directory to start in.
        :param upper_limit: The directory to stop at (None: no limit, default: same as the starting directory).
        :param multiple: Whether to allow multiple files to be selected.
        :param show_hidden_files: Whether to show hidden files.
        :param file_name_filter: Filter files in directory based on file name
        """
        super().__init__()

        self.path = Path(directory).expanduser()
        if upper_limit is None:
            self.upper_limit = None
        else:
            self.upper_limit = Path(
                directory if upper_limit == ... else upper_limit
            ).expanduser()
        self.show_hidden_files = show_hidden_files
        self.file_name_filter = file_name_filter
        with self, ui.card():
            self.add_drives_toggle()
            self.grid = (
                ui.aggrid(
                    {
                        "columnDefs": [{"field": "name", "headerName": "File"}],
                        "rowSelection": "multiple" if multiple else "single",
                    },
                    html_columns=[0],
                )
                .classes("w-96")
                .on("cellDoubleClicked", self.handle_double_click)
            )
            with ui.row().classes("w-full justify-end"):
                ui.button("Cancel", on_click=self.close).props("outline")
                ui.button("Ok", on_click=self._handle_ok)
        self.update_grid()

    def add_drives_toggle(self):
        if platform.system() == "Windows":
            import win32api

            drives = win32api.GetLogicalDriveStrings().split("\000")[:-1]
            self.drives_toggle = ui.toggle(
                drives, value=drives[0], on_change=self.update_drive
            )

    def update_drive(self):
        self.path = Path(self.drives_toggle.value).expanduser()
        self.update_grid()

    def update_grid(self) -> None:
        paths = list(self.path.glob("*"))
        if not self.show_hidden_files:
            paths = [p for p in paths if not p.name.startswith(".")]
        if self.file_name_filter:  # Add this condition
            paths = [
                p for p in paths if p.is_file() and p.suffix == self.file_name_filter
            ]
        paths.sort(key=lambda p: p.name.lower())
        paths.sort(key=lambda p: not p.is_dir())

        self.grid.options["rowData"] = [
            {
                "name": f"📁 <strong>{p.name}</strong>" if p.is_dir() else p.name,
                "path": str(p),
            }
            for p in paths
        ]
        if (
            self.upper_limit is None
            and self.path != self.path.parent
            or self.upper_limit is not None
            and self.path != self.upper_limit
        ):
            self.grid.options["rowData"].insert(
                0,
                {
                    "name": "📁 <strong>..</strong>",
                    "path": str(self.path.parent),
                },
            )
        self.grid.update()

    def handle_double_click(self, e: events.GenericEventArguments) -> None:
        self.path = Path(e.args["data"]["path"])
        if self.path.is_dir():
            self.update_grid()
        else:
            self.submit([str(self.path)])

    async def _handle_ok(self):
        rows = await ui.run_javascript(
            f"getElement({self.grid.id}).gridOptions.api.getSelectedRows()"
        )
        self.submit([r["path"] for r in rows])


class progress_spinner(ui.spinner):
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

    def enable_progress(self) -> None:
        self.set_visibility(True)

    def disable_progress(self) -> None:
        self.set_visibility(False)


def get_project_root() -> Path:
    return Path(__file__).parent.parent
