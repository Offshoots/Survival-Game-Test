extends Control

@onready var main_menu_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/MainMenuButton
@onready var quit_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/QuitButton
@onready var victory_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/VictoryButton
@onready var spacer_6: Control = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Spacer6
@onready var spacer_8: Control = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/Spacer8
@onready var return_container: MarginContainer = $ReturnContainer
@onready var margin_container: MarginContainer = $MarginContainer
@onready var credit_texture: TextureRect = $CreditTexture

@onready var video_stream_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var credit_video_stream_player: VideoStreamPlayer = $CreditVideoStreamPlayer

@onready var victory_label: Label = $MarginContainer/VBoxContainer/PanelContainer/VictoryLabel

@onready var island_stats_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/PanelContainer3/IslandStatsLabel
@onready var combat_stats_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/PanelContainer2/CombatStatsLabel
@onready var sea_stats_label: RichTextLabel = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/VBoxContainer2/PanelContainer2/SeaStatsLabel

var journey_results = ["Lost at Sea", "Lost in the Storm", "Disappeared in the Maelstrom"]
var victory_threshold = 1
var days_worth_of_supplies = 0
var victory_days = 0
var victory_score = 0
var victory_criteria = 0
var distance = 0

var defeat : bool = false
var victory : bool = false

func _ready() -> void:
	Scores.score_plants_harvested = Scores.score_pumpkins_harvested + Scores.score_wheat_harvested + Scores.score_corn_harvested + Scores.score_tomatoes_harvested
	victory_button.hide()
	return_container.hide()
	$CreditTexture.hide()
	if Scores.score_dead == true:
		$VideoStreamPlayer.stop()
		$VideoStreamPlayer.hide()
	main_menu_button.grab_focus()
	island_stats()
	combat_stats()
	sea_stats()
	victoy_chance()
	if victory == true:
		victory_label.text = "Ultimate Victory: You Made it Home!"
		main_menu_button.hide()
		quit_button.hide()
		spacer_6.hide()
		spacer_8.hide()
		victory_button.show()
		victory_button.grab_focus()
		sea_stats_label.text = "Days Worth of Supplies =  " + "[color=green]" + str(days_worth_of_supplies) + "[/color]" + "
		Distance Sailed = " +  "[color=green]" + str(distance) + "[/color]" + "
		Journey Result: " + "[color=green]You made it home![/color]"
	

func _on_main_menu_button_pressed() -> void:
	AudioManager.music_player.stop()
	get_tree().change_scene_to_file("res://scenes/ui/main_menu_ui.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
	
func focus_button():
	main_menu_button.grab_focus()
	

func island_stats():
	island_stats_label.text = "Resources:
	Apples Collected = " + str(Scores.score_apples_collected) + "
	Wood Collected = " + str(Scores.score_wood_collected) + "
	Stone Collected = " + str(Scores.score_stone_collected) + "
	Stone Mined From Great Pyre =  " + str(Scores.stones_mined_from_great_pyre) + "
	Rocks Smashed = " + str(Scores.score_rocks_smashed) + "
	Trees Felled = " + str(Scores.score_trees_felled)  + "
	Plants Harvested = " + str(Scores.score_plants_harvested)  + "
	Fish Caught = " + str(Scores.score_fish_caught) 

func combat_stats():
	combat_stats_label.text = "Gold Collected = " + str(Scores.score_gold_collected) + "
	Days Survived = " + str(Scores.score_days_survived) + "
	Time Survived = " + str(int(Scores.score_total_time)) + "
	Apples Eaten = " + str(Scores.score_apples_eaten) + "
	Pyres Built = " + str(Scores.score_pyres_built) + "
	Enemies Slain = " + str(Scores.score_enemies_slain) + "
	Enemies Killed by Pyre = " + str(Scores.score_enemies_killed_by_pyre) + "
	Enemies Killed by Daylight = " + str(Scores.score_enemies_killed_by_daylight) 
	
func sea_stats():
	var journey : String
	days_worth_of_supplies = (Scores.score_apples_collected - Scores.score_apples_eaten) + Scores.score_tomatoes_harvested * 0.5 + Scores.score_corn_harvested + Scores.score_wheat_harvested * 1.5 + Scores.score_pumpkins_harvested * 3 + Scores.motivation_boost
	for day in range(days_worth_of_supplies):
		print(day)
		distance += randi_range(1,100)
	if days_worth_of_supplies > victory_threshold:
		Scores.victory_chance = true
	if Scores.score_dead == true:
		defeat = true
		victory_label.text = "Died in Combat"
		journey = "Died in Combat"
		distance = 0
	else:
		journey = journey_results.pick_random()
		distance = randi_range(1,100) * days_worth_of_supplies
	if Scores.ship_destroyed == true:
		defeat = true
		journey = "Ship Destory. Stranded. Surrounded."
		distance = 0
	if Scores.score_dead == true and Scores.starved_dead:
		victory_label.text = "Starved to Death"
		journey = "Starved to dead. Find more food."
		distance = 0
	if days_worth_of_supplies > 10:
		sea_stats_label.text = "Days Worth of Supplies =  " + "[color=yellow]" + str(days_worth_of_supplies) + "[/color]" + "
		Distance Sailed = " +  "[color=yellow]" + str(distance) + "[/color]" + "
		Journey Result: " + "[color=yellow]" + journey + "[/color]"
	else:
		sea_stats_label.text = "Days Worth of Supplies =  " + "[color=red]" + str(days_worth_of_supplies) + "[/color]" + "
		Distance Sailed = " +  "[color=red]" + str(distance) + "[/color]" + "
		Journey Result: " + "[color=red]" + journey + "[/color]"

func victoy_chance():
	if Scores.victory_chance == true and defeat == false:
		#percent increase in Victory every day passed the victory threshold
		victory_days = (days_worth_of_supplies - victory_threshold)
		victory_score = victory_days * randi_range(1,10)
		for day in range(victory_days):
			victory_score += randi_range(1,10)
		victory_criteria = randi_range(9,100)
		print('chance of victory = ' + str(victory_score) + " vs " + str(victory_criteria))
		if victory_score >= victory_criteria:
			print("YOU WON THE GAME!")
			victory = true

func _on_victory_button_pressed() -> void:
	$ReturnContainer/ReturnButton.grab_focus()
	margin_container.hide()
	return_container.show()
	video_stream_player.stop()
	$VideoStreamPlayer.hide()
	credit_video_stream_player.stream = preload("res://videos/Family Embrace 3.ogv")
	credit_video_stream_player.play()
	AudioManager.music_player.stream = preload("res://audio/tributary - Lish Grooves.mp3")
	AudioManager.music_player.play()


func _on_credit_video_stream_player_finished() -> void:
	$CreditVideoStreamPlayer.hide()
	credit_texture.texture = load("res://graphics/backgrounds/Final credits The lost viking 3.png")
	$CreditTexture.show()


func _on_return_button_pressed() -> void:
	main_menu_button.show()
	quit_button.show()
	victory_button.hide()
	credit_texture.texture = load("res://graphics/backgrounds/Final credits The lost viking background.png")
	margin_container.show()
	return_container.hide()
	main_menu_button.grab_focus()

func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/levels/level.tscn")
