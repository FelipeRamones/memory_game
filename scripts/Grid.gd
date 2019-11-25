extends Node2D

# VAriables to count the pairs player has already discovered
var pairs = 0

# Height and Width of the matrix/board
export (int) var columnsQuantity = 2
export (int) var linesQuantity = 2
export (int) var x_start = 365
export (int) var y_start = 130
export (int) var x_offset = 110
export (int) var y_offset = 110

# Variable to store the Card scene
var card = preload("res://scenes/Card.tscn")

# Variables to keep the card instances data
var first_card_id
var first_card_name
var second_card_id
var second_card_name

# Variable to store an array possible card colors thru animations
var animations = [
preload("res://cards/Card1.tres"),
preload("res://cards/Card2.tres"),
preload("res://cards/Card3.tres"),
preload("res://cards/Card4.tres"),
preload("res://cards/Card5.tres"),
preload("res://cards/Card6.tres"),
preload("res://cards/Card7.tres"),
preload("res://cards/Card8.tres"),
preload("res://cards/Card9.tres"),
preload("res://cards/Card10.tres"),
preload("res://cards/Card11.tres"),
preload("res://cards/Card12.tres"),
preload("res://cards/Card13.tres"),
preload("res://cards/Card14.tres"),
preload("res://cards/Card15.tres"),
preload("res://cards/Card16.tres"),
preload("res://cards/Card17.tres"),
preload("res://cards/Card18.tres")
]

# Variable to keep the selected animations between the 18 to fit the number of necessary pairs
var possible_animations = []

# Variable to keep the number of pairs
var total_pairs

# to check if the player has won the game of not
var player_won = false
var player_lost = false

# to notice if is the first card flipped
var is_first_flipped = "is"

# Variable to receive a random animation from "animations" variable
var selected_animation_index
# Variable to store an array of animations that was already picked to prevent more than 2 spawns of the same color
var selected_animations = []

#Number of cards to be added in each column and each line per level
var increment = 2
#Level gap variable increasing cards
var gap = Global.level * increment

# Function to execute as soon as the node loads
func _ready():
	# System method to make every "rand_range()" random every time the scene opens
	randomize()
	
	# If the sublevel is 1, it means the level was just changed so timer is reseted
	if Global.sub_level == 1:
		Global.time = Global.DEFAULT_TIME
		pass
		
	# If level is 2 then every reaload of this scene the scale of CardKeeper will resize to fit
	if Global.level > 1 and Global.sub_level == 1:
		Global.scale /= Vector2(1.25, 1.25)
		$CardKeeper.apply_scale(Global.scale)
	else:
		$CardKeeper.apply_scale(Global.scale)
		pass
		pass
	
	# Checking if the max level was reached to prevent crash and send message :D
	if Global.level <= Global.MAX_LEVEL and Global.sub_level <= Global.MAX_SUB_LEVEL:
		# Level gapping the lines and columns
		columnsQuantity += gap
		linesQuantity += gap
		
		# Selecting number os animations to sort on the board according to the number of pairs
		_select_animations()
		
		# Making the board matrix
		_build_board()
		pass
	else:
		print("Você zerou o jogo :D congratuleixo!!! \n mas o código ainda tá mei cagado vou automatizar kkkkkk")
		pass
	pass

# Function to select an array of animations according to the number of pairs necessary
func _select_animations():
	
	# Getting the number of pairs by calculating the number of cards in the grid and dividing by two, then keeping it in total_pairs
	total_pairs = round((columnsQuantity * linesQuantity) / 2)
	
	# Selecting animations acording to the number of pairs on the grid and storing it in possible_animations array
	while possible_animations.size() < total_pairs:
		# Selection a random number to be the index of the animations
		selected_animation_index = floor(rand_range(0, animations.size()))
		# Checking if the animation in the given index is already picked
		while possible_animations.count(animations[selected_animation_index]):
			# If it is, looping til find one that isn't
			selected_animation_index = floor(rand_range(0, animations.size()))
			pass
		# Adding the animation in the selected index to possible_animations array
		possible_animations.append(animations[selected_animation_index])
		pass
		
	pass

# Function to instanciate and spawn cards on board
func _build_board():
	# Picking a random card and spawning it on the given position
	for i in columnsQuantity:
		for j in linesQuantity:
			
			# Picking  number to be the animations index
			selected_animation_index = floor(rand_range(0, (possible_animations.size())))
			
			# Checking if the array of already picked animations index already have twice the picked animation index
			while selected_animations.count(selected_animation_index) >= 2:
				# If the array already haves twice the same index then pick a new one and loop if it still invalid, if not confirm pick
				selected_animation_index = floor(rand_range(0, possible_animations.size()))
				pass
			# Add the selected index to the end of "selected_animations" array
			selected_animations.append(selected_animation_index)
			
			# Variable to store the information about the "Card" scene
			var card_info = card.instance()
			
			# Setting the ID of the card according to the index
			card_info.card_id = selected_animation_index
			
			# Sending the info about the new animation to the instanced card
			card_info.frames = possible_animations[selected_animation_index]
			
			# Adding instanced card to the "Game" scene tree
			$CardKeeper.add_child(card_info)
			
			# Receiving signal from Card script to detect click on Area2D's CollisionShape2D
			card_info.connect("card_clicked", self, "_on_card_clicked")
			
			# Receiving signal from Card script to authorize the countdown to the player's defeat (uha!)
			card_info.connect("start_timer", self, "_start_timer")
			
			# Calling the method to set where the cards will spawn
			card_info.position = _cards_spawn_position(i, j)
		pass
	pass
	# Activating _process loop
	set_process(true)
	pass

# Function to set the position in witch the card will spawn in the visual grid
func _cards_spawn_position(column, row):
	# Picks the initial position add the offset between the two cards and multiply by row or column to spawn in the next spot and not in the same
	var new_x = x_start + x_offset * column
	var new_y = y_start + y_offset * row
	
	return Vector2(new_x, new_y)
	pass

# Start game timer
func _start_timer():
	$GameTime.set_one_shot(true)
	$GameTime.set_wait_time(Global.time)
	$GameTime.start()
	pass

# Function process is called once per frame
func _process(delta):
	
	# Makes the label show the time left
	$TimeLabel.set_text(str(round($GameTime.get_time_left())))
	
	# Checks if the player won, if won show a glorious message from 1994 galvão bueno
	if pairs == total_pairs and !player_won:
		print("ACABÔÔÔÔÔ, É TETRAAAAA!!!")
		$GameTime.stop()
		player_won = true
		print("\n\n PRESSIONE ESPAÇO OU ENTER PARA JOGAR A PRÓXIMA FASE \n\n")
		pass
	# Checks if after winning player wanna press a button to next level
	if Input.is_action_just_pressed("ui_accept") and player_won:
		Global.time -= 10
		Global.sub_level += 1
		if Global.sub_level > Global.MAX_SUB_LEVEL:
			Global.level += 1
			Global.sub_level = 1
			Global.time = Global.DEFAULT_TIME
			pass
		get_tree().reload_current_scene()
		pass
	# Checks if a player who lost wanna play again
	if Input.is_action_just_pressed("ui_accept") and player_lost:
		get_tree().reload_current_scene()
		pass
	pass

# If timer runs out player loose
func _on_GameTime_timeout():
	$Background.set_mouse_filter(1)
	print("Tempo Acabou Rapeize :/")
	print("\n\n PRESSIONE ESPAÇO OU ENTER PARA JOGAR NOVAMENTE \n\n")
	player_lost = true
	pass

# Function called when the signal of the card beeing clicked is received
func _on_card_clicked(card_id, card_name):
	# Checks if is the first card clicked then turn off its collider
	if is_first_flipped == "is":
		first_card_id = card_id
		first_card_name = card_name
		$CardKeeper.get_node(first_card_name)._disable_card()
		is_first_flipped = "isn't"
		print("Primeira Carta (ID): ", first_card_id, " \nPrimeira Carta (NOME): ", first_card_name)
		pass
	# Checks if the card is the second clicked then makes background mouse filter become "pass"
	# to avoid other cards being clicked and at last call function do check if the two cards selected makes a pair
	elif is_first_flipped == "isn't":
		second_card_id = card_id
		second_card_name = card_name
		$Background.set_mouse_filter(1)
		print("Segunda Carta (ID): ", second_card_id, " \nSecond Carta (NOME): ", second_card_name)
		_check_for_pair(first_card_id, second_card_id, first_card_name, second_card_name)
		pass
	pass

# Function to check if the two clicked cards makes a pair
func _check_for_pair(id1, id2, name1, name2):
	# if it makes then display a message and pairs++, then move the background filter back to "ignore" and lock the pair collider 
	print("\n ID1: ", id1, "\n ID2: ", id2, "\n NAME1: ", name1, "\n NAME2: ", name2)
	if id1 == id2 and name1 != name2:
		print ("\nIt's a motherf**ckin PAAAAAIR")
		is_first_flipped = "is"
		pairs = pairs + 1
		$CardKeeper.get_node(first_card_name)._disable_card()
		$CardKeeper.get_node(second_card_name)._disable_card()
		$Background.set_mouse_filter(2)
		pass
	# if not a pair then display another message and set a timer to make cards unflip and everything clickable again
	else:
		print("\nNot a pair bro... sorry")
		is_first_flipped = "is"
		$FlipBackTime.set_wait_time(1)
		$FlipBackTime.start()
		pass
	print("\n\n PAIRS: ", pairs, " \n\n")
	pass

# When FlipsBackTime runs out this function is called to unflip both selected cards and make everything clickable again
func _on_FlipBackTime_timeout():
	$CardKeeper.get_node(first_card_name)._unflip_card()
	$CardKeeper.get_node(second_card_name)._unflip_card()
	$Background.set_mouse_filter(2)
	$CardKeeper.get_node(first_card_name)._enable_card()
	$CardKeeper.get_node(second_card_name)._enable_card()
	pass
