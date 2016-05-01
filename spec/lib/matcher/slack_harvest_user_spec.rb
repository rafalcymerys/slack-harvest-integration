require 'spec_helper'

RSpec.describe Matcher::SlackHarvestUser do
  let(:matcher) { described_class.new(slack_service, harvest_user_service) }

  let(:slack_service) { double }
  let(:harvest_user_service) { double }

  describe '#harvest_user_id' do
    subject { matcher.harvest_user_id(input_slack_user_id) }

    let(:slack_user_id) { 'U123456' }
    let(:harvest_user_id) { 123456789 }
    let(:email) { 'test@example.org' }

    before do
      allow(slack_service).to receive(:email_for_user)
      allow(harvest_user_service).to receive(:user_id_for_email)

      allow(slack_service).to receive(:email_for_user).with(slack_user_id).and_return(email)
      allow(harvest_user_service).to receive(:user_id_for_email).with(email).and_return(harvest_user_id)
    end

    context 'when user exists' do
      let(:input_slack_user_id) { slack_user_id }

      it 'returns harvest user id' do
        expect(subject).to eq(harvest_user_id)
      end
    end

    context 'when user is missing' do
      let(:input_slack_user_id) { 'U1234' }

      it 'raises an error' do
        expect { subject }.to raise_error(Matcher::UserNotFoundError)
      end
    end
  end
end
