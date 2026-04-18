extends TextEdit

@onready var Gun = $Node3D


func _process(delta: float) -> void:
	set_text(Gun.var.amo)
	pass
