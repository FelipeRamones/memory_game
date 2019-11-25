extends Node

# Constant to reset the timer (the initial level 1 sublevel 1 countdown)
const DEFAULT_TIME = 200

# To keep the max level of the game
const MAX_LEVEL = 2

# To keep the max sub level of the game
const MAX_SUB_LEVEL = 5

# Default time to lose (to be controlled by the game script)
var time

# To be incremented every level up
var level = 1

# To keep the same scene only changing time
var sub_level = 1

# To save and manipulate CardKeeper scale
var scale = Vector2(1, 1)