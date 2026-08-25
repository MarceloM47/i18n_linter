require_relative "lib/i18n_linter_rb/version"

Gem::Specification.new do |spec|
  spec.name = "i18n-linter-rb"
  spec.version = I18nLinterRb::VERSION
  spec.authors = ["MarceloM47"]
  spec.summary = "Linter for YAML i18n locale files, built for Ruby and Rails projects"
  spec.description = "Detects missing translation keys across locale files. " \
                     "Works out of the box with Rails config/locales and supports custom paths."
  spec.homepage = "https://github.com/marcelom47/i18n-linter-rb"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.add_development_dependency "rspec", "~> 3.13"
  spec.add_development_dependency "rubocop", "~> 1"

  spec.files = Dir["lib/**/*.rb", "exe/*", "LICENSE.txt", "README.md"].compact
  spec.bindir = "exe"
  spec.executables = ["i18n-linter-rb"]
  spec.require_paths = ["lib"]
  spec.metadata["rubygems_mfa_required"] = "true"
end
