extends MeshInstance2D

var pos: Vector3 = Vector3(0,0,-3)
var deg_dir: Vector2 = Vector2(0, 0)
var speed: float = 0.02

func _ready() -> void:
	update_quad_scale()
	get_viewport().connect("size_changed", update_quad_scale)
	material.set_shader_parameter("res", get_viewport().size)
	material.set_shader_parameter("origin", pos)

func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("forward"):
		pos.z += speed
		
	if Input.is_action_pressed("backward"):
		pos.z -= speed
		
	if Input.is_action_pressed("right"):
		pos.x += speed
	
	if Input.is_action_pressed("left"):
		pos.x -= speed
		
	material.set_shader_parameter("origin", pos)

func _unhandled_input(event)-> void:
	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		deg_dir += event.relative / 30
		if deg_dir.x > 80:
			deg_dir.x = 80
		if deg_dir.y > 80:
			deg_dir.y = 80
		material.set_shader_parameter("rotation", deg_dir)
		
	if event is InputEventMouseButton:
		if event.button_index == 1:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
		return
	
	if event is InputEventKey:
		if event.is_action_pressed("ui_cancel"):
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func update_quad_scale() -> void:
	var viewport_size = get_viewport().size
	
	position = Vector2(viewport_size.x / 2, viewport_size.y /2)

	scale = Vector2(viewport_size.x, viewport_size.y)
