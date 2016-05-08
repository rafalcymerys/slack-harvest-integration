require 'spec_helper'

RSpec.describe Response::ErrorMessageFactory do
  let(:factory) { described_class.new }

  describe '#message_for_incorrect_project' do
    subject { factory.message_for_incorrect_project(lookup_match) }

    context 'when no projects were found' do
      let(:lookup_match) { Lookup::Match.new([]) }

      it 'creates a message with not found text' do
        expect(subject.text).to eq(Response::Text::PROJECT_NOT_FOUND)
      end
    end

    context 'when multiple project were found' do
      let(:lookup_match) { Lookup::Match.new([project1, project2]) }

      let(:project1) { Harvest::TrackableProject.new(name: project1_name, code: project1_code) }
      let(:project2) { Harvest::TrackableProject.new(name: project2_name, code: nil) }

      let(:project1_name) { 'Internal' }
      let(:project1_code) { 'INT' }
      let(:project2_name) { 'Website' }

      it 'creates a message with multiple projects found text' do
        expect(subject.text).to eq(Response::Text::MULTIPLE_PROJECTS_FOUND)
      end
    end
  end

  describe '#message_for_incorrect_task' do
    subject { factory.message_for_incorrect_task(lookup_match) }

    context 'when no tasks were found' do
      let(:lookup_match) { Lookup::Match.new([]) }

      it 'creates a message with not found text' do
        expect(subject.text).to eq(Response::Text::TASK_NOT_FOUND)
      end
    end

    context 'when multiple tasks were found' do
      let(:lookup_match) { Lookup::Match.new([task1, task2]) }

      let(:task1) { Harvest::TrackableProject::Task.new(name: task1_name) }
      let(:task2) { Harvest::TrackableProject::Task.new(name: task2_name) }

      let(:task1_name) { 'Development' }
      let(:task2_name) { 'Meetings' }

      it 'creates a message with multiple projects found text' do
        expect(subject.text).to eq(Response::Text::MULTIPLE_TASKS_FOUND)
      end
    end
  end
end
