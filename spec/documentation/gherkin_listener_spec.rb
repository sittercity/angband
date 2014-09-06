require 'documentation/gherkin_listener'

describe Documentation::GherkinListener do
  subject(:listener) { described_class.new }

  it 'calls defined behavior with event arguments' do
    called = false
    listener.on(:tag) { |*args| called = true; expect(args).to eq ['asdf'] }

    expect { listener.tag('asdf') }.to change { called }.to true
  end
end
