extends Node

signal clock
signal score(amount: int)

var _time_passed = 0.0

func _process(delta: float) -> void:
	_time_passed += delta
	if _time_passed >= 1:
		var t: int = floori(_time_passed)
		_time_passed -= t
		for i in range(t):
			clock.emit()
