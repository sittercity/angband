require 'spec_helper'
require 'angband/documentation'
require 'angband/gherkin_finder'
require 'pp'

describe Angband::Documentation do
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
          expect(middleware.call(env)[2].join('')).to eq File.read('spec/support/features/test.feature').strip
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
