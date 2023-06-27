extends Node
var energy = 3
var won = false
var selection = null
onready var PlayerList = get_node("PlayerList");
onready var EnemyList = get_node("EnemyList");
onready var HandList = get_node("HandList");



# Called when the node enters the scene tree for the first time.
func _ready():
	# OS.shell_open("https://example.com/")
	randomize()
	OS.center_window();
	load_level(1)
# warning-ignore:return_value_discarded
	$HUD.connect("new_level", self, "load_level")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	straighten_out_cards()

func straighten_out_cards():
	for array in [PlayerList, EnemyList, HandList]:
		for i in range(array.get_children().size()):
			var Card = array.get_children()[i];
			Card.position.x = Card.position.x * 0.9 + (i*100-array.get_children().size()*50+50) * 0.1
			Card.position.y = Card.position.y * 0.9 + Card.taunt * 0.5

func connect_cards():
	for array in [PlayerList, EnemyList, HandList]:
		for i in range(array.get_children().size()):
			array.get_children()[i].connect("selection", self, "_on_Card_selection")

func _on_Card_selection(node):
	var card = node
	if selection == null:
		selection = card
		$Sound/select.play()
	else:
		perform_action(selection, card)
		selection = null

func perform_action(first_card, second_card):
	if first_card == second_card and first_card.get_parent() == get_node("HandList"):
		play(first_card)
	elif first_card.get_parent() == get_node("PlayerList") and second_card.get_parent() == get_node("EnemyList"):
		var highest_taunt = -INF
		for i in range(EnemyList.get_children().size()):
			if EnemyList.get_children()[i].taunt > highest_taunt:
				highest_taunt = EnemyList.get_children()[i].taunt 
		if second_card.taunt == highest_taunt:
			fight(first_card, second_card)
	else:
		$Sound/invalid.play()

func fight(first_card, second_card):
	second_card.health -= first_card.attack
	first_card.health -= second_card.attack
	if first_card.cleaving:
		if second_card.get_index() > 0:
			EnemyList.get_children()[second_card.get_index()-1].health -= first_card.attack
		if second_card.get_index() < EnemyList.get_children().size()-1:
			EnemyList.get_children()[second_card.get_index()+1].health -= first_card.attack
	if second_card.cleaving:
		if first_card.get_index() > 0:
			PlayerList.get_children()[first_card.get_index()-1].health -= second_card.attack
		if second_card.get_index() < PlayerList.get_children().size()-1:
			PlayerList.get_children()[first_card.get_index()+1].health -= second_card.attack
	second_card.attack += second_card.attackGainedAfterAttack
	first_card.attack += first_card.attackGainedAfterAttack
	cleanup()

func cleanup():
	var cleanup_again = false
	for array in [EnemyList, PlayerList]:
		var to_be_deleted = []
		for i in range(array.get_children().size()):
			if array.get_children()[i].health <= 0:
				energy += array.get_children()[i].energy_on_death
				if array.get_children()[i].energy_overkill:
					energy -= min(array.get_children()[i].health, 0)
				to_be_deleted.append(array.get_children()[i])
		for deleted_card in to_be_deleted:
			deleted_card.queue_free()
			array.remove_child(deleted_card)
			if deleted_card.damage_on_death != 0:
				if array == EnemyList:
					for damaged_card in PlayerList.get_children():
						damaged_card.health -= deleted_card.damage_on_death
						cleanup_again = true
				else:
					for damaged_card in EnemyList.get_children():
						damaged_card.health -= deleted_card.damage_on_death
						cleanup_again = true
			if deleted_card.bodies_on_death[0] != 0:
				for _j in range(min(deleted_card.bodies_on_death[0], 7-array.get_children().size())):
					var loadingcard : PackedScene = load("res://Card.tscn")
					var loadedcard = loadingcard.instance()
					loadedcard.attack = deleted_card.bodies_on_death[1]
					loadedcard.health = deleted_card.bodies_on_death[2]
					array.add_child(loadedcard)
	if cleanup_again == true:
		cleanup()
	else:
		for array in [EnemyList, PlayerList]:
			for i in range(array.get_children().size()):
				array.get_children()[i].attack = clamp(array.get_children()[i].attack, 0, 99)
				array.get_children()[i].health = clamp(array.get_children()[i].health, 0, 99)
		energy = clamp(energy, 0, 20)
		if EnemyList.get_children().size() == 0:
			won = true
			$Sound/win.play()
			selection = null

func play(card):
	if energy >= card.cost and PlayerList.get_children().size() < 7:
		$Sound/playcard.play()
		energy -= card.cost
		card.position.x = 0
		card.get_parent().remove_child(card)
		PlayerList.add_child(card)
	else:
		$Sound/invalid.play()

# warning-ignore:unused_argument
func load_level(level):
	for array in [PlayerList, EnemyList, HandList]:
		for i in range(array.get_children().size()):
				array.get_children()[i].queue_free()
	var loadinglevel : PackedScene = load("res://levels/level"+String(level)+".tscn")
# warning-ignore:unused_variable
	var loadedlevel = loadinglevel.instance()
	energy = loadedlevel.starting_energy
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
	selection = null
	won = false
	connect_cards()
