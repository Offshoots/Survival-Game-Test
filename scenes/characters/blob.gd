extends CharacterBody2D


var direction: Vector2
var speed = 20
var push_distance = 130
var push_direction: Vector2
@onready var player = get_tree().get_first_node_in_group('Player')


var health := 3:
	set(value):
		health = value
		print(value)
		if health <= 0:
			death()
			$CollisionShape2D.queue_free()
			#Need to queue free the blob collosion node to prevent it from pusing me around.


func _physics_process(_delta: float) -> void:
	#Custom code to get blob to stop before reaching the player
	#var dist = player.position.distance_to(position)
	#if dist > 20:
		#speed =  20
	#else:
		#speed = 0
	
	direction = (player.position - position).normalized()
	velocity = direction * speed + push_direction
	move_and_slide()

func death():
	speed = 0
	$Animation/AnimationPlayer.current_animation = 'explode'

func push():
	var tween = get_tree().create_tween()
	var target = (player.position - position).normalized() * -1 * push_distance
	tween.tween_property(self, "push_direction", target, 0.1)
	tween.tween_property(self, "push_direction", Vector2.ZERO, 0.2)

#Tree will flash when hit via shader created called flash.tres and applied to new sprite 2d scene we created called "flash_sprite_2d" and instantiated into ther Tree node.
func hit(tool: Enum.Tool):
	if tool == Enum.Tool.SWORD:
		$FlashSprite2D.flash()
		health -= 1
		push()
