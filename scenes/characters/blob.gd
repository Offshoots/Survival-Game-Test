extends CharacterBody2D

signal slice

var direction: Vector2
var speed = 20
var leap_force_start = 50
var leap_force = 50
var leap_cooldown_freq_start = 20
var leap_cooldown_freq = 20
var push_distance = 130
var push_direction: Vector2
var distance_remaining

#Use Bool for item pickup. If the Item is present for the event that it would be collected, then the bool is true.
#The item will be added to the inventory via the Level scene into the ItemContainerUI, after assisinging the approiate enum to get the correct icon and properties.
var gold : bool = false
var is_dead : bool = false
var leap_cooldown : bool = false
var leap_speed : bool = true

@onready var player = get_tree().get_first_node_in_group('Player')
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var flash_sprite_2d: Sprite2D = $FlashSprite2D


@onready var ray_cast_down: RayCast2D = $RayCastDown
@onready var ray_cast_down_left: RayCast2D = $RayCastDownLeft
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_up_left: RayCast2D = $RayCastUpLeft
@onready var ray_cast_up: RayCast2D = $RayCastUp
@onready var ray_cast_up_right: RayCast2D = $RayCastUpRight
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_down_right: RayCast2D = $RayCastDownRight


var health := 12:
	set(value):
		health = value
		if health <= 0 and is_dead == false:
			#is_dead bool helps to prevent death function from triggering more than once
			is_dead = true
			death()
			Scores.score_enemies_slain += 1
			gold = true
		else:
			gold = false


var normal_speed := 20:
	set(value):
		normal_speed = value

func _physics_process(_delta: float) -> void:
	#Custom code to get blob to stop before reaching the player
	var dist = player.position.distance_to(position)
	if leap_speed == true:
		speed =  leap_force
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
	
	#Check for lead condition and the execute leap physics
	if global_position.distance_to(player.global_position) < 300 and !leap_cooldown:
		leap_visual()
		leap_at_player()
		start_leap_cooldown()
	
	#Move and slide
	move_and_slide()

func leap_visual():
	var tween = create_tween()
	# Move sprite up visually
	var rand_jump_size = randf_range(0.3,0.6)
	tween.tween_property(flash_sprite_2d, "position:y", -40 * rand_jump_size, 0.5 * rand_jump_size).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	# Come back down
	tween.tween_property(flash_sprite_2d, "position:y", 0, 0.5 * rand_jump_size).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func leap_at_player():
	leap_speed = true
	await get_tree().create_timer(0.5).timeout
	leap_speed = false

func start_leap_cooldown():
	leap_cooldown = true
	var rand_cooldown = randi_range(0,leap_cooldown_freq_start)
	var cooldown_time = 0.25 * rand_cooldown
	#print(cooldown_time)
	await get_tree().create_timer(cooldown_time).timeout
	leap_cooldown = false
	

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
		health -= 4
		push_distance = 120
		var target = (player.position - position).normalized() * -1 * push_distance
		push(target)
	if tool == Enum.Tool.AXE:
		$FlashSprite2D.flash()
		health -= 3
		push_distance = 100
		var target = (player.position - position).normalized() * -1 * push_distance
		push(target)

func _on_timer_timeout() -> void:
	pathfind()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed('click'):
		slice.emit()
		print('slice')
