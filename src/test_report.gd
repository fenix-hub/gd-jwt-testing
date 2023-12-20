extends RefCounted
class_name TestReport

var summary: Dictionary = {
	tests = {},
	successes = 0,
	failures = 0
}

var TABLE_FORMAT: String = "|        TEST SUITE        |     TEST CASE     | EXECUTION TIME | SUCCESSES | FAILURES | PASSED | \n" + \
("|%026d|%019d|%016d|%011d|%010d|%08d| \n" % [0, 0, 0, 0, 0, 0]).replacen("0", "-")
var ROW_FORMAT: String = "| %24s | %17s | %14s | %9d | %8d | %6s | \n"

var FAILURES_TABLE_FORMAT: String = "|        TEST SUITE        |     TEST CASE     | FAILURE | \n" + \
("|%026d|%019d|%09d| \n" % [0, 0, 0]).replacen("0", "-")
var FAILURES_ROW_FORMAT: String = "| %24s | %17s | %7s | \n"

func _init(summary: Dictionary) -> void:
	self.summary = summary

func generate() -> void:
	var table: String = TABLE_FORMAT
	var failures: String = FAILURES_TABLE_FORMAT
	
	for test in summary.tests:
		table += ROW_FORMAT % [
			test.suite, test.case, str(test.duration) + "ms", test.successes, 
			test.failures, "✅" if test.failures == 0 else "⛔"
		]
		
		if test.failures > 0:
			for error in test.errors:
				failures += FAILURES_ROW_FORMAT % [test.suite, test.case, error]
	
	var output_path: String = OS.get_environment("OUTPUT_PATH")
	DirAccess.make_dir_recursive_absolute(output_path) 
	
	var file = FileAccess.open(output_path.path_join("table"), FileAccess.WRITE)
	file.store_string(table)
	
	file = FileAccess.open(output_path.path_join("failures"), FileAccess.WRITE)
	file.store_string(failures)
	
	file = FileAccess.open(output_path.path_join("passed"), FileAccess.WRITE)
	file.store_string(str(summary.failures == 0))
	
	print(table)
	print(failures)
