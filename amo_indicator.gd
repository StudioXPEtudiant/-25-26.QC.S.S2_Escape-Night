extends TextEdit

@onready var Gun = $Node3D


func _process(delta: float) -> void:
	text = Gun.var.amo
	pass
