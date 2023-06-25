extends Node2D


# Declare member variables here. Examples:
export var attack = 1
export var health = 3
export var cost = 2
export var description = "[center]Test description.  This bird is so silly!!![/center]"
export var icon = preload("res://icon.png")

# var b = "text"
signal selection(node)
# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = String(attack)
	$Label2.text = String(health)
	$Label3.text = String(cost)
	$RichTextLabel.bbcode_text = description
	$Sprite.texture = icon
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = String(attack)
	$Label2.text = String(health)
	$Label3.text = String(cost)
	if get_node("/root/Main").won:
		$Sprite.rotation_degrees += 360*delta
	var mouse_position = get_parent().get_global_mouse_position();
	var heavy_rect = get_node("23F9").get_rect();
	heavy_rect.position += get_node("23F9").global_position;
	if (heavy_rect.has_point(mouse_position) or get_node("/root/Main").selection == get_node(".")) and not get_node("/root/Main").won:
		$border.visible = true
	else:
		$border.visible = false
	if heavy_rect.has_point(mouse_position):
		$RichTextLabel.visible = true
	else:
		$RichTextLabel.visible = false
	if Input.is_action_just_pressed("mouse_click") and heavy_rect.has_point(mouse_position):
		emit_signal("selection", get_node("."))



