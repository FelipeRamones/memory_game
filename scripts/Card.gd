extends Area2D

# Variable to receive and store the selected AnimatedFrames for the card from the Game scene
var frames

# Constant for click input
const BUTTONTYPE = "InputEventMouseButton"

# To recognize the card and associate it with it's pair
var card_id

# To check if is flipped of not flipped
var animation_state = true

# Time to first turn
var first_time = 1

# Signal to be emited when card is clicked
signal card_clicked
# Signal to be emited when FirstFlipTimer runs out, authorizing to start the main game timer
signal start_timer

# Function to execute as soon as the node loads
func _ready():
	# Setting timer's time
	$FirstFlipTimer.set_wait_time(first_time)
	
	# Starting the timer
	$FirstFlipTimer.start()
	
	# Telling the AnimatedSprite to change the frames to the selected one in the Game scene
	$AnimatedSprite.set_sprite_frames(frames)
	
	# Disabling the card while first timer still counting down
	_disable_card()
	pass

# Function to get an event related to the card
func _on_Card_input_event(viewport, event, shape_idx):
	# Checking if the mouse button was pressed and if the cards are clickable
	if event.get_class() == BUTTONTYPE and event.pressed == true:
		emit_signal("card_clicked", card_id, self.get_name())
		# If card is flipped, on click unflip and otherwise flip
		if animation_state:
			_unflip_card()
			pass
		else:
			_flip_card()
			pass
		pass
	pass 

# Function to execute when the first timer runs out, start game timer as well as makes cards flip and player be able to click 'em
func _on_FirstFlipTimer_timeout():
	$AnimatedSprite.play("unflip")
	animation_state = false
	_enable_card()
	emit_signal("start_timer")
	pass 

# Called to flip card and make the front face up
func _flip_card():
	$AnimatedSprite.play("flip")
	animation_state = true
	pass

# Called to flip card and make the back face up
func _unflip_card():
	$AnimatedSprite.play("unflip")
	animation_state = false
	pass

# Function to disable collision shape and make card not clickable
func _disable_card():
	$CollisionShape2D.set_disabled(true)
	pass

# Function to enable collision shape and make card clickable
func _enable_card():
	$CollisionShape2D.set_disabled(false)
	pass
