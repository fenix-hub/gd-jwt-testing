extends RefCounted
class_name TestSuite

var checks: int = 0
var successes: int = 0
var failures: int = 0
var errors: PackedStringArray = []

var name: String = "testsuite_@%d" % (randi() % 1000)

func _init(name: String) -> void:
	self.name = name

func _pass() -> void:
	successes += 1

func _fail(error: String) -> void:
	errors.append(error)
	failures += 1

func assert_has(dictionary: Dictionary, key: Variant) -> void:
	checks += 1
	_pass() if dictionary.has(key) else _fail(
		"Dictionary %s does not contain key '%s'" % [dictionary, str(key)]
	)

func assert_eq(value: Variant, expected: Variant) -> void:
	checks += 1
	_pass() if typeof(value) == typeof(expected) and value == expected else _fail(
		"Actual value '%s' does not equal to expected '%s'" % [str(value), str(expected)]
	)

func teardown() -> void:
	successes = 0
	failures = 0
	checks = 0
	errors.clear()

func get_name() -> String:
	return name
