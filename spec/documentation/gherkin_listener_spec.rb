require 'documentation/gherkin_listener'
require 'gherkin/lexer/i18n_lexer'

describe Documentation::GherkinListener do
  subject(:listener) { described_class.new('/test', Gherkin::Lexer::I18nLexer::LANGUAGE_PATTERN) }

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

  describe '#matched_language' do
    context 'when the listener is notified about a language' do
      before { listener.comment('# language: de', 1) }

      it 'is that language' do
        expect(listener.matched_language).to eq 'de'
      end
    end

    context 'when the listener is not notified' do
      specify { expect(listener.matched_language).to be nil }
    end
  end
end
