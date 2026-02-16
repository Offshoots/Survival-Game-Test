extends CharacterBody2D

signal slice
signal ship_damaged

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
var leap_speed : bool = false
var tracking : bool = false

@onready var player = get_tree().get_first_node_in_group('Player')
@onready var ship = get_tree().get_first_node_in_group('Ship')
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var flash_sprite_2d: Sprite2D = $FlashSprite2D


var days
var elapsed_attack_time = 0.0
var damage_interval = 5
var target
var rand_vector
var colors : Array[Enum.Blob] = [Enum.Blob.BLUE, Enum.Blob.GREEN, Enum.Blob.RED]
var color_selected : Enum.Blob


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

func _ready() -> void:
	days = Scores.score_days_survived
	#Assign Target for blob
	target = [player, ship].pick_random()
	rand_vector = Vector2(randi_range(-50,50),0)
	print(target)
	print(colors)
	color_selected = colors.pick_random()
	print(color_selected)


func _physics_process(delta: float) -> void:
	if player.inside_dungeon == false:
		if tracking:
			elapsed_attack_time += delta
			if elapsed_attack_time > damage_interval:
				elapsed_attack_time -= damage_interval
				ship_damaged.emit()
		
		if leap_speed == true:
			speed =  leap_force
		else:
			speed = normal_speed
		direction = to_local(nav_agent.get_next_path_position()).normalized()
		velocity = direction * speed + push_direction
		
		#Check for lead condition and the execute leap physics
		if days > 3:
			normal_speed = 25
		if days > 5:
			normal_speed = 30
			leap_force = 55
		if days > 9:
			normal_speed = 35
			leap_force = 60
			
		if color_selected == Enum.Blob.RED:
			if days > 4:
				flash_sprite_2d.modulate = Color("ff005f")
				normal_speed = 70
		if color_selected == Enum.Blob.GREEN:
			if days > 3:
				flash_sprite_2d.modulate = Color("00ff00")
				if global_position.distance_to(target.global_position) < 300 and !leap_cooldown:
					leap_visual()
					leap_at_target()
					start_leap_cooldown()
		move_and_slide()

func leap_visual():
	var tween = create_tween()
	# Move sprite up visually
	var rand_jump_size = randf_range(0.2,0.4)
	tween.tween_property(flash_sprite_2d, "position:y", -40 * rand_jump_size, 0.5 * rand_jump_size).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	# Come back down
	tween.tween_property(flash_sprite_2d, "position:y", 0, 0.5 * rand_jump_size).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

func leap_at_target():
	leap_speed = true
	await get_tree().create_timer(0.5).timeout
	leap_speed = false

func start_leap_cooldown():
	leap_cooldown = true
	var rand_cooldown = randi_range(0,leap_cooldown_freq_start)
	var cooldown_time = 0.25 * rand_cooldown
	await get_tree().create_timer(cooldown_time).timeout
	leap_cooldown = false
	

func pathfind():
	if target == ship:
		#Add some randomness to the attack vector on the ship
		nav_agent.target_position = target.position + rand_vector
	else:
		nav_agent.target_position = target.position

func death():
	if tracking == true:
		tracking = false
	if is_instance_valid($CollisionShape2D):
		normal_speed = 0
		$CollisionShape2D.queue_free()
		$Animation/AnimationPlayer.current_animation = 'explode'

func push(hit_target):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "push_direction", hit_target, 0.1)
	tween.tween_property(self, "push_direction", Vector2.ZERO, 0.2)

#Tree will flash when hit via shader created called flash.tres and applied to new sprite 2d scene we created called "flash_sprite_2d" and instantiated into ther Tree node.
func hit(tool: Enum.Tool):
	if tool == Enum.Tool.SWORD:
		$FlashSprite2D.flash()
		if player.inventory.count(Enum.Item.STRENGTH) > 0:
			health -= 12
			push_distance = 200
		else:
			health -= 4
			push_distance = 120
		var hit_target = (player.position - position).normalized() * -1 * push_distance
		push(hit_target)
	if tool == Enum.Tool.AXE:
		$FlashSprite2D.flash()
		if player.inventory.count(Enum.Item.STRENGTH) > 0:
			health -= 12
			push_distance = 200
		else:
			health -= 3
			push_distance = 100
		var hit_target = (player.position - position).normalized() * -1 * push_distance
		push(hit_target)

func _on_timer_timeout() -> void:
	pathfind()

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed('click'):
		slice.emit()
