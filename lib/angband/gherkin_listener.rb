module Angband
  class GherkinListener
    def initialize
      @callbacks = {}
    end

    def on(event, &block)
      @callbacks[event] = block
    end

    [:comment, :tag, :feature, :background, :scenario, :scenario_outline, :examples, :step, :doc_string, :row, :eof, :uri, :syntax_error].each do |method|
      define_method(method) do |*args|
        callback = @callbacks[method]
        callback.call(*args) if callback
      end
    end
  end
end
