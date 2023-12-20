extends TestSuite
class_name ExampleTestSuite

func test_generate() -> void:
	var test_secret: String = Crypto.new().generate_random_bytes(5).get_string_from_utf8()
	var jwt_algorithm: JWTAlgorithm = JWTAlgorithm.HS256.new(test_secret)
	var jwt_builder: JWTBuilder = JWT.create() \
		.with_expires_at(Time.get_unix_time_from_system()) \
		.with_issuer("Godot") \
		.with_claim("id","someid")
	var jwt: String = jwt_builder.sign(jwt_algorithm)
	var claims: Dictionary = JWTDecoder.new(jwt).get_claims()
	assert_has(claims, "iss")
	assert_eq(claims.iss, "Godot")
	assert_has(claims, "id")
	assert_eq(claims.id, "someid")

func test_verify() -> void:
	var test_secret: String = Crypto.new().generate_random_bytes(5).get_string_from_utf8()
	var jwt_algorithm: JWTAlgorithm = JWTAlgorithm.HS256.new(test_secret)
	var jwt_verifier: JWTVerifier = JWT.require(jwt_algorithm) \
		.with_any_of_issuers(["Godot"]) \
		.with_claim("my-claim","my-value") \
		.build() # Reusable Verifier
	var jwt_builder: JWTBuilder = JWT.create() \
		.with_expires_at(Time.get_unix_time_from_system() + 20) \
		.with_issuer("Godot") \
		.with_claim("my-claim","my-value")
	var jwt: String = jwt_builder.sign(jwt_algorithm)
	var exception: JWTVerifier.JWTExceptions = jwt_verifier.verify(jwt)
	assert_eq(exception, JWTVerifier.JWTExceptions.OK)
