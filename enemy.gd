class_name Enemy extends CharacterBody2D

signal health_changed(new_health)
signal died

const WALK_SPEED := 200.0
const ACCELERATION_SPEED := WALK_SPEED * 6.0
const TERMINAL_VELOCITY := 700

@export var max_health := 5
var health := max_health: set = set_health

var gravity: int = ProjectSettings.get("physics/2d/default_gravity")
var direction := WALK_SPEED

func _physics_process(delta: float) -> void:
	velocity.y = minf(TERMINAL_VELOCITY, velocity.y + gravity * delta)
	
	if is_on_wall():
		direction *= -1
		
	velocity.x = move_toward(velocity.x, direction, ACCELERATION_SPEED * delta)
	
	move_and_slide()

func set_health(new_health: int) -> void:
	health = clamp(new_health, 0, max_health)
	emit_signal("health_changed", new_health)

func take_damage(amount: int) -> void:
	set_health(health - amount)
	if health == 0:
		emit_signal("died")
