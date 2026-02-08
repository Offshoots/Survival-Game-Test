extends Control

@onready var main_menu_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/MainMenuButton
@onready var quit_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/QuitButton

@onready var victory_label: Label = $MarginContainer/VBoxContainer/PanelContainer/VictoryLabel

@onready var island_stats_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer/PanelContainer3/IslandStatsLabel
@onready var combat_stats_label: Label = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/PanelContainer2/CombatStatsLabel
@onready var sea_stats_label: RichTextLabel = $MarginContainer/VBoxContainer/HBoxContainer/VBoxContainer3/VBoxContainer2/PanelContainer2/SeaStatsLabel

var journey_results = ["Lost at Sea", "Lost in the Storm", "Disappeared in the Maelstrom"]
var victory_threshold = 20
var days_worth_of_supplies = 0
var victory_days = 0
var victory_score = 0
var victory_criteria = 0
var distance = 0

func _ready() -> void:
	if Scores.score_dead == true:
		$VideoStreamPlayer.stop()
		$VideoStreamPlayer.hide()
	main_menu_button.grab_focus()
	island_stats()
	combat_stats()
	sea_stats()
	victoy_chance()
	if Scores.score_dead == true:
		victory_label.text = "Died in Combat"

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
	days_worth_of_supplies = (Scores.score_apples_collected - Scores.score_apples_eaten)/10 #+ Scores.motivation_boost
	for day in range(days_worth_of_supplies):
		print(day)
		distance += randi_range(1,100)
	if days_worth_of_supplies > victory_threshold:
		Scores.victory_chance = true
	if Scores.score_dead == true:
		journey = "Died in Combat"
		distance = 0
	else:
		journey = journey_results.pick_random()
		distance = randi_range(1,100) * days_worth_of_supplies
	if days_worth_of_supplies > 10:
		sea_stats_label.text = "Days Worth of Supplies =  " + "[color=yellow]" + str(days_worth_of_supplies) + "[/color]" + "
		Distance Sailed = " +  "[color=yellow]" + str(distance) + "[/color]" + "
		Journey Result: " + "[color=yellow]" + journey + "[/color]"
	else:
		sea_stats_label.text = "Days Worth of Supplies =  " + "[color=red]" + str(days_worth_of_supplies) + "[/color]" + "
		Distance Sailed = " +  "[color=red]" + str(distance) + "[/color]" + "
		Journey Result: " + "[color=red]" + journey + "[/color]"

func victoy_chance():
	if Scores.victory_chance == true:
		#percent increase in Victory every day passed the victory threshold
		victory_days = (days_worth_of_supplies - victory_threshold)
		victory_score = victory_days * randi_range(1,10)
		for day in range(victory_days):
			victory_score += randi_range(1,10)
		victory_criteria = randi_range(9,100)
		print('chance of victory = ' + str(victory_score) + " vs " + str(victory_criteria))
		if victory_score >= victory_criteria:
			print("YOU WON THE GAME!")
		
