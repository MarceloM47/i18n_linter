require "i18n_linter_rb/version"
require "i18n_linter_rb/linter"
require "i18n_linter_rb/cli"

module I18nLinterRb
  def self.lint(argv = ARGV)
    Cli.new(argv).run
  end
end
