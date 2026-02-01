extends Node

var hp = 3
var mask_collected = 0

func get_point() -> int:
	return mask_collected

func add_point() -> int:
	mask_collected += 1
	print("Total masks: ", mask_collected)
	return mask_collected

func reduce_hp():
	hp -= 1
	print(hp)
