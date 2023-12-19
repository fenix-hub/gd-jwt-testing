extends SceneTree

var test_secret: String = Crypto.new().generate_random_bytes(5).get_string_from_utf8()

var test_cases: Dictionary = {
	"generate" : func(args: Array) : return test_generate(args[0]),
	"verify" : func(args: Array): return test_verify(args[0], args[1])
}

var inputs: Dictionary = {
	"generate": [test_secret],
	"verify": [create_hs256_jwt(test_secret), test_secret]
}



# Called when the node enters the scene tree for the first time.

func create_hs256_jwt(secret: String) -> String:
	var jwt_algorithm: JWTAlgorithm = JWTAlgorithm.HS256.new(secret)
	var jwt_builder: JWTBuilder = JWT.create() \
		.with_expires_at(Time.get_unix_time_from_system()) \
		.with_issuer("Godot") \
		.with_claim("id","someid")
	return jwt_builder.sign(jwt_algorithm)

func test_generate(secret: String) -> bool:
	var jwt: String = create_hs256_jwt(secret)
	return true

func verify_hs256_jwt(jwt: String, secret: String) -> JWTVerifier.JWTExceptions:
	var jwt_algorithm: JWTAlgorithm = JWTAlgorithm.HS256.new(secret)
	var jwt_verifier: JWTVerifier = JWT.require(jwt_algorithm) \
		.with_claim("my-claim","my-value") \
		.build() # Reusable Verifier
	return jwt_verifier.verify(jwt)

func test_verify(jwt: String, secret: String) -> bool:
	var exception: JWTVerifier.JWTExceptions = verify_hs256_jwt(jwt, secret)
	return exception == JWTVerifier.JWTExceptions.OK

func decode_hs256_jwt(jwt: String) -> Dictionary:
	return JWTDecoder.new(jwt).get_claims()

var table: String = "|     TEST CASE     | EXECUTION TIME | PASSED | \n" + \
("|%019d|%016d|%08d| \n" % [0, 0, 0]).replacen("0", "-")

# Called when the node enters the scene tree for the first time.
func _init():
	print("> Executing tests.")
	
	var all_passed: bool = false
	for test in test_cases.keys():
		var t0: int = Time.get_ticks_msec()
		var passed: bool = test_cases[test].call(inputs[test])
		var t1: int = Time.get_ticks_msec()
		table += "| %17s | %14s | %5s | \n" % [test, str(t1 - t0) + "ms", "✅" if passed else "⛔"]
		all_passed = passed and all_passed
	
	var file = FileAccess.open("table", FileAccess.WRITE)
	file.store_string(table)
	
	file = FileAccess.open("passed", FileAccess.WRITE)
	file.store_string(str(all_passed))
	
	print(table)
	quit()

