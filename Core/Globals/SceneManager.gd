extends Node

#sciezki do scen
#const MAINMENU: PackedScene = preload("uid:xyz")
#const LEVEL1: PackedScene = preload("uid:xyz")
#const LEVEL2: PackedScene = preload("uid:xyz")


func load_next_level(destination: PackedScene):
	get_tree().change_scene_to_packed(destination)

func load_next_level_transison(destination: PackedScene, effect: String):
	#+kod do jakiegos sciemnainia ekranu albo innego efektu, czekanie itd
	#wydaje mi sie ze jesli cosbysmy chcieli to bedzie potrzebny slownik z efektami albo jakis ciąf ifów
	#szczerze jeszcze nie wiem ale zgaduje ze nic z tym nei zrobimy XD
	load_next_level(destination)
