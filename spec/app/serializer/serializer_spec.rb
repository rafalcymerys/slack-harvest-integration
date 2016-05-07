require 'spec_helper'

RSpec.describe Serializer::Message do
  let(:serializer) { described_class.new }

  describe '#serialize' do
    subject { JSON.parse(serialized_message) }

    let(:serialized_message) { serializer.serialize(message) }

    context 'when attachments field is empty' do
      let(:text) { 'Things are ok' }
      let(:message) { Response::Message.new(text: text) }

      it 'serializes text field' do
        expect(subject['text']).to eq(text)
      end

      it 'does not serialize attachments field' do
        expect(subject).not_to include('attachments')
      end
    end

    context 'when attachments are present' do
      let(:text) { 'We have attachments for you' }
      let(:attachments) { [attachment1, attachment2] }

      let(:title1) { 'Available projects' }
      let(:title2) { 'Available tasks' }
      let(:text1) { 'Store' }
      let(:text2) { 'Development' }

      let(:attachment1) { Response::Attachment.new(title: title1, text: text1) }
      let(:attachment2) { Response::Attachment.new(title: title2, text: text2) }

      let(:message) { Response::Message.new(text: text, attachments: attachments) }

      it 'serializes text field' do
        expect(subject['text']).to eq(text)
      end

      it 'serializes first attachment' do
        expect(subject['attachments']).to include('title' => title1, 'text' => text1)
      end

      it 'serializes second attachment' do
        expect(subject['attachments']).to include('title' => title2, 'text' => text2)
      end
    end
  end
end
