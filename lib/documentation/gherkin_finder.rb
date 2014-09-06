require 'documentation/gherkin_listener'
require 'gherkin/lexer/i18n_lexer'

module Documentation
  class GherkinFinder
    def initialize(gherkin_files)
      @gherkin_files = gherkin_files
    end

    def call(path_info)
      listener = Documentation::GherkinListener.new
      lexer = Gherkin::Lexer::I18nLexer.new(listener)

      listener.on(:tag) do |tag|
        @path_matched = true if %r{^#{tag}$} === "@#{path_info}"
      end

      result = @gherkin_files.map do |file|
        @path_matched = false
        gherkin = File.read(file)
        lexer.scan(gherkin)
        gherkin if @path_matched
      end

      result.compact
    end

  end
end
