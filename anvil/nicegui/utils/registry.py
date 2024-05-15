import requests
from nicegui import ui


class DockerRegistry:

    def __init__(
        self,
        *,
        registry_url: str = "https://registry.ublue.local",
        registry_root_cert: str = "/data/ublue-os_forge-root.pem",
    ) -> None:
        """
        Docker Registry integration for ublue-os forge
        """

        self.registry_url = registry_url
        self.registry_root_cert = registry_root_cert

    def get_repositories(self) -> list:
        endpoint = f"{self.registry_url}/v2/_catalog"
        response = requests.get(url=endpoint, verify=self.registry_root_cert)
        if response.status_code == 200:
            repositories = response.json()["repositories"]
        else:
            with self, ui.notify() as notify:
                notify(message=f"Error: {response.text}")
        return repositories

    def get_image_tags(self, image_name=str) -> dict:
        endpoint = f"{self.registry_url}/v2/{image_name}/tags/list"
        response = requests.get(url=endpoint, verify=self.registry_root_cert)
        if response.status_code == 200:
            tags = response.json()["tags"]
        else:
            with self, ui.notify() as notify:
                notify(message=f"Error: {response.text}")
        return tags

    def get_image_manifest(self, image_name=str, image_tag=str) -> dict:
        endpoint = f"{self.registry_url}/v2/{image_name}/manifests/{image_tag}"
        headers = {"accept": "application/vnd.oci.image.manifest.v1+json"}
        response = requests.get(
            url=endpoint, verify=self.registry_root_cert, headers=headers
        )
        if response.status_code == 200:
            manifest = response.json()
        else:
            with self, ui.notify() as notify:
                notify(message=f"Error: {response.text}")
        return manifest

    def get_all_image_info(self, image_name=str) -> list:
        repositories = self.get_repositories()
        all_image_info = []
        for repository in repositories:
            tags = self.get_image_tags(image_name=repository)
            for tag in tags:
                manifest = self.get_image_manifest(image_name=repository, image_tag=tag)
                image_info = {
                    "name": repository,
                    "tags": [{"name": tag, "manifest": manifest}],
                }
                all_image_info.append(image_info)
        return all_image_info
