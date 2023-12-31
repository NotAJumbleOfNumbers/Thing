extends Control
var level = 1
signal new_level(level)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$Label.text = "Level " + String(level)
	if get_node("/root/Main").selection == null:
		$DeselectButton.visible = false
	else:
		$DeselectButton.visible = true
	if get_node("/root/Main").won:
		$Label3.percent_visible += 0.025
	else:
		$Label3.percent_visible = 0


func _on_PreviousButton_pressed():
	if level > 1:
		level -= 1
		emit_signal("new_level", level)
		get_node("/root/Main/Sound/restart").play()


func _on_NextButton_pressed():
	if level < 7:
		level += 1
		emit_signal("new_level", level)
		get_node("/root/Main/Sound/restart").play()


func _on_DeselectButton_pressed():
	get_node("/root/Main").selection = null
	get_node("/root/Main/Sound/deselect").play()
	pass # Replace with function body.


func _on_RestartButton_pressed():
	emit_signal("new_level", level)
	get_node("/root/Main/Sound/restart").play()

func _on_button_down():
	get_node("/root/Main/Sound/click").play() # Replace with function body.
