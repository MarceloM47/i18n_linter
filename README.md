# i18n-linter-rb

A linter for YAML i18n locale files, built for Ruby and Rails projects.

It detects translation keys that exist in your source locale but are missing from other locales, so you never ship an app with incomplete translations.

## Features

- Works out of the box with the Rails convention (`config/locales/`)
- Compares nested keys using dot notation (e.g. `users.edit.title`)
- Supports multiple target locales in a single run
- Optional configuration file for project-specific defaults
- Exit code `1` when keys are missing, ready for CI pipelines

## Installation

```bash
gem install i18n-linter-rb
```

Or add it to your Gemfile:

```ruby
gem "i18n-linter-rb"
```

## Usage

Run it from your project root. By default it looks for `config/locales/`, compares `en.yml` against `es.yml`, and reports missing keys:

```bash
i18n-linter-rb
```

Example output:

```
Missing keys in es.yml:
  - users.new.title
  - errors.not_found
```

If no locales directory is found, a usage guide is printed to help you configure the tool.

### Options

```
Usage: i18n-linter-rb [options]
    -p, --path PATH                  Locales directory (default: config/locales)
    -f, --from LOCALE                Source locale (default: en)
    -t, --to LOCALES x,y,z           Target locales (default: es)
    -v, --version                    Show version
    -h, --help                       Show this help
```

Examples:

```bash
# Custom locales directory
i18n-linter-rb --path translations/locales

# Compare English against several languages
i18n-linter-rb --from en --to es fr pt
```

### Configuration file

Create an `.i18n_linter.yml` file in your project root to persist your settings:

```yaml
locales_path: config/locales
source_locale: en
target_locales:
  - es
  - fr
  - pt
```

Precedence order: CLI flags > configuration file > defaults.

## Development

After checking out the repo, run the test suite with:

```bash
rake spec
```

To try the CLI locally without installing the gem:

```bash
ruby -Ilib exe/i18n-linter-rb --help
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/marcelom47/i18n-linter-rb.

## License

The gem is available as open source under the terms of the [MIT License](LICENSE.txt).
