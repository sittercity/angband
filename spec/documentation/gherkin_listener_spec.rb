require 'documentation/gherkin_listener'

describe Documentation::GherkinListener do
  subject(:listener) { described_class.new }

  it 'calls defined behavior with event arguments' do
    called = false
    listener.on(:something) { |*args| called = true; expect(args).to eq [:a, :b] }

    expect { listener.something(:a, :b) }.to change { called }.to true
  end
end
