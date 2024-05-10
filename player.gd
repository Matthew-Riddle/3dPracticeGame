extends CharacterBody3D


const SPEED = 15.0
const JUMP_VELOCITY = 10
const LOOKAROUND_SPEED = .008
var push_force = .7
#var basis = Basis()
var rot_x = 0
var rot_y = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _input(event):
	if event is InputEventMouseMotion and Input.is_action_pressed("ui_rotate"):
		rot_x -= event.relative.x * LOOKAROUND_SPEED
		#rot_y -= event.relative.y * LOOKAROUND_SPEED
		transform.basis = Basis()
		rotate_object_local(Vector3(0, 1, 0), rot_x)
		#rotate_object_local(Vector3(1, 0, 0), rot_y)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
	
