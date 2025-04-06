extends Node2D

var phase: float = 0

func _ready() -> void:
	phase = randf() * 2 * PI

func _process(delta: float) -> void:
	phase += randf_range(1, 5) * delta
	phase = fmod(phase, 2 * PI)
	rotation = sin(phase) * 0.1
