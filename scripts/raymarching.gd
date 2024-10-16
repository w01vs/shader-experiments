extends MeshInstance2D

var zoom: int = 0
var mouse: Vector2

func _ready() -> void:
	update_quad_scale()
	get_viewport().connect("size_changed", update_quad_scale)
	material.set_shader_parameter("res", get_viewport().size)
	var size = get_viewport().size
	mouse = Vector2(size.x / 2, size.y / 2)
	material.set_shader_parameter("mouse", mouse)

func _physics_process(delta: float) -> void:
	material.set_shader_parameter("DELTATIME", delta)
	if Input.is_action_pressed("click"):
		mouse = get_viewport().get_mouse_position()
		material.set_shader_parameter("mouse", Vector3(mouse.x, mouse.y, 1))
	else:
		material.set_shader_parameter("mouse", Vector3(mouse.x, mouse.y, -1))
		
	if Input.is_action_just_released("scroll_up"):
		zoom += 1
		material.set_shader_parameter("zoom", zoom)
	if Input.is_action_just_released("scroll_down"):
		zoom -= 1
		material.set_shader_parameter("zoom", zoom)

func update_quad_scale() -> void:
	var viewport_size = get_viewport().size
	
	position = Vector2(viewport_size.x / 2, viewport_size.y / 2)

	scale = Vector2(viewport_size.x, viewport_size.y)
