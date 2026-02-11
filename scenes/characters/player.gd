extends CharacterBody2D

var direction: Vector2
var last_direction: Vector2
var speed = 50
var dash = 90
var can_move: bool = true
var player_input: bool = false
var placement_pos : Vector2
var player_destination: Vector2
var heal_click: bool = false

var death_scene = preload("res://scenes/ui/death_screen.tscn")

@onready var move_state_machine = $Animation/AnimationTree.get("parameters/MoveStateMachine/playback")
@onready var tool_state_machine = $Animation/AnimationTree.get("parameters/ToolStateMachine/playback")
var current_tool: Enum.Tool #= Enum.Tool.AXE
var current_seed: Enum.Seed #= Enum.Seed.TOMATO
var current_inventory: Enum.Item 
var new_item : bool = false
var new_tool : bool = false
var inventory : Array[Enum.Item]
var tool_inventory : Array[Enum.Tool]  #= [Enum.Tool.SWORD]
var found_tool : Enum.Tool

@onready var tool_ui: Control = $ToolUI

signal tool_use(tool: Enum.Tool, pos: Vector2)
#signal diagnose

var death : bool = false
var taking_damage : bool = false
var in_enemy_range : bool = false
var dash_cooldown : bool = false
  
var max_health : int = 15
var health := max_health:
	set(value):
		health = value
		print(value)
		if health == 0:
			death = true
			print('You are Dead')


func _ready() -> void:
	pass
	#tool_ui.get_tool_inventory(tool_inventory)

func _physics_process(_delta: float) -> void:
	direction = Vector2.ZERO
	if can_move:
		
		get_basic_input()
		joypad_move()
		#keyboard_move()
		#mouse_move()
		animate()
	
	
	if in_enemy_range == true and taking_damage == false:
		taking_damage = true
		health -= 1
		await get_tree().create_timer(0.5).timeout
		taking_damage = false
	
	
	if new_tool == true:
		tool_inventory.append(found_tool)
		if tool_inventory.size() == 1:
			current_tool = found_tool
		new_tool = false
		tool_ui.add_tool = true

#Storing items in an array for now, don't know if I'll use
	if new_item == true:
		inventory.append(current_inventory)
	
	#Retain the last direction we traveled so that it can be used for calculating the correct grid coordinate for the tool use animation.
	if direction:
		last_direction = direction

func get_basic_input():
	if Input.is_action_just_pressed("tool_forward") or Input.is_action_just_pressed("tool_backward"):
		if tool_inventory.size() <= 1:
			print("Not Enough Tools")
		else:
			var dir = Input.get_axis("tool_backward", "tool_forward")
			#Using tool_inventory to get the correct size
			#I think posmod would work when the tool numbers are within 1 of each other. Need to check. Coinfimed. Need to fix for inventory scenarios of [0,2] = [sword, pickaxe]
			print(dir)
			var index = 0
			for tool in tool_inventory:
				print(tool)
				if tool == current_tool:
					var next_tool = posmod((index + int(dir)), tool_inventory.size())
					current_tool = tool_inventory[next_tool]
					#print(current_tool)
					$ToolUI.reveal_tool()
					break
				index += 1

	if Input.is_action_just_pressed("action"):
		if tool_inventory.is_empty():
			print("No Tool") 
		else:
			tool_state_machine.travel(Data.TOOL_STATE_ANIMATIONS[current_tool])
			$Animation/AnimationTree.set("parameters/ToolOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	#Create tool action based on mouse click and distance to target
	if Input.is_action_pressed("click"):
		if position.distance_to(player_destination) < 20:
			tool_state_machine.travel(Data.TOOL_STATE_ANIMATIONS[current_tool])
			$Animation/AnimationTree.set("parameters/ToolOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	
	if Input.is_action_just_pressed("dash"):
		dash_speed()
	
	#if Input.is_action_just_pressed("seed_forward"):
		#var dir2 = Input.get_action_strength("seed_forward")
		#current_seed = posmod((current_seed + int(dir2)), Enum.Seed.size()) as Enum.Seed
		#$ToolUI.reveal_seed()
	
	#if Input.is_action_just_pressed("diagnose"):
		#diagnose.emit()
	
	

#Use Input Event to create mouse click registered movement
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and heal_click == false:
		player_destination = get_global_mouse_position()
		player_input = true

#Write code for "keysboard keys" arrow movement
func keyboard_move():
	direction = Input.get_vector("left","right","up","down")
	velocity = direction * speed
	move_and_slide()

func joypad_move():
	if Input.is_action_pressed("left"):
		direction.x = -1
	if Input.is_action_pressed("right"):
		direction.x = 1
	if Input.is_action_pressed("up"):
		direction.y = -1
	if Input.is_action_pressed("down"):
		direction.y = 1
	velocity = direction * speed
	move_and_slide()

func dash_speed():
	if dash_cooldown == false:
		dash_cooldown = true
		speed = dash
		await get_tree().create_timer(0.3).timeout
		speed = 50
		$Timer.start()
		#await get_tree().create_timer(0.5).timeout
		#dash_cooldown = false

func mouse_move():
	if player_input == true:
		direction = position.direction_to(player_destination)
		velocity = direction * speed
	else:
		direction = Vector2.ZERO
		velocity = Vector2.ZERO
	#smooth out movement by having "move and slide" called at greatest distance to target
	if position.distance_to(player_destination) > 10:
		move_and_slide()
	
	#When player reaches destination, have diction and velocity go to 0,0 for "Idel" animations
	if position.distance_to(player_destination) < 10:
		direction = Vector2.ZERO
		velocity = Vector2.ZERO

func animate():
	#Use of State Machine for movement animations
	if direction:
		move_state_machine.travel('Walk')
		var direction_animation = Vector2(round(direction.x),round(direction.y))
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Idle/blend_position", direction_animation)
		$Animation/AnimationTree.set("parameters/MoveStateMachine/Walk/blend_position", direction_animation)
		for animation in Data.TOOL_STATE_ANIMATIONS.values():
			$Animation/AnimationTree.set("parameters/ToolStateMachine/" + animation + "/blend_position", direction_animation)
	else:
		move_state_machine.travel('Idle')

func tool_use_emit():
	placement_pos = position + last_direction * 8 #+ Vector2(0,4)
	tool_use.emit(current_tool, placement_pos)
	#print(placement_pos)

func _on_animation_tree_animation_started(_anim_name: StringName) -> void:
	can_move = false

func _on_animation_tree_animation_finished(_anim_name: StringName) -> void:
	can_move = true


func _on_timer_timeout() -> void:
	dash_cooldown = false
	
