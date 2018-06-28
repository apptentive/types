Gem::Specification.new do |s|
  s.name = "apptentive-types"
  s.version = "1.0.0"
  s.summary = "Apptentive complex types"
  s.description = "Provides custom Apptentive types and serialization"
  s.authors = ["Joel Stimson", "John Fearnside", "Steve Sloan"]
  s.email = ["joel@apptentive.com", "m@saffitz.com"]
  s.license = "Proprietary"
  s.homepage = "http://github.com/apptentive/types"
  s.require_paths = ["lib"]
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/*`.split("\n")

  s.add_dependency "activesupport", ">= 3.2.22"
  s.add_dependency "json"

  s.add_development_dependency "rspec"
  s.add_development_dependency "bson"
end
