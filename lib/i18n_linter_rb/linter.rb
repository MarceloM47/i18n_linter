require "yaml"

module I18nLinterRb
  class Linter
    attr_reader :source_locale, :target_locale

    def initialize(source_locale:, target_locale:)
      @source_locale = source_locale
      @target_locale = target_locale
    end

    def missing_keys_in_target(source_path, target_path)
      source_keys = locale_keys(source_path)
      target_keys = locale_keys(target_path)

      source_keys - target_keys
    end

    private

    def locale_keys(path)
      data = YAML.load_file(path)
      flatten_hash(root_data(data)).keys
    end

    def root_data(data)
      data.values.first || {}
    end

    def flatten_hash(hash, prefix = "")
      result = {}

      hash.each do |key, value|
        if value.is_a?(Hash)
          result.merge!(flatten_hash(value, "#{prefix}#{key}."))
        else
          result["#{prefix}#{key}"] = value
        end
      end

      result
    end
  end
end
