extends Node
var level = 1
var selfection = null
onready var PlayerList = get_node("PlayerList");
onready var EnemyList = get_node("EnemyList");
onready var HandList = get_node("HandList");


# Called when the node enters the scene tree for the first time.
func _ready():
	OS.center_window();
	connect_cards(HandList)
	connect_cards(PlayerList)
	connect_cards(EnemyList)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	straighten_out_cards(PlayerList)
	straighten_out_cards(EnemyList)
	straighten_out_cards(HandList)
	pass
	

func straighten_out_cards(array):
	for i in range(array.get_children().size()):
		var Card = array.get_children()[i];
		Card.position.x = Card.position.x * 0.9 + (i*100-array.get_children().size()*50+50) * 0.1
		Card.position.y = 0
		pass


func connect_cards(array):
	for i in range(array.get_children().size()):
		array.get_children()[i].connect("selection", self, "_on_Card_selection")
		pass


func _on_Card_selection(node):
	var card = node
	card.queue_free()
	pass # Replace with function body.
