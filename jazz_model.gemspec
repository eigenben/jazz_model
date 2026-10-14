require_relative "lib/jazz_model/version"

Gem::Specification.new do |s|
  s.name = "jazz_model"
  s.version = JazzModel::VERSION
  s.author = "Ben Hughes"
  s.email = "me@benhughes.name"
  s.homepage = "https://github.com/eigenben/jazz_model"
  s.license = "MIT"
  s.summary = "An object model of jazz theory."
  s.description = "Jazz theory is a mathematical system of concepts and relationships. " \
    "Jazz Model represents chords, scales, modes, and keys as an ActiveRecord object model " \
    "so you can resolve chord symbols, spell notes in any key, and traverse chord-scale relationships."

  s.metadata = {
    "homepage_uri" => s.homepage,
    "source_code_uri" => s.homepage,
    "bug_tracker_uri" => "#{s.homepage}/issues",
    "rubygems_mfa_required" => "true"
  }

  s.files = Dir["lib/**/*.rb", "db/**/*.rb", "README.md", "LICENSE.txt"]
  s.require_paths = ["lib"]

  s.required_ruby_version = ">= 3.2"

  s.add_dependency "activerecord", ">= 7.2", "< 9"
  s.add_dependency "activesupport", ">= 7.2", "< 9"
  s.add_dependency "acts_as_list", ">= 1.0"
  s.add_dependency "acts_as_tree", ">= 2.9"
  s.add_dependency "sqlite3", ">= 2.0"
end
