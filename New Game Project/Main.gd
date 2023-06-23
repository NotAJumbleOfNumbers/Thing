extends Node
var level = 1
onready var PlayerList = get_node("PlayerList");
onready var EnemyList = get_node("EnemyList");

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.center_window();
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for i in range(PlayerList.get_children().size()):
		var Card = PlayerList.get_children()[i];
		Card.position.x = Card.position.x * 0.9 + (i*100-PlayerList.get_children().size()*50+50) * 0.1
		Card.position.y = 0
		pass
	for i in range(EnemyList.get_children().size()):
		var Card = EnemyList.get_children()[i];
		Card.position.x = Card.position.x * 0.9 + (i*100-EnemyList.get_children().size()*50+50) * 0.1
		Card.position.y = 0
		pass
	pass
	
