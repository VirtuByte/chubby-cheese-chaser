extends Label

func _ready() -> void:
	self.text = "Score: " + str(GameManager.get_score())
	GameManager.score_changed.connect(_on_score_changed)

func _on_score_changed(score: int) -> void:
	self.text = "Score: " + str(score)
