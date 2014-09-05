require 'spec_helper'
require 'documentation/gherkin_listener'
require 'gherkin/lexer/i18n_lexer'
require 'pp'

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
        output += gherkin if listener.should_output?
      end

      output
    end
  end
end

describe Documentation::APIDocumentor do
  let(:app) { lambda { |env| response } }
  let(:response) { [200, {}, []] }
  let(:env) { {} }

  subject(:middleware) { described_class.new(app) }

  context 'when called' do
    it 'runs the app and returns the app response' do
      expect { middleware.call(env) }.to_not change { response.freeze }
    end

    context 'with OPTIONS method' do
      let(:env) { { 'REQUEST_METHOD' => 'OPTIONS', 'PATH_INFO' => '/rspec' } }
      let(:files) { [
        'spec/support/features/test.feature',
        'spec/support/features/cucumber.feature',
      ]}

      context 'app returns 200' do
        # when configured
        before :each do
          middleware.configure(files)
        end

        it 'replaces the body' do
          expect(middleware.call(env)[2].join('')).to eq File.read('spec/support/features/test.feature')
        end

        it 'sets a default content-type' do
          expect(middleware.call(env)[1]['Content-Type']).to eq 'application/vnd.gherkin'
        end
      end

      context 'app does not return 200' do
        let(:response) { [404, {}, []] }

        it 'returns the app response' do
          expect { middleware.call(env) }.to_not change { response.freeze }
        end
      end
    end
  end
end
