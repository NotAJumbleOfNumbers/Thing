extends Node
var level = 1
var energy = 3
var won = false
var selection = null
onready var PlayerList = get_node("PlayerList");
onready var EnemyList = get_node("EnemyList");
onready var HandList = get_node("HandList");


# Called when the node enters the scene tree for the first time.
func _ready():
	OS.center_window();
	load_level(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	straighten_out_cards()
	if EnemyList.get_children().size() == 0:
		won = true
		selection = null

func straighten_out_cards():
	for array in [PlayerList, EnemyList, HandList]:
		for i in range(array.get_children().size()):
			var Card = array.get_children()[i];
			Card.position.x = Card.position.x * 0.9 + (i*100-array.get_children().size()*50+50) * 0.1
			Card.position.y = Card.position.y * 0.9

func connect_cards():
	for array in [PlayerList, EnemyList, HandList]:
		for i in range(array.get_children().size()):
			array.get_children()[i].connect("selection", self, "_on_Card_selection")

func _on_Card_selection(node):
	var card = node
	if selection == null:
		selection = card
	else:
		perform_action(selection, card)
		selection = null

func perform_action(first_card, second_card):
	if first_card == second_card:
		if first_card.get_parent() == get_node("HandList"):
			play(first_card)
	if first_card.get_parent() == get_node("PlayerList") and second_card.get_parent() == get_node("EnemyList"):
		fight(first_card, second_card)

func fight(first_card, second_card):
	second_card.health -= first_card.attack
	first_card.health -= second_card.attack
	cleanup()

func cleanup():
	for array in [PlayerList, EnemyList, HandList]:
		for i in range(array.get_children().size()):
			if array.get_children()[i].health <= 0:
				array.get_children()[i].queue_free()
	connect_cards()

func play(card):
	if energy >= card.cost:
		energy -= card.cost
		card.get_parent().remove_child(card)
		PlayerList.add_child(card)

# warning-ignore:unused_argument
func load_level(number):
	for array in [PlayerList, EnemyList, HandList]:
		for i in range(array.get_children().size()):
				array.get_children()[i].queue_free()
	var loadinglevel : PackedScene = load("res://levels/level1.tscn")
# warning-ignore:unused_variable
	var loadedlevel = loadinglevel.instance()
	EnemyList.queue_free();
	PlayerList.queue_free();
	HandList.queue_free();
	remove_child(EnemyList);
	remove_child(PlayerList);
	remove_child(HandList);
	EnemyList = loadedlevel.get_node("EnemyList");
	PlayerList = loadedlevel.get_node("PlayerList");
	HandList = loadedlevel.get_node("HandList");
	loadedlevel.remove_child(EnemyList);
	loadedlevel.remove_child(PlayerList);
	loadedlevel.remove_child(HandList);
	add_child(EnemyList);
	add_child(PlayerList);
	add_child(HandList);
	loadedlevel.queue_free();
	won = false
	connect_cards()
