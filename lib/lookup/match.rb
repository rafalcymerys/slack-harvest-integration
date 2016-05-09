module Lookup
  class Match
    include Enumerable

    def initialize(elements)
      @elements = elements
    end

    def empty?
      elements.empty?
    end

    def single?
      elements.size == 1
    end

    def multiple?
      elements.size > 1
    end

    def get
      raise NoSingleMatchError unless single?
      elements.first
    end

    def each(&block)
      elements.each(&block)
    end

    attr_reader :elements
  end
end
