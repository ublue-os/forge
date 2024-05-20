import pandas
import humanize
from nicegui import ui
from utils.registry import DockerRegistry


## TODO: this should be async but I currently don't know how to implement this without button press
def get_image_info() -> pandas.DataFrame:
    data = pandas.DataFrame(columns=["image_name", "tag", "size"])
    try:
        registry = DockerRegistry()
        all_image_info = registry.get_all_image_info()
    except Exception as error:
        ui.notify(message=error)
        return data
    if isinstance(all_image_info, list) and len(all_image_info) > 0:
        data = pandas.json_normalize(
            all_image_info,
            record_path=["tags"],
            meta=[["name"]],
            meta_prefix="image_",
        ).assign(
            size=lambda x: x["manifest.layers"].apply(
                lambda layers: sum(layer["size"] for layer in layers)
            )
        )
        data = data[["image_name", "name", "size"]].rename(
            columns={"image_name": "image", "name": "tag", "size": "size"}
        )
        data["size"] = data["size"].apply(humanize.naturalsize)
        return data
    else:
        ui.notify(message="No images found")
        return data


def content() -> None:
    with ui.row().classes("w-full"):
        with ui.card().classes("w-full"):
            ui.label("Image Overview").classes("text-h5")
            data = get_image_info()
            ui.table.from_pandas(df=data).classes("w-full")
