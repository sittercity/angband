require 'spec_helper'
require 'documentation/formatter'

describe Documentation::Formatter do
  let(:accept_headers) { double(:accept_headers) }

  let(:gherkin_mime_type) { 'application/vnd.gherkin' }
  let(:html_mime_type) { 'text/html' }

  subject(:formatter) { described_class.new(accept_headers) }

  context 'when the consumer requests HTML' do
    before do
      expect(accept_headers).to receive_message_chain(:media_type, :best_of) do |args|
        expect(args).to include(html_mime_type)
        html_mime_type
      end
    end

    it 'sets the Content-Type to HTML' do
      headers, _ = formatter.call([])
      expect(headers).to include('Content-Type' => html_mime_type)
    end

    it 'returns an HTML document with Gherkin' do
      _, content = formatter.call(['test', 'data'])
      expect(content).to include('<html>')
      expect(content).to include('<code class="gherkin">test</code>')
      expect(content).to include('<code class="gherkin">data</code>')
    end
  end

  context 'when the consumer does not request HTML' do
    before do
      expect(accept_headers).to receive_message_chain(:media_type, :best_of) do |args|
        expect(args).to include(gherkin_mime_type)
        gherkin_mime_type
      end
    end

    it 'sets the Content-Type to Gherkin' do
      headers, _ = formatter.call([])
      expect(headers).to include('Content-Type' => gherkin_mime_type)
    end

    it 'returns plain Gherkin' do
      _, content = formatter.call(['test', 'data'])
      expect(content).to eq "test\n\ndata"
    end
  end
end
