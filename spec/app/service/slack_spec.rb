require 'spec_helper'

RSpec.describe Service::Slack do
  let(:service) { described_class.new(client) }
  let(:client) { double }

  describe '#email_for_user' do
    subject { service.email_for_user(user_id) }

    let(:user_id) { 'U123456' }

    before do
      allow(client).to receive(:users_info).with(user: user_id).and_return(response)
    end

    context 'when user is found' do
      let(:email) { 'test@example.org' }
      let(:response) do
        {
          'ok' => true,
          'user' => {
            'id' => 'U123456',
            'team_id' => 'T123456',
            'profile' => {
              'first_name' => 'Rafal',
              'last_name' => 'Cymerys',
              'email' => email
            },
          }
        }
      end

      it 'returns email address' do
        expect(subject).to eq(email)
      end
    end

    context 'when user is not found' do
      let(:response) do
        {
          'ok' => false,
          'error' => 'user_not_found'
        }
      end

      it 'returns nil' do
        expect(subject).to eq(nil)
      end
    end
  end
end
