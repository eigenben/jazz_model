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

  s.add_dependency("activerecord", ["~> 3.1.0"])
  s.add_dependency("activesupport", ["~> 3.1.0"])
  s.add_dependency("acts_as_list", [">= 0.1.2"])
  s.add_dependency("acts_as_tree", [">= 0.1.1"])
  s.add_dependency("sqlite3", ["~> 1.3.0"])
  s.add_development_dependency("rspec", ["~> 2.0"])
end
