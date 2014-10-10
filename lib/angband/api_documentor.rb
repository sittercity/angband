require 'angband/formatter'
require 'angband/gherkin_finder'
require 'rack/accept_headers'

module Angband
  class APIDocumentor
    def initialize(app)
      @app = app
      yield self if block_given?
    end

    def call(env)
      response = Rack::AcceptHeaders.new(@app).call(env)

      if options_request?(env) && successful?(response) && !cross_origin_request?(env)
        features  = Angband::GherkinFinder.new(@files).call(env['PATH_INFO'])
        formatter = Angband::Formatter.new(env['rack-accept_headers.request'])

        headers, content = formatter.call(features)
        response[1].merge!(headers)
        response[2] = [content]
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
