require 'documentation/gherkin_finder'

module Documentation
  class APIDocumentor
    def initialize(app)
      @app = app
      yield self if block_given?
    end

    def call(env)
      response = @app.call(env)
      if response[0] == 200 && env['REQUEST_METHOD'] == 'OPTIONS'
        response[1]['Content-Type'] = 'application/vnd.gherkin'
        response[2] = [Documentation::GherkinFinder.new(@files).call(env['PATH_INFO'])]
      end
      response
    end

    def configure(files)
      @files = files
    end
  end
end
