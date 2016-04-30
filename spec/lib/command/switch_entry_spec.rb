require 'spec_helper'

RSpec.describe Command::SwitchEntry do
  let(:command) do
    described_class.new(harvest_service, project_id: project_id, task_id: task_id, notes: notes, hours_ago: hours_ago)
  end

  let(:harvest_service) { double.as_null_object }
  let(:project_id) { 15 }
  let(:task_id) { 10 }
  let(:hours_ago) { nil }
  let(:notes) { 'Doing my thing' }

  describe '#execute' do
    subject { command.execute }

    context 'when there is an active entry' do
      let(:active_entry) { double.as_null_object }

      before do
        allow(harvest_service).to receive(:active_entry).and_return(active_entry)
      end

      it 'finishes this entry' do
        expect(harvest_service).to receive(:toggle_entry).with(active_entry)

        expect(subject).to eq(true)
      end

      it 'starts a new entry' do
        expect(harvest_service).to receive(:create_entry)

        expect(subject).to eq(true)
      end
    end

    context 'when there is no active entry' do
      it 'starts a new entry' do
        expect(harvest_service).to receive(:create_entry)

        expect(subject).to eq(true)
      end
    end
  end
end
