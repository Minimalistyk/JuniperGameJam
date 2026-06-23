extends Node

const SCENES: Dictionary[Constants.SCENES, PackedScene] ={
	Constants.SCENES.MAIN_GAME: preload("uid://62jijxfiyxfs"),
	Constants.SCENES.INTRO: preload("uid://dwmmmpo5ebglc"),
	Constants.SCENES.START_MENU: preload("uid://cos1amfkutc00")
}

func change_scene_to(destination: Constants.SCENES):
	get_tree().change_scene_to_packed(SCENES[destination])
