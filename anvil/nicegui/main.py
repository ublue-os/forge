import pages
import pages.ansible
import pages.home
import pages.registry
import theme

from nicegui import ui
from utils.helper import get_project_root


@ui.page("/")
def index_page() -> None:
    with theme.frame("Home"):
        pages.home.content()


@ui.page("/ansible")
def ansible_page() -> None:
    with theme.frame("Ansible"):
        pages.ansible.content()


@ui.page("/registry")
def registry_page() -> None:
    with theme.frame("Registry"):
        pages.registry.content()


project_root = get_project_root()
ui.run(
    title="uBlue-OS Forge",
    port=3000,
    favicon=f"{project_root}/pages/assets/favicon.png",
)
