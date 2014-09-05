module Documentation
  class GherkinListener
    def initialize(path, language_pattern)
      @path = path
      @should_output = false
      @language_pattern = language_pattern
    end

    def comment(text, line_number)
      match = @language_pattern.match(text)
      if match
        @matched_language = match[2]
      end
    end

    def tag(tag, line_number)
      if %r{^#{tag}$} === "@#{@path}"
        @should_output = true
      end
    end

    attr_reader :matched_language

    def method_missing(*args)
      #nope
    end

    def should_output?
      @should_output
    end
  end
end
