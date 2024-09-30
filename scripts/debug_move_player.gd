extends XROrigin3D

## Whether debug movement mode is on
@export var enabled: bool
## Speed in meters per second
@export var speed: float
## Camera movement sensibility in radians per pixel the mouse moved
@export_range(0, 90, 0.1, "radians_as_degrees") var camera_sensibility: float

@onready var camera: XRCamera3D = $XRCamera3D

func _ready() -> void:
	if !enabled:
		self.set_script(null)
		return

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var movement: Vector3 = Vector3.ZERO
	
	if Input.is_key_pressed(KEY_W):
		movement.z = -1
	if Input.is_key_pressed(KEY_S):
		movement.z = 1
	if Input.is_key_pressed(KEY_A):
		movement.x = -1
	if Input.is_key_pressed(KEY_D):
		movement.x = 1
	
	if movement != Vector3.ZERO:
		movement = movement.normalized().rotated(Vector3.UP, self.rotation.y)
		self.position += movement * speed * delta
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var rotation_y = -event.relative.x * camera_sensibility
		var rotation_x = -event.relative.y * camera_sensibility
		self.rotation = Vector3(
			self.rotation.x + rotation_x,
			self.rotation.y + rotation_y,
			self.rotation.z
		)
