require 'spec_helper'

RSpec.describe Security::SlackRequestValidator do
  let(:validator) { described_class.new }

  describe '#validate_request' do
    subject { validator.validate_request(params) }

    let(:configured_token) { 'asdfghjkl' }
    let(:configured_domain) { 'my-company' }

    before do
      allow(Configuration).to receive(:slack_token).and_return(configured_token)
      allow(Configuration).to receive(:slack_domain).and_return(configured_domain)
    end

    context 'when token is missing' do
      let(:params) { {team_domain: configured_domain} }

      it 'raises error' do
        expect { subject }.to raise_error(Security::InvalidTokenError)
      end
    end

    context 'when token is invalid' do
      let(:params) { {team_domain: configured_domain} }
      let(:invalid_token) { 'zxcvbnm' }

      it 'raises error' do
        expect { subject }.to raise_error(Security::InvalidTokenError)
      end
    end

    context 'when domain is missing' do
      let(:params) { {token: configured_token} }

      it 'raises error' do
        expect { subject }.to raise_error(Security::InvalidDomainError)
      end
    end

    context 'when domain is invalid' do
      let(:params) { {token: configured_token, team_domain: invalid_domain} }
      let(:invalid_domain) { 'other-company' }

      it 'raises error' do
        expect { subject }.to raise_error(Security::InvalidDomainError)
      end
    end

    context 'when token and domain are valid' do
      let(:params) { {token: configured_token, team_domain: configured_domain} }

      it 'does not raise any errors' do
        expect { subject }.to_not raise_error
      end
    end

  end
end
