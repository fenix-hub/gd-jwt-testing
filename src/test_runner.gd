extends RefCounted
class_name TestRunner

var summary: Dictionary = {
	tests = [],
	successes = 0,
	failures = 0
}

func run(test_suites: Array[TestSuite]):
	for test_suite in test_suites:
		print("\nRunning test suite: ", test_suite.get_name())
		for method in test_suite.get_method_list():
			if method.name.begins_with("test_"):
				run_test(test_suite, method.name)

func run_test(test_suite: TestSuite, test_name: String):
	var t0: int = Time.get_ticks_usec()
	test_suite.call(test_name)
	var t1: int = Time.get_ticks_usec()
	
	if test_suite.failures > 0:
		print("[FAIL] " + test_name)
		summary.failures += 1
	else:
		print("[PASS] " + test_name)
		summary.successes += 1
	
	summary.tests.append({
		case = test_name,
		suite = test_suite.get_name(),
		duration = (t1 - t0) / 1000.0,
		failures = test_suite.failures,
		successes = test_suite.successes,
		errors = test_suite.errors.duplicate()
	})
	
	test_suite.teardown()
