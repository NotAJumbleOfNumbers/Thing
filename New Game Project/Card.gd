extends Node2D


# Declare member variables here. Examples:
export var attack = 0
# var b = "text"
signal selection(node)
# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = String(attack)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var mouse_position = get_parent().get_global_mouse_position();
	var heavy_rect = get_node("23F9").get_rect();
	heavy_rect.position += get_node("23F9").global_position;
	if heavy_rect.has_point(mouse_position):
		if Input.is_action_just_pressed("mouse_click"):
			emit_signal("selection", get_node("."))



