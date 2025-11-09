extends Label

func _ready() -> void:
	var player = $"/root/level/mouse"
	player.score_changed.connect(_on_score_changed)

func _on_score_changed(score: int) -> void:
	self.text = "Score: " + str(score)
