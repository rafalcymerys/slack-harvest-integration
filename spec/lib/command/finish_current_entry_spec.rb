require 'spec_helper'

RSpec.describe Command::FinishCurrentEntry do
  let(:command) { described_class.new(harvest_service, hours_ago: hours_ago) }

  let(:harvest_service) { double }

  describe '#execute' do
    subject { command.execute }

    context 'when there is no active entry' do
      let(:hours_ago) { nil }

      before do
        allow(harvest_service).to receive(:active_entry).and_return(nil)
      end

      it 'returns false' do
        expect(subject).to eq(false)
      end
    end

    context 'when there is an active task' do
      let(:active_entry) { double }

      before do
        allow(harvest_service).to receive(:active_entry).and_return(active_entry)
      end

      context 'when user wants to finish entry now' do
        let(:hours_ago) { nil }

        it 'calls harvest api to toggle active task' do
          expect(harvest_service).to receive(:toggle_entry).with(active_entry)

          expect(subject).to eq(true)
        end
      end

      context 'when user wants to subtract time from entry' do
        let(:hours_ago) { 1 }

        let(:hours_tracked) { 2.5 }
        let(:new_hours_tracked) { 1.5 }

        before do
          allow(active_entry).to receive(:hours).and_return(hours_tracked)
        end

        it 'calls harvest api to toggle active task and subtracts time' do
          expect(harvest_service).to receive(:toggle_entry).with(active_entry)
          expect(active_entry).to receive(:hours=).with(new_hours_tracked)
          expect(harvest_service).to receive(:update_entry).with(active_entry)

          expect(subject).to eq(true)
        end
      end
    end
  end
end
