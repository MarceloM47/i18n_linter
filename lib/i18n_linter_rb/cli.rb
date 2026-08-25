require "optparse"
require "i18n_linter_rb/linter"

module I18nLinterRb
  class Cli
    DEFAULT_LOCALES_PATH = "config/locales".freeze
    DEFAULT_SOURCE_LOCALE = "en".freeze
    DEFAULT_TARGET_LOCALES = %w[es].freeze
    CONFIG_FILE_PATH = ".i18n_linter.yml".freeze

    USAGE_GUIDE = <<~GUIDE

      No locales directory found.

      i18n-linter-rb looks for a Rails locales directory by default:
        config/locales/

      If your translations live somewhere else, pass the path explicitly:

        i18n-linter-rb --path path/to/locales
        i18n-linter-rb --path path/to/locales --from en --to es,fr,pt

      You can also create an .i18n_linter.yml file in your project root:

        locales_path: path/to/locales
        source_locale: en
        target_locales: [es, fr]

    GUIDE

    def initialize(argv)
      @argv = argv
      @options = {}
    end

    def run
      parse_options
      return create_config_file if @options[:init]

      resolve_locales_path
      warn_about_manual_path

      source_path = File.join(@locales_path, "#{@options[:from]}.yml")
      missing = {}

      @options[:to].each do |target_locale|
        target_path = File.join(@locales_path, "#{target_locale}.yml")
        linter = Linter.new(source_locale: @options[:from], target_locale: target_locale)
        keys = linter.missing_keys_in_target(source_path, target_path)
        missing[target_locale] = keys unless keys.empty?
      end

      report(missing)
    end

    private

    def parse_options
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: i18n-linter-rb [options]"

        opts.on("-p", "--path PATH", "Locales directory (default: #{DEFAULT_LOCALES_PATH})") do |path|
          @options[:path] = path
        end

        opts.on("-f", "--from LOCALE", "Source locale (default: #{DEFAULT_SOURCE_LOCALE})") do |locale|
          @options[:from] = locale
        end

        opts.on("-t", "--to LOCALES x,y,z", Array, "Target locales (default: #{DEFAULT_TARGET_LOCALES.join(',')})") do |locales|
          @options[:to] = locales
        end

        opts.on("-i", "--init", "Create a default #{CONFIG_FILE_PATH} in the current directory") do
          @options[:init] = true
        end

        opts.on("-v", "--version", "Show version") do
          puts I18nLinterRb::VERSION
          exit
        end

        opts.on("-h", "--help", "Show this help") do
          puts opts
          exit
        end
      end

      parser.parse!(@argv)
      @options[:from] ||= load_config["source_locale"] || DEFAULT_SOURCE_LOCALE
      @options[:to] ||= load_config["target_locales"] || DEFAULT_TARGET_LOCALES
    end

    def resolve_locales_path
      @locales_path = @options[:path] || load_config["locales_path"] || DEFAULT_LOCALES_PATH

      unless File.directory?(@locales_path)
        abort(USAGE_GUIDE)
      end
    end

    def load_config
      @load_config ||= begin
        File.exist?(CONFIG_FILE_PATH) ? YAML.load_file(CONFIG_FILE_PATH) : {}
      rescue Psych::SyntaxError => e
        warn("Invalid #{CONFIG_FILE_PATH}: #{e.message}")
        {}
      end
    end

    def create_config_file
      if File.exist?(CONFIG_FILE_PATH)
        warn("#{CONFIG_FILE_PATH} already exists, not overwriting.")
        return
      end

      File.write(CONFIG_FILE_PATH, {
        "locales_path" => DEFAULT_LOCALES_PATH,
        "source_locale" => DEFAULT_SOURCE_LOCALE,
        "target_locales" => DEFAULT_TARGET_LOCALES
      }.to_yaml)

      puts "Created #{CONFIG_FILE_PATH}"
    end

    def warn_about_manual_path
      return unless @options[:path] && !File.exist?(CONFIG_FILE_PATH)

      warn("Tip: run 'i18n-linter-rb --init' to save this path in #{CONFIG_FILE_PATH} instead of passing --path every time.")
    end

    def report(missing)
      if missing.empty?
        puts "All translations are complete."
      else
        missing.each do |locale, keys|
          puts "Missing keys in #{locale}.yml:"
          keys.each { |key| puts "  - #{key}" }
        end
        exit 1
      end
    end
  end
end
