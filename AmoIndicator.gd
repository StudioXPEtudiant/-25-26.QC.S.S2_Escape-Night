extends Label
var munitions = 10

func _process(_delta):
	# Conversion du nombre en texte avec str()
	text = "Munitions : " + str(munitions)

func _on_joueur_munitions_changed(nouvelle_valeur):
	text = "Munitions : %d" % nouvelle_valeur
