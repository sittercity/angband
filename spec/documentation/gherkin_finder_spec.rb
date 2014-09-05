require 'spec_helper'
require 'documentation/gherkin_finder'

describe Documentation::GherkinFinder do
  let(:gherkin_files) {
    [
      'path/to/files',
      'more/paths/to/files',
    ]
  }
  let(:path_info) { '/the-path' }

  let(:listener) { double(:gherkin_listener, :should_output? => true) }
  let(:lexer) { double(:lexer) }

  subject(:finder) { described_class.new(gherkin_files) }

  before :each do
    allow(File).to receive(:read).with(gherkin_files[0]).and_return('the file')
    allow(File).to receive(:read).with(gherkin_files[1]).and_return(' contents')
    allow(Documentation::GherkinListener).to receive(:new).with(path_info).and_return(listener)
    allow(Gherkin::Lexer::I18nLexer).to receive(:new).with(listener).and_return(lexer)
    expect(lexer).to receive(:scan).with('the file')
    expect(lexer).to receive(:scan).with(' contents')
  end

  it 'returns concatenated contents of the gherkin files' do
    expect(subject.call(path_info)).to eq "the file\n\n contents"
  end
end
