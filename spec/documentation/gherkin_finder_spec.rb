require 'spec_helper'
require 'angband/gherkin_finder'

describe Angband::GherkinFinder do
  let(:gherkin_files) {
    [
      'path/to/files',
      'more/paths/to/files',
    ]
  }
  let(:path_info) { '/the-path' }

  let(:listener) { Angband::GherkinListener.new }
  let(:lexer) { double(:lexer) }

  subject(:finder) { described_class.new(gherkin_files) }

  before :each do
    allow(File).to receive(:read).with(gherkin_files[0]).and_return('the file')
    allow(File).to receive(:read).with(gherkin_files[1]).and_return(' contents')
    allow(Angband::GherkinListener).to receive(:new).and_return(listener)
    allow(Gherkin::Lexer::I18nLexer).to receive(:new).with(listener).and_return(lexer)

    expect(lexer).to receive(:scan).with('the file') { listener.tag("@#{path_info}", 1) }
    expect(lexer).to receive(:scan).with(' contents')
  end

  it "returns a list of gherkin files' contents" do
    expect(subject.call(path_info)).to eq ['the file']
  end
end
