require 'spec_helper'

RSpec.describe Parser::Hours do
  let(:parser) { described_class.new }

  describe '#parse' do
    subject { parser.parse(hours_string) }

    context 'when hour and minutes are passed' do
      let(:hours_string) { '1:30' }
      let(:expected_result) { 1.5 }

      it 'converts it to float' do
        expect(subject).to be_within(0.01).of(expected_result)
      end
    end

    context 'when only one number is passed' do
      let(:hours_string) { '1' }
      let(:expected_result) { 1.0 }

      it 'converts it to float' do
        expect(subject).to be_within(0.01).of(expected_result)
      end
    end

    context 'when hour and semicolon is passed' do
      let(:hours_string) { '2:' }
      let(:expected_result) { 2.0 }

      it 'converts it to float' do
        expect(subject).to be_within(0.01).of(expected_result)
      end
    end

    context 'when only minutes are passed' do
      let(:hours_string) { ':30' }
      let(:expected_result) { 0.5 }

      it 'converts it to float' do
        expect(subject).to be_within(0.01).of(expected_result)
      end
    end

    context 'when too many semicolons are passed' do
      let(:hours_string) { '1:30:23' }

      it 'raises an error' do
        expect { subject }.to raise_error(Parser::IncorrectHoursError)
      end
    end

    context 'when non-numeric characters are passed' do
      let(:hours_string) { 'test:12' }

      it 'raises an error' do
        expect { subject }.to raise_error(Parser::IncorrectHoursError)
      end
    end
  end

  describe '#valid?' do
    subject { parser.valid?(hours_string) }

    context 'when hour and minutes are passed' do
      let(:hours_string) { '1:30' }

      it 'returns true' do
        expect(subject).to eq(true)
      end
    end

    context 'when only one number is passed' do
      let(:hours_string) { '1' }

      it 'returns true' do
        expect(subject).to eq(true)
      end
    end

    context 'when hour and semicolon is passed' do
      let(:hours_string) { '2:' }

      it 'returns true' do
        expect(subject).to eq(true)
      end
    end

    context 'when only minutes are passed' do
      let(:hours_string) { ':30' }

      it 'returns true' do
        expect(subject).to eq(true)
      end
    end

    context 'when too many semicolons are passed' do
      let(:hours_string) { '1:30:23' }

      it 'returns false' do
        expect(subject).to eq(false)
      end
    end

    context 'when non-numeric characters are passed' do
      let(:hours_string) { 'test:12' }

      it 'raises an error' do
        expect(subject).to eq(false)
      end
    end
  end
end
