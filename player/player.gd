class_name Player extends CharacterBody2D

signal health_changed(new_health)
signal died

const WALK_SPEED := 300.0
const ACCELERATION_SPEED := WALK_SPEED * 6.0
const JUMP_VELOCITY := -725.0
const TERMINAL_VELOCITY := 700

@export var max_health := 5
var health := max_health: set = set_health

var gravity: int = ProjectSettings.get("physics/2d/default_gravity")

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		try_jump()
	elif Input.is_action_just_released("jump") and velocity.y < 0.0:
		velocity.y *= 0.6
	velocity.y = minf(TERMINAL_VELOCITY, velocity.y + gravity * delta)
	
	var direction := Input.get_axis("move_left", "move_right") * WALK_SPEED
	velocity.x = move_toward(velocity.x, direction, ACCELERATION_SPEED * delta)
	
	move_and_slide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		try_attack()
	

func try_jump() -> void:
	if not is_on_floor():
		return
	$Jump.play()	
	velocity.y = JUMP_VELOCITY

func try_attack() -> void:
	pass

func set_health(new_health: int) -> void:
	health = clamp(new_health, 0, max_health)
	emit_signal("health_changed", new_health)

func take_damage(amount: int) -> void:
	set_health(health - amount)
	if health == 0:
		emit_signal("died")
