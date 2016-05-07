require 'spec_helper'

RSpec.describe Lookup::Match do
  let(:match) { described_class.new(elements) }

  let(:element1) { double }
  let(:element2) { double }

  describe '#empty?' do
    subject { match.empty? }

    context 'when match is empty' do
      let(:elements) { [] }

      it 'returns true' do
        expect(subject).to eq(true)
      end
    end

    context 'when match contains a single element' do
      let(:elements) { [element1] }

      it 'returns false' do
        expect(subject).to eq(false)
      end
    end

    context 'when match contains multiple elements' do
      let(:elements) { [element1, element2] }

      it 'returns true' do
        expect(subject).to eq(false)
      end
    end
  end

  describe '#single?' do
    subject { match.single? }

    context 'when match is empty' do
      let(:elements) { [] }

      it 'returns false' do
        expect(subject).to eq(false)
      end
    end

    context 'when match contains a single element' do
      let(:elements) { [element1] }

      it 'returns true' do
        expect(subject).to eq(true)
      end
    end

    context 'when match contains multiple elements' do
      let(:elements) { [element1, element2] }

      it 'returns false' do
        expect(subject).to eq(false)
      end
    end
  end

  describe '#multiple?' do
    subject { match.multiple? }

    context 'when match is empty' do
      let(:elements) { [] }

      it 'returns false' do
        expect(subject).to eq(false)
      end
    end

    context 'when match contains a single element' do
      let(:elements) { [element1] }

      it 'returns false' do
        expect(subject).to eq(false)
      end
    end

    context 'when match contains multiple elements' do
      let(:elements) { [element1, element2] }

      it 'returns true' do
        expect(subject).to eq(true)
      end
    end
  end

  describe '#get' do
    subject { match.get }

    context 'when match is empty' do
      let(:elements) { [] }

      it 'raises an error' do
        expect { subject }.to raise_error(Lookup::NoSingleMatchError)
      end
    end

    context 'when match contains a single element' do
      let(:elements) { [element1] }

      it 'returns the match' do
        expect(subject).to eq(element1)
      end
    end

    context 'when match contains multiple elements' do
      let(:elements) { [element1, element2] }

      it 'raises an error' do
        expect { subject }.to raise_error(Lookup::NoSingleMatchError)
      end
    end
  end

  describe '#each' do
    context 'when match is empty' do
      let(:elements) { [] }

      it 'does not yield anything' do
        expect { |b| match.each(&b) }.not_to yield_control
      end
    end

    context 'when match contains a single element' do
      let(:elements) { [element1] }

      it 'returns the match' do
        expect { |b| match.each(&b) }.to yield_with_args(element1)
      end
    end

    context 'when match contains multiple elements' do
      let(:elements) { [element1, element2] }

      it 'raises an error' do
        expect { |b| match.each(&b) }.to yield_successive_args(element1, element2)
      end
    end
  end
end
