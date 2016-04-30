require 'spec_helper'

RSpec.describe Parser::EntryCommand do
  let(:parser) { described_class.new }

  describe '#parse' do
    subject { parser.parse(command) }

    let(:project) { 'INT' }
    let(:task) { 'Meetings' }
    let(:notes) { 'Meeting with John' }

    context 'when hours are present' do
      let(:command) { "#{project} #{task} #{notes} #{hours}" }
      let(:hours) { '1:30' }
      let(:hours_value) { 1.5 }

      it 'returns result with project set' do
        expect(subject.project).to eq(project)
      end

      it 'returns result with task set' do
        expect(subject.task).to eq(task)
      end

      it 'returns result with notes set' do
        expect(subject.notes).to eq(notes)
      end

      it 'returns result with hours set' do
        expect(subject.hours).to be_within(0.01).of(hours_value)
      end
    end

    context 'when hours are missing' do
      let(:command) { "#{project} #{task} #{notes}" }

      it 'returns result with project set' do
        expect(subject.project).to eq(project)
      end

      it 'returns result with task set' do
        expect(subject.task).to eq(task)
      end

      it 'returns result with notes set' do
        expect(subject.notes).to eq(notes)
      end

      it 'returns result with empty hours' do
        expect(subject.hours).to eq(nil)
      end
    end

    context 'when notes are absent but hours are present' do
      let(:command) { "#{project} #{task} #{hours}" }
      let(:hours) { '1:30' }
      let(:hours_value) { 1.5 }

      it 'returns result with project set' do
        expect(subject.project).to eq(project)
      end

      it 'returns result with task set' do
        expect(subject.task).to eq(task)
      end

      it 'returns result with empty notes' do
        expect(subject.notes).to eq('')
      end

      it 'returns result with hours set' do
        expect(subject.hours).to be_within(0.01).of(hours_value)
      end
    end

    context 'when notes and hours are absent' do
      let(:command) { "#{project} #{task}" }

      it 'returns result with project set' do
        expect(subject.project).to eq(project)
      end

      it 'returns result with task set' do
        expect(subject.task).to eq(task)
      end

      it 'returns result with empty notes' do
        expect(subject.notes).to eq('')
      end

      it 'returns result with empty hours' do
        expect(subject.hours).to eq(nil)
      end
    end

    context 'when task is absent' do
      let(:command) { "#{project}" }

      it 'raises error' do
        expect { subject }.to raise_error(Parser::IncorrectCommandError)
      end
    end
  end
end
