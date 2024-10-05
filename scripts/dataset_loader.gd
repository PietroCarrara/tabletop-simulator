extends Node3D

@onready var dataset: Array[Dictionary] = load_dataset()
@onready var wine_spheres: MultiMesh = $wine_spheres.multimesh

@export var axis1: WineProperty
@export var axis2: WineProperty
@export var axis3: WineProperty
@export var axes_length: float
@export_range(0.01, 2, 0.01) var sphere_scale: float

@onready var sphere_scale_basis = Basis.from_scale(Vector3(sphere_scale, sphere_scale, sphere_scale))

func _ready() -> void:
    wine_spheres.instance_count = self.dataset.size()

    var min_max_values: Dictionary = {}
    for item in self.dataset:
        for property in item:
            var prop_value = item[property]
            if property not in min_max_values:
                # Poor man's tuple
                min_max_values[property] = Vector2(prop_value, prop_value)
            else:
                var min = min_max_values[property].x
                var max = min_max_values[property].y
                if prop_value < min:
                    min_max_values[property].x = prop_value
                if prop_value > max:
                    min_max_values[property].y = prop_value

    for i in range(self.dataset.size()):
        var axis_x = prop_to_string(axis1)
        var axis_y = prop_to_string(axis2)
        var axis_z = prop_to_string(axis3)

        assert(axis_x in self.dataset[i], "Missing axis 1")
        assert(axis_y in self.dataset[i], "Missing axis 2")
        assert(axis_z in self.dataset[i], "Missing axis 3")

        var x = (self.dataset[i][axis_x] - min_max_values[axis_x].x) / (min_max_values[axis_x].y - min_max_values[axis_x].x) * axes_length
        var y = (self.dataset[i][axis_y] - min_max_values[axis_y].x) / (min_max_values[axis_y].y - min_max_values[axis_y].x) * axes_length
        var z = (self.dataset[i][axis_z] - min_max_values[axis_z].x) / (min_max_values[axis_z].y - min_max_values[axis_z].x) * axes_length

        wine_spheres.set_instance_transform(
            i,
            Transform3D(sphere_scale_basis, Vector3(x - axes_length/2, y, -z))
        )

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


enum WineProperty {
    Class,
    Alcohol,
    MalicAcid,
    Ash,
    AshAlcalinity,
    Magnesium,
    TotalPhenols,
    Flavanoids,
    NonflavanoidPhenols,
    Proanthocyanins,
    ColorIntensity,
    Hue,
    OD280_OD315,
    Proline
}

func prop_to_string(prop: WineProperty):
    match prop:
        WineProperty.Class:
            return "Class"
        WineProperty.Alcohol:
            return "Alcohol"
        WineProperty.MalicAcid:
            return "MalicAcid"
        WineProperty.Ash:
            return "Ash"
        WineProperty.AshAlcalinity:
            return "AshAlcalinity"
        WineProperty.Magnesium:
            return "Magnesium"
        WineProperty.TotalPhenols:
            return "TotalPhenols"
        WineProperty.Flavanoids:
            return "Flavanoids"
        WineProperty.NonflavanoidPhenols:
            return "NonflavanoidPhenols"
        WineProperty.Proanthocyanins:
            return "Proanthocyanins"
        WineProperty.ColorIntensity:
            return "ColorIntensity"
        WineProperty.Hue:
            return "Hue"
        WineProperty.OD280_OD315:
            return "OD280/OD315"
        WineProperty.Proline:
            return "Prolin"
