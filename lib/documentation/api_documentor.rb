require 'documentation/gherkin_finder'

module Documentation
  class APIDocumentor
    def initialize(app)
      @app = app
      yield self if block_given?
    end

    def call(env)
      response = @app.call(env)

      if options_request?(env) && successful?(response) && !cross_origin_request?(env)
        response[1]['Content-Type'] = 'application/vnd.gherkin'
        response[2] = [Documentation::GherkinFinder.new(@files).call(env['PATH_INFO']).join("\n\n").strip]
      end

      response
    end

    def configure(files)
      @files = files
    end

    private

    def cross_origin_request?(env)
      env['HTTP_ACCESS_CONTROL_REQUEST_METHOD'] || env['HTTP_ACCESS_CONTROL_REQUEST_HEADERS']
    end

    def options_request?(env)
      'OPTIONS' == env['REQUEST_METHOD']
    end

    def successful?(response)
      200 == response[0].to_i
    end
  end
end
