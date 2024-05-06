from nicegui import ui


def menu() -> None:
    ui.link("Home", "/").classes(replace="text-white")
    ui.link("Ansible", "/ansible").classes(replace="text-white")
    ui.link("Registry", "/registry").classes(replace="text-white")
    ui.link("About", "/about").classes(replace="text-white")
