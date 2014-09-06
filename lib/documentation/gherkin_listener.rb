module Documentation
  class GherkinListener
    def initialize
      @callbacks = {}
    end

    def on(event, &block)
      @callbacks[event] = block
    end

    def method_missing(method, *args)
      callback = @callbacks[method]
      callback.call(*args) if callback
    end
  end
end
