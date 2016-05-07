module Response
  class Attachment
    attr_reader :title, :text

    def initialize(title:, text:)
      @title = title
      @text = text
    end
  end
end
