extends CharacterBody2D

signal slice

var direction: Vector2
var speed = 20
var push_distance = 130
var push_direction: Vector2
var distance_remaining

#Use Bool for item pickup. If the Item is present for the event that it would be collected, then the bool is true.
#The item will be added to the inventory via the Level scene into the ItemContainerUI, after assisinging the approiate enum to get the correct icon and properties.
var gold : bool = false
var is_dead : bool = false

@onready var player = get_tree().get_first_node_in_group('Player')
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

@onready var ray_cast_down: RayCast2D = $RayCastDown
@onready var ray_cast_down_left: RayCast2D = $RayCastDownLeft
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_up_left: RayCast2D = $RayCastUpLeft
@onready var ray_cast_up: RayCast2D = $RayCastUp
@onready var ray_cast_up_right: RayCast2D = $RayCastUpRight
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_down_right: RayCast2D = $RayCastDownRight


var health := 3:
	set(value):
		health = value
		if health <= 0 and is_dead == false:
			is_dead = true
			death()
			gold = true
		else:
			gold = false


var normal_speed := 20:
	set(value):
		normal_speed = value

func _physics_process(_delta: float) -> void:
	#Custom code to get blob to stop before reaching the player
	var dist = player.position.distance_to(position)
	if dist > 300:
		speed =  200
	else:
		speed = normal_speed
	direction = to_local(nav_agent.get_next_path_position()).normalized()
	#Code to change direction of the blob if it gets too close to obstacles with collision shapes, using raycast.
	#if ray_cast_down.is_colliding():
		#push_distance = 20
		#var target = direction * -1 * push_distance
		#push(target)
	#if ray_cast_down_left.is_colliding():
		#push_distance = 20
		#var target = direction * -1 * push_distance
		#push(target)
	#if ray_cast_left.is_colliding():
		#push_distance = 20
		#var target = direction * -1 * push_distance
		#push(target)
	#if ray_cast_up_left.is_colliding():
		#push_distance = 20
		#var target = direction * -1 * push_distance
		#push(target)
	#if ray_cast_up_left.is_colliding():
		#push_distance = 20
		#var target = direction * -1 * push_distance
		#push(target)
	#if ray_cast_up_right.is_colliding():
		#push_distance = 20
		#var target = direction * -1 * push_distance
		#push(target)
	#if ray_cast_right.is_colliding():
		#push_distance = 20
		#var target = direction * -1 * push_distance
		#push(target)
	#if ray_cast_down_right.is_colliding():
		#push_distance = 20
		#var target = direction * -1 * push_distance
		#push(target)
	
	distance_remaining = player.position.distance_to(position)
	#direction = (player.position - position).normalized()
	velocity = direction * speed + push_direction
	move_and_slide()

func pathfind():
	nav_agent.target_position = player.position

func death():
	speed = 0
	$CollisionShape2D.queue_free()
	$Animation/AnimationPlayer.current_animation = 'explode'

func push(target):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "push_direction", target, 0.1)
	tween.tween_property(self, "push_direction", Vector2.ZERO, 0.2)

#Tree will flash when hit via shader created called flash.tres and applied to new sprite 2d scene we created called "flash_sprite_2d" and instantiated into ther Tree node.
func hit(tool: Enum.Tool):
	if tool == Enum.Tool.SWORD:
		$FlashSprite2D.flash()
		health -= 3
		push_distance = 150
		var target = (player.position - position).normalized() * -1 * push_distance
		push(target)
	if tool == Enum.Tool.AXE:
		#$FlashSprite2D.flash()
		health -= 1
		push_distance = 100
		var target = (player.position - position).normalized() * -1 * push_distance
		push(target)

func _on_timer_timeout() -> void:
	pathfind()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed('click'):
		slice.emit()
		print('slice')
