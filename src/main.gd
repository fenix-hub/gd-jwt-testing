extends SceneTree


func _init():
	var test_runner: TestRunner = TestRunner.new()
	
	test_runner.run([
		ExampleTestSuite.new("example_test_suite")
	])
	
	TestReport.new(test_runner.summary).generate()
	
	quit()