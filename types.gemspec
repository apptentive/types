Gem::Specification.new do |s|
  s.name = "apptentive-types"
  s.version = "0.0.1"
  s.summary = "Apptentive complex types"
  s.description = "Provides custom Apptentive types and serialization"
  s.authors = ["Steve Sloan"]
  s.email = ["steve@apptentive.com"]
  s.license = "Proprietary"
  s.homepage = "http://github.com/apptentive/types"
  s.has_rdoc = false
  s.require_paths = ["lib"]
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- spec/*`.split("\n")

  s.add_dependency "activesupport", "~> 3.2.22"
  s.add_dependency "json"

  s.add_development_dependency "rspec"
  s.add_development_dependency "bson"
end
