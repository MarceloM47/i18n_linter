require "spec_helper"
require "i18n_linter_rb/cli"
require "tmpdir"
require "fileutils"
require "yaml"

RSpec.describe I18nLinterRb::Cli do
  around do |example|
    Dir.mktmpdir do |dir|
      Dir.chdir(dir) { example.run }
    end
  end

  describe "--init" do
    context "when no config file exists yet" do
      it "creates a default .i18n_linter.yml in the current directory" do
        expect {
          described_class.new(["--init"]).run
        }.to output(/Created \.i18n_linter\.yml/).to_stdout

        expect(File.exist?(".i18n_linter.yml")).to be true
      end

      it "writes the default locales_path, source_locale and target_locales" do
        described_class.new(["--init"]).run

        config = YAML.load_file(".i18n_linter.yml")
        expect(config["locales_path"]).to eq("config/locales")
        expect(config["source_locale"]).to eq("en")
        expect(config["target_locales"]).to eq(["es"])
      end
    end

    context "when a config file already exists" do
      it "does not overwrite it and warns instead" do
        File.write(".i18n_linter.yml", "source_locale: fr\n")

        expect {
          described_class.new(["--init"]).run
        }.to output(/already exists/).to_stderr

        expect(YAML.load_file(".i18n_linter.yml")["source_locale"]).to eq("fr")
      end
    end
  end

  describe "warning when --path is passed manually" do
    before do
      FileUtils.mkdir_p("my_locales")
      File.write("my_locales/en.yml", { "en" => { "greeting" => "Hi" } }.to_yaml)
      File.write("my_locales/es.yml", { "es" => { "greeting" => "Hola" } }.to_yaml)
    end

    context "when no config file exists" do
      it "suggests running --init" do
        expect {
          described_class.new(["--path", "my_locales"]).run
        }.to output(/i18n-linter-rb --init/).to_stderr
      end
    end

    context "when a config file already exists" do
      it "does not show the suggestion" do
        File.write(".i18n_linter.yml", "locales_path: my_locales\n")

        expect {
          described_class.new(["--path", "my_locales"]).run
        }.not_to output(/i18n-linter-rb --init/).to_stderr
      end
    end

    context "when --path is not passed manually" do
      it "does not show the suggestion" do
        File.write(".i18n_linter.yml", "locales_path: my_locales\n")

        expect {
          described_class.new([]).run
        }.not_to output(/i18n-linter-rb --init/).to_stderr
      end
    end
  end
end
