extends Node2D
@export var joueurs: Array = ["Mona","Paul","Camille","Gabriel","Ewen"]
var tour: int = 0
var roles: Dictionary
var mot_gentils: String
var mot_undercover: String
var switch: bool = true
@export var white_enabled: bool = true

func load_file(path):
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var content: String = file.get_as_text()
	return content
	


# Called when the node enters the scene tree for the first time.
func _ready():

	joueurs.shuffle()

	#init_mots
	print(joueurs)
	var arrayMotsStr: String = load_file("res://mots.txt")
	var arrayMots: PackedStringArray = arrayMotsStr.rsplit("\n",false)
	var mots: String = arrayMots[randi_range(0,len(arrayMots)-1)]

	var arrayFinalMots: PackedStringArray = mots.rsplit(";",false)
	
	if randi_range(0,1)==0:
		arrayFinalMots.reverse()
	mot_undercover = arrayFinalMots[0]
	mot_gentils = arrayFinalMots[1]
	
	#init_roles
	var gentils: Array = joueurs.duplicate(true)
	roles = {
		"gentils" : gentils,
		"undercover" : [],
		"white" : []
	}
	var nbr_undercover: int = randi_range(0,len(joueurs)-1)
	roles.get("undercover").append(joueurs[nbr_undercover])
	roles.get("gentils").remove_at(nbr_undercover)
	if white_enabled :
		var nbr_white: int = randi_range(0,len(joueurs)-1)
		while nbr_white==nbr_undercover:
			nbr_white = randi_range(0,len(joueurs)-1)
		roles.get("white").append(joueurs[nbr_white])
		roles.get("gentils").remove_at(nbr_white)
	print(joueurs)
	print(roles)
	
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func hide_phase1():
	$Mot.visible = false
	$Tour.visible = false
	$Button.visible = false

func show_phase2():
	$ElimHBox.visible=true
	$Result.visible = true
	$Elimines.visible=true

func _on_button_pressed():
	if tour<len(joueurs):
		if !switch:
			#affiche la bonne info
			
			var joue: String = joueurs[tour]
			$Tour.text= joue
			if roles.get("undercover").has(joue):
				#affiche le mot undercover
				$Mot.text = "mot : "+mot_undercover
			elif roles.get("white").has(joue):
				$Mot.text = "mot : aucun (tu es mister white)"
			else:
				$Mot.text = "mot : "+mot_gentils
			switch = true
			tour+=1
		else:
			$Tour.text = "C'est à "+joueurs[tour]
			$Mot.text = ""
			switch = false
	else:
		hide_phase1()
		
		show_phase2()
		
	
func eliminate(joueur):
	if(roles.get("undercover").has(joueur)):
		$Result.text = "Bravo, "+joueur+" était bien l'undercover"
		$Restart.visible = true
	elif roles.get("white").has(joueur):
		$Result.text = "Bravo, "+joueur+" était mister white"
		$Restart.visible = true
		
	else:
		$Result.text = "Dommage, essayez encore"
		get_node("ElimHBox/"+joueur).visible = false
		#get_node(joueur).visible = false
		$Elimines.text = $Elimines.text+joueur+", "
		
func _on_mona_pressed():
	eliminate("Mona")


func _on_paul_pressed():
	eliminate("Paul")


func _on_camille_pressed():
	eliminate("Camille")


func _on_gabriel_pressed():
	eliminate("Gabriel")


func _on_ewen_pressed():
	eliminate("Ewen")


func _on_restart_pressed():
	get_tree().reload_current_scene()
