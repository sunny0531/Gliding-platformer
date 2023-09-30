extends Node2D


func _on_portal_2_body_entered(body):
	if body==$Player:
		get_tree().change_scene_to_file("res://MapWorld.tscn")
