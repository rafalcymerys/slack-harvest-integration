module Response
  class Message
    attr_reader :text, :attachments

    def initialize(text:, attachments: nil)
      @text = text
      @attachments = attachments
    end
  end
end
