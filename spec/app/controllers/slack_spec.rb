require 'spec_helper'

RSpec.describe Controllers::Slack, type: :controller do
  describe 'POST /' do
    subject { post '/', params }

    let(:configured_token) { 'asdfghhjkl' }
    let(:configured_domain) { 'my-company' }

    let(:params) do
      {
        token: token,
        team_id: team_id,
        team_domain: team_domain,
        channel_id: channel_id,
        channel_name: channel_name,
        user_id: user_id,
        user_name: user_name,
        command: command,
        text: text,
        response_url: response_url
      }
    end

    let(:team_id) { '123' }
    let(:channel_id) { '25' }
    let(:channel_name) { 'channel' }
    let(:user_id) { '15' }
    let(:user_name) { 'rafal' }
    let(:command) { 'time' }
    let(:text) { 'new' }
    let(:response_url) { 'http://test.example.org/hook/' }

    before do
      allow(Configuration).to receive(:slack_token).and_return(configured_token)
      allow(Configuration).to receive(:slack_domain).and_return(configured_domain)
    end

    context 'when token is incorrect' do
      let(:token) { 'zxcvbnm' }
      let(:team_domain) { configured_domain }

      it 'returns error' do
        subject

        expect(last_response.status).to eq(500)
      end
    end

    context 'when domain is incorrect' do
      let(:token) { configured_token }
      let(:team_domain) { 'other-company' }

      it 'returns error' do
        subject

        expect(last_response.status).to eq(500)
      end
    end

    context 'when token and domain are correct' do
      let(:token) { configured_token }
      let(:team_domain) { configured_domain }

      it 'returns 200' do
        subject

        expect(last_response.status).to eq(200)
      end
    end
  end
end
