import pages
import pages.ansible
import pages.home
import pages.registry
import theme

from nicegui import ui


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


ui.run(title="uBlue Forge", port=3000)
