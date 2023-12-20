extends RefCounted
class_name Test

var passed: int = 0
var failures: int = 0

func _init() -> void:
	pass

func _pass() -> void:
	passed += 1

func _fail() -> void:
	failures += 1

func assert_eq(value, expected) -> void:
	if value == expected:
		_pass()
	else:
		_fail()