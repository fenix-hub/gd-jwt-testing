# Godot Engine JSONWebToken Testing - Docker Action

This is a GitHub action that automatically executes tests on the
[Godot Engine JWT Addon](https://github.com/fenix-hub/godot-engine.jwt)
inside a Docker container.

The `src/` folder contains a Godot Engine 4.x project with a very
small unit testing framework I've written myself to execute tests on the addon.

## Concept

The testing framework is composed of three main classes:

- `TestSuite`: it is a collection of tests belonging to a logical/functional
context. Basically, a test case is defined through a method whose
name starts with the `test_*` prefix.
The TestRunner will pick up automatically any method and execute it.
Inside a test, assertion functions can be used to let the framework
follow the rules and extract a report.
- `TestRunner`: it is the executor of the test suites and test cases.
It can be instantiated, and a list of TestSuites can be provided.
They will be executed in order, then a summary will be generated and
stored by the runner. The summary can be printed manually
or passed to a `TestReport` object.
- `TestReport`: it can be used to generate a formatted
report of the whole test procedure. Files named `passed`,
`table`, and `failures` will be generated, containing the results.

### Example of a TestSuite

```gdscript
class ExampleTestSuite extends TestSuite

func test_example() -> void:
 var a: int = 1
 var b: int = 2
 assert_eq(a + b, 3)
```

### Example of an execution

```gdscript
class Node

func _ready() -> void:
 var test_runner: TestRunner = TestRunner.new()

 test_runner.run([
  ExampleTestSuite.new("example_test_suite")
 ])

 TestReport.new(test_runner.summary).generate()

 quit()
```
