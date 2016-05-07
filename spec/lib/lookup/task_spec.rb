require 'spec_helper'

RSpec.describe Lookup::Task do
  let(:lookup) { described_class.new(project) }

  let(:project) { Harvest::TrackableProject.new(name: 'Internal', tasks: [task1, task2, task3]) }

  let(:task1) { Harvest::TrackableProject::Task.new(name: 'Management') }
  let(:task2) { Harvest::TrackableProject::Task.new(name: 'Maintenance') }
  let(:task3) { Harvest::TrackableProject::Task.new(name: 'Development') }

  describe '#find' do
    subject { lookup.find(phrase) }

    context 'when multiple names match the phrase' do
      let(:phrase) { 'Ma' }

      it 'returns tasks with matching names' do
        expect(subject.to_a).to match_array([task1, task2])
      end
    end

    context 'when multiple names match the phrase but with different case' do
      let(:phrase) { 'mA' }

      it 'returns tasks with matching names' do
        expect(subject.to_a).to match_array([task1, task2])
      end
    end

    context 'when a single name matches the phrase' do
      let(:phrase) { 'dev' }

      it 'returns the matching task' do
        expect(subject.get).to eq(task3)
      end
    end

    context 'when no names match the phrase' do
      let(:phrase) { 'Test' }

      it 'returns an empty array' do
        expect(subject.empty?).to eq(true)
      end
    end
  end
end
