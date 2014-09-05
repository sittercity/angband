require 'spec_helper'
require 'documentation/api_documentor'

describe Documentation::APIDocumentor do
  let(:gherkin_files) {
    [
      'path/to/files'
    ]
  }
  let(:gherkin_finder) { double(:gherkin_finder, :call => 'the-body')}

  subject(:documentor) {
    described_class.new(app) do |doc|
      doc.configure(gherkin_files)
    end
  }

  before :each do
    allow(Documentation::GherkinFinder).to receive(:new).with(gherkin_files).and_return(gherkin_finder)
  end

  context 'when the response code is 200' do
    let(:app) { lambda { |env| [200, {}, []] } }

    context 'and the request method is OPTIONS' do
      let(:env) { {'REQUEST_METHOD' => 'OPTIONS'} }

      it 'sets the content type to application/vnd.gherkin' do
        expect(subject.call(env)[1]['Content-Type']).to eq 'application/vnd.gherkin'
      end

      it 'sets the body to the output set by gherkin finder' do
        expect(subject.call(env)[2]).to eq ['the-body']
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
end
