require 'spec_helper'

RSpec.describe Command::StartNewEntry do
  let(:command) do
    described_class.new(harvest_service, project_id: project_id, task_id: task_id, notes: notes,
                        hours_ago: hours_ago)
  end
  
  let(:harvest_service) { double.as_null_object }
  let(:project_id) { 15 }
  let(:task_id) { 10 }
  let(:notes) { 'Doing my thing' }

  describe '#execute' do
    subject { command.execute }

    let(:created_entry) { double }

    context 'when user starts the entry now' do
      let(:hours_ago) { nil }

      it 'calls harvest api to create a new entry' do
        entry = nil
        expect(harvest_service).to receive(:create_entry) { |e| entry = e }.and_return(created_entry)
        expect(harvest_service).not_to receive(:toggle_entry)

        expect(subject).to eq(true)

        expect(entry.project_id).to eq(project_id)
        expect(entry.task_id).to eq(task_id)
        expect(entry.notes).to eq(notes)
        expect(entry.hours).to eq(nil)
      end
    end

    context 'when user starts the entry now' do
      let(:hours_ago) { 1.5 }

      it 'calls harvest api to create a new entry and toggles it' do
        entry = nil
        expect(harvest_service).to receive(:create_entry) { |e| entry = e }.and_return(created_entry)
        expect(harvest_service).to receive(:toggle_entry).with(created_entry)

        expect(subject).to eq(true)

        expect(entry.project_id).to eq(project_id)
        expect(entry.task_id).to eq(task_id)
        expect(entry.notes).to eq(notes)
        expect(entry.hours).to eq(hours_ago)
      end
    end
  end
end
