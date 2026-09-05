class_name ScoreManager

extends Node

var score : int = 0

func updateScore(value : int) -> void:
	score += value
	
func getSore() -> int:
	return score	
