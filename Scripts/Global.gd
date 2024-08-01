extends Node

# These two variables are used to communicate between differents nodes so that checks for checking
# if fire is actually being used can begin.
var castingFire : bool = false
var castingForce : bool = false

var inMenu : bool = false
var canEnterMenu : bool = true # In cases like the intro scene or the ending scene, the player cannot enter the menu.

var currentDir : String = ""

# MAIN MENU | Main Menu
# FOREST | Forest
# CAVE ONE | CaveOne
# CAVE TWO | CaveTwo
var currentScene : String = "Main Menu"

var signDia : int = 0
var diaPlaying : bool = false
var itemsCollected : bool = false
var endingReady : bool = false

# Variables for if the rocks in the forest scene have reached the river 
var rockLeft : bool = false
var rockRight : bool = false

var birchCollected : bool = false
var mushroomCollected : bool = false
