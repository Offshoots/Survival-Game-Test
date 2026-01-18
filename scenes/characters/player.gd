extends CharacterBody2D

var direction: Vector2
var last_direction: Vector2
var speed = 50
var can_move: bool = true

@onready var move_state_machine = $Animation/AnimationTree.get("parameters/MoveStateMachine/playback")
@onready var tool_state_machine = $Animation/AnimationTree.get("parameters/ToolStateMachine/playback")
var current_tool: Enum.Tool = Enum.Tool.SWORD
var current_seed: Enum.Seed = Enum.Seed.TOMATO

signal tool_use(tool: Enum.Tool, pos: Vector2)
signal diagnose

func _physics_process(_delta: float) -> void:
	if can_move:
		get_basic_input()
		move()
		animate()
	
	#Retain the last direction we traveled so that it can be used for calculating the correct grid coordinate for the tool use animation.
	if direction:
		last_direction = direction

func get_basic_input():
	if Input.is_action_just_pressed("tool_forward") or Input.is_action_just_pressed("tool_backward"):
		var dir = Input.get_axis("tool_backward", "tool_forward")
		current_tool = posmod((current_tool + int(dir)), Enum.Tool.size()) as Enum.Tool
		#print(current_tool)
		$ToolUI.reveal_tool()
		
	if Input.is_action_just_pressed("action"):
		tool_state_machine.travel(Data.TOOL_STATE_ANIMATIONS[current_tool])
		$Animation/AnimationTree.set("parameters/ToolOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		
		
	if Input.is_action_just_pressed("seed_forward"):
		var dir2 = Input.get_action_strength("seed_forward")
		current_seed = posmod((current_seed + int(dir2)), Enum.Seed.size()) as Enum.Seed
		#print(current_seed)
		#print(Data.PLANT_DATA[current_seed]["name"])
		$ToolUI.reveal_seed()
	
	if Input.is_action_just_pressed("diagnose"):
		diagnose.emit()


func move():
	direction = Input.get_vector("left","right","up","down")
	velocity = direction * speed
	move_and_slide()

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
	
	#My code for animations based only on x/y direction (that does work).
	#if direction.x == 1:
		#$Animation/AnimationTree.set("parameters/MoveStateMachine/Walk/blend_position", Vector2.RIGHT)
	#elif direction.x == -1:
		#$Animation/AnimationTree.set("parameters/MoveStateMachine/Walk/blend_position", Vector2.LEFT)
	#elif direction.y == 1:
		#$Animation/AnimationTree.set("parameters/MoveStateMachine/Walk/blend_position", Vector2.DOWN)
	#elif direction.y == -1:
		#$Animation/AnimationTree.set("parameters/MoveStateMachine/Walk/blend_position", Vector2.UP)


func tool_use_emit():
	tool_use.emit(current_tool, position + last_direction * 16 + Vector2(0,4))
	#print('tool')


func _on_animation_tree_animation_started(anim_name: StringName) -> void:
	can_move = false


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	can_move = true
