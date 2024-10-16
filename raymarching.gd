extends MeshInstance2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_quad_scale()
	# Connect to the screen resize signal if the window is resizable
	get_viewport().connect("size_changed", update_quad_scale)
	material.set_shader_parameter("res", get_viewport().size)
	scale = get_viewport().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	material.set_shader_parameter("res", get_viewport().size)
	scale = get_viewport().size

func update_quad_scale() -> void:
	# Get the current viewport size
	var viewport_size = get_viewport().size
	
	position = Vector2(viewport_size.x / 2, viewport_size.y /2)

	# Set the scale of the MeshInstance3D based on the viewport size
	# For example, making the width of the quad equal to the viewport's width.
	scale = Vector2(viewport_size.x, viewport_size.y)
