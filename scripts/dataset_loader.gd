extends Node3D

const wine_sphere_scene: PackedScene = preload("res://scenes/wine_sphere.tscn")

@onready var dataset: Array[Dictionary] = load_dataset()
@onready var wine_spheres: MultiMesh = $wine_spheres.multimesh

func _ready() -> void:
    wine_spheres.instance_count = self.dataset.size()
    for i in range(self.dataset.size()):
        wine_spheres.set_instance_transform(
            i,
            Transform3D(Basis(), Vector3(i, i, i))
        )

        #var wine_sphere: Node = wine_sphere_scene.instantiate().with_data(
            #wine["Class"],
            #wine["Alcohol"],
            #wine["MalicAcid"],
            #wine["Ash"],
            #wine["AshAlcalinity"],
            #wine["Magnesium"],
            #wine["TotalPhenols"],
            #wine["Flavanoids"],
            #wine["NonflavanoidPhenols"],
            #wine["Proanthocyanins"],
            #wine["ColorIntensity"],
            #wine["Hue"],
            #wine["OD280/OD315"],
            #wine["Proline"]
        #)

func load_dataset() -> Array[Dictionary]:
    var file = FileAccess.open("res://Assets/wine.csv", FileAccess.READ)
    var content = file.get_as_text()

    var lines = content.split("\n")

    var header: PackedStringArray = lines[0].split(",")
    var dataset: Array[Dictionary] = []

    for line in lines.slice(1):
        # Skip empty lines
        if line.strip_edges().length() == 0:
            continue

        var items = line.split(",")
        assert(items.size() == header.size(), "csv error: item count differs from header count")

        var parsed_item = {}
        for i in range(items.size()):
            parsed_item[header[i]] = items[i].to_float()

        dataset.push_back(parsed_item)

    return dataset
