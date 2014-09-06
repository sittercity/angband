require 'mustache'

module Documentation
  class Formatter
    def initialize(accept_headers)
      @accept_headers = accept_headers
    end

    def call(features)
      case @accept_headers.media_type.best_of(['application/vnd.gherkin', 'text/html'])
      when 'text/html'
        [
          {'Content-Type' => 'text/html'},
          render('templates/html.mustache', features)
        ]
      else
        [
          {'Content-Type' => 'application/vnd.gherkin'},
          render('templates/plain.mustache', features)
        ]
      end
    end

    private

    def render(file, features)
      Mustache.render(
        File.read(File.expand_path("../../#{file}", __FILE__)),
        :features => features
      ).strip
    end
  end
end
