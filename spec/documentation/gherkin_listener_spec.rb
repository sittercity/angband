require 'documentation/gherkin_listener'

describe Documentation::GherkinListener do
  subject(:listener) { described_class.new('/test') }

  describe '#tag' do
    context 'when the tag matches' do
      it 'should output' do
        listener.tag('@/test', 1)
        expect(listener.should_output?).to be true
      end

      context 'variable tag' do
        it 'should output' do
          listener.tag('@/.+', 1)
          expect(listener.should_output?).to be true
        end
      end
    end

    context 'when the tag does not match' do
      before :each do
        listener.tag('@/nope', 1)
      end

      it 'should not output' do
        expect(listener.should_output?).to be false
      end
    end
  end
end
