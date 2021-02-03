# frozen_string_literal: true

require_relative "lib/rails/render/component/version"

Gem::Specification.new do |spec|
  spec.name          = "rails-render-component"
  spec.version       = Rails::Render::Component::VERSION
  spec.authors       = ["David Heinemeier Hansson", "VHO", "Sergio Cambra", "Mathieu Jobin"]
  spec.email         = ["_", "_"  "_", "mathieu@justbudget.com"]

  spec.summary       = "render actions in other controllers for their rendered response."
  spec.description   = "Components allow you to call other actions for their rendered response while executing another action"
  spec.homepage      = "http://github.com/mathieujobin/render_component."
  spec.licenses      = ["MIT"]
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency("railties", ">= 5.0", "< 6")
  spec.add_development_dependency("rubocop")
end
