require 'documentation/gherkin_listener'
require 'gherkin/lexer/i18n_lexer'

module Documentation
  class GherkinFinder
    def initialize(gherkin_files)
      @gherkin_files = gherkin_files
    end

    def call(path_info)
      output = ''

      @gherkin_files.each do |file|
        gherkin = File.read(file)
        listener = Documentation::GherkinListener.new(path_info)
        Gherkin::Lexer::I18nLexer.new(listener).scan(gherkin)
        output += "#{gherkin}\n\n" if listener.should_output?
      end

      output.strip
    end
  end
end
