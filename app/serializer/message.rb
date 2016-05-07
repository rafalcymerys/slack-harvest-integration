module Serializer
  class Message
    def serialize(message)
      message_hash = {text: message.text}

      if message.attachments
        attachment_hashes = message.attachments.map { |attachment| attachment_hash(attachment) }
        message_hash = message_hash.merge(attachments: attachment_hashes)
      end

      message_hash.to_json
    end

    private

    def attachment_hash(attachment)
      {title: attachment.title, text: attachment.text}
    end
  end
end
