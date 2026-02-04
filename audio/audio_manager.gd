extends Node

@onready var music_player := AudioStreamPlayer.new()

func _ready():
	add_child(music_player)
