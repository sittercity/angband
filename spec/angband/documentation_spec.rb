require 'spec_helper'
require 'angband/documentation'

describe Angband::Documentation do
  let(:gherkin_files) {
    [
      'path/to/files'
    ]
  }
  let(:gherkin_finder) { double(:gherkin_finder, :call => features)}
  let(:formatter) { double(:formatter, :call => [headers, content]) }

  let(:content) { 'the-formatted-content' }
  let(:features) { ['the-features'] }
  let(:headers) { { 'the' => 'headers' } }

  subject(:documentor) {
    described_class.new(app) do |doc|
      doc.configure(gherkin_files)
    end
  }

  before :each do
    allow(Angband::GherkinFinder).to receive(:new).with(gherkin_files).and_return(gherkin_finder)
    allow(Angband::Formatter).to receive(:new).with(instance_of(Rack::AcceptHeaders::Request)).and_return(formatter)
  end

  context 'when the response code is 200' do
    let(:app) { lambda { |env| [200, {}, []] } }

    context 'and the request method is OPTIONS' do
      let(:env) { {'REQUEST_METHOD' => 'OPTIONS'} }

      it 'returns the formatted headers' do
        expect(subject.call(env)[1]).to include(headers)
      end

      it 'sets the body to the output set by gherkin finder' do
        expect(formatter).to receive(:call).with(features)
        expect(subject.call(env)[2]).to eq ['the-formatted-content']
      end
    end

    context 'and the request method is not OPTIONS' do
      let(:env) { {'REQUEST_METHOD' => 'GET'} }

      it 'passes on the app response' do
        expect(subject.call(env)).to eq [200, {}, []]
      end
    end
  end

  context 'when the response code is not 200' do
    let(:app) { lambda { |env| [404, {}, []] } }

    context 'and the request method is OPTIONS' do
      let(:env) { {'REQUEST_METHOD' => 'OPTIONS'} }

      it 'passes on the app response' do
        expect(subject.call(env)).to eq [404, {}, []]
      end
    end

    context 'and the request method is not OPTIONS' do
      let(:env) { {'REQUEST_METHOD' => 'GET'} }

      it 'passes on the app response' do
        expect(subject.call(env)).to eq [404, {}, []]
      end
    end
  end

  context 'when the response is to a cross-origin preflight request' do
    let(:app) { lambda { |env| [200, {'Access-Control-Request-Method' => 'GET'}, []] } }
    let(:env) { {'REQUEST_METHOD' => 'OPTIONS', 'HTTP_ACCESS_CONTROL_REQUEST_METHOD' => 'GET'} }

    it 'passes on the app response' do
      expect(subject.call(env)).to eq [200, { 'Access-Control-Request-Method' => 'GET' }, []]
    end
  end
end
