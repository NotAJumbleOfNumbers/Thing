extends Node2D


# Declare member variables here. Examples:
export var attack = 1
export var health = 3
export var cost = 1
export var taunt = 0
export var attackGainedAfterAttack = 0
export var cleaving = false
export var damage_on_death = 0
export var energy_on_death = 0
export var bodies_on_death : Array = [0, 0, 0]
export var energy_overkill = false
export var deathtouch = false
export var vanilliser = false
export var description = "[center]A bird that chirps.[/center]"
export var icon = preload("res://icon.png")
var base_attack 
var base_health 
var dying = false

# var b = "text"
signal selection(node)
# Called when the node enters the scene tree for the first time.
func _ready():
	base_attack = attack
	base_health = health
	global_position.x = 512
	global_position.y = -200
	$Label.text = String(attack)
	$Label2.text = String(health)
	$Label3.text = String(cost)
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
		z_index = 1
		var traits_text : String = ""
		if taunt != 0:
			traits_text = traits_text + "\nTaunt level " + String(taunt)
		if cleaving: 
			traits_text = traits_text + "\nCleaving"
		if damage_on_death != 0:
			traits_text = traits_text + "\nOn death, deals " + String(damage_on_death) +" damage to all enemies"
		if energy_on_death != 0:
			traits_text = traits_text + "\nOn death, gain " + String(energy_on_death) +" energy"
		if attackGainedAfterAttack != 0:
			traits_text = traits_text + "\nAfter attack, gains " + String(attackGainedAfterAttack) +" attack"
		if energy_overkill:
			traits_text = traits_text + "\nExcess damage is gained as energy"
		if deathtouch:
			traits_text = traits_text + "\nAny damage dealt by this card is lethal"
		if vanilliser:
			traits_text = traits_text + "\nWhen attacking another card, removes all of that card's traits"
		if bodies_on_death[0] != 0:
			traits_text = traits_text + "\nOn death, spawns " + String(bodies_on_death[0]) + " " + String(bodies_on_death[1]) + "/" + String(bodies_on_death[2]) + " creatures"
		var format_string = "[center]Base stats: {atk} attack, {hp} health[/center]"+traits_text+"\n{desc}"
		$Description.bbcode_text = format_string.format({"atk": base_attack, "hp":base_health, "desc":description})
		$Description.rect_size.y = 0
		$Description.visible = true
		$NinePatchRect.visible = true
		$Description.set_global_position(get_viewport().get_mouse_position())
		$NinePatchRect.rect_position.x = $Description.rect_position.x - 6
		$NinePatchRect.rect_size.x = $Description.rect_size.x + 12
		$NinePatchRect.rect_position.y = $Description.rect_position.y - 6
		$NinePatchRect.rect_size.y = $Description.rect_size.y + 12
	else:
		z_index = 0
		$Description.visible = false
		$NinePatchRect.visible = false
	if Input.is_action_just_pressed("mouse_click") and heavy_rect.has_point(mouse_position):
		emit_signal("selection", get_node("."))



