require "spec_helper"
require "i18n_linter_rb/linter"

RSpec.describe I18nLinterRb::Linter do
  let(:fixtures_path) { File.expand_path("../fixtures/locales", __dir__) }

  subject(:linter) do
    described_class.new(source_locale: "en", target_locale: "es")
  end

  describe "#missing_keys_in_target" do
    context "when translations are complete" do
      it "returns an empty list" do
        missing = linter.missing_keys_in_target(
          File.join(fixtures_path, "en.yml"),
          File.join(fixtures_path, "es.yml")
        )

        expect(missing).to eq([])
      end
    end

    context "when the target locale has missing keys" do
      before do
        allow(linter).to receive(:locale_keys).with("/tmp/source.yml").and_return(
          ["user.greeting", "user.farewell", "errors.not_found"]
        )
        allow(linter).to receive(:locale_keys).with("/tmp/target.yml").and_return(
          ["user.greeting"]
        )
      end

      it "returns only the keys missing in the target locale" do
        missing = linter.missing_keys_in_target("/tmp/source.yml", "/tmp/target.yml")

        expect(missing).to contain_exactly("user.farewell", "errors.not_found")
      end
    end

    context "when the target file does not exist" do
      it "raises an error" do
        expect {
          linter.missing_keys_in_target(
            File.join(fixtures_path, "en.yml"),
            "/nonexistent/es.yml"
          )
        }.to raise_error(Errno::ENOENT)
      end
    end
  end

  describe "nested key flattening" do
    it "flattens deeply nested hashes into dot notation" do
      source_path = File.join(fixtures_path, "en.yml")
      keys = linter.send(:locale_keys, source_path)

      expect(keys).to all(match(/\A[\w.]+\z/))
      expect(keys).to include("user.greeting")
    end
  end
end
