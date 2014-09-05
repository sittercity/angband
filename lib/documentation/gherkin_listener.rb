module Documentation
  class GherkinListener
    def initialize(path)
      @path = path
      @should_output = false
    end

    def tag(tag, line_number)
      if %r{^#{tag}$} === "@#{@path}"
        @should_output = true
      end
    end

    def method_missing(*)
      #nope
    end

    def should_output?
      @should_output
    end
  end
end
