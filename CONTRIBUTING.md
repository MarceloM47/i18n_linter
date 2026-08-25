# Contributing

Thanks for considering contributing to i18n-linter-rb!

## Setup

```bash
git clone https://github.com/MarceloM47/i18n-linter-rb.git
cd i18n-linter-rb
bundle install
```

## Running tests and lint

```bash
rake spec   # RSpec suite
rubocop     # style check
```

Both run automatically in CI on every push and pull request.

## Making changes

- Follow the existing code style (double-quoted strings, no unnecessary comments) — `.rubocop.yml` enforces most of it.
- Add or update tests for any behavior change. This project follows TDD: write a failing test first, then the minimal code to pass it.
- Keep pull requests focused on a single change.

## Submitting a pull request

1. Fork the repo and create a branch from `main`.
2. Make your changes, with tests.
3. Make sure `rake spec` and `rubocop` pass locally.
4. Open a pull request describing what changed and why.

## Releases

Releases are cut by maintainers only: bump `lib/i18n_linter_rb/version.rb` following [Semantic Versioning](https://semver.org/), commit, then tag and push:

```bash
git tag vX.Y.Z
git push origin vX.Y.Z
```

CI builds and publishes the gem to RubyGems automatically from there.
