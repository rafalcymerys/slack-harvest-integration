module Lookup
  class FieldBasedFilter
    def initialize(*fields)
      @fields = fields
    end

    def filter(objects, phrase)
      downcase_phrase = phrase.downcase

      exact_matches = exact_matches(downcase_phrase, objects)
      return exact_matches.first if exact_matches.count == 1

      partial_matches = partial_matches(downcase_phrase, objects)
      return partial_matches.first if partial_matches.count == 1

      partial_matches
    end

    private

    attr_reader :fields

    def exact_matches(phrase, objects)
      objects.select do |object|
        fields.map { |field| object.send(field) }.compact.any? { |value| value.downcase == phrase }
      end
    end

    def partial_matches(phrase, objects)
      objects.select do |object|
        fields.map { |field| object.send(field) }.compact.any? { |value| value.downcase.start_with?(phrase) }
      end
    end
  end
end
