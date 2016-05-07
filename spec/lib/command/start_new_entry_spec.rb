require 'spec_helper'

RSpec.describe Command::StartNewEntry do
  let(:command) { described_class.new(parsed_command, harvest_time_service: harvest_time_service) }
  let(:parsed_command) { Parser::EntryCommandResult.new(project: project, task: task, notes: notes, hours: hours) }

  let(:project1) { Harvest::TrackableProject.new(name: project1_name, code: project1_code, tasks: [task1, task2]) }
  let(:project2) { Harvest::TrackableProject.new(name: project2_name, code: project2_code, tasks: [task1, task2]) }

  let(:project1_name) { 'Website' }
  let(:project1_code) { 'WEB' }
  let(:project2_name) { 'Webstore' }
  let(:project2_code) { 'WEBST' }

  let(:task1) { Harvest::TrackableProject::Task.new(name: task1_name) }
  let(:task2) { Harvest::TrackableProject::Task.new(name: task2_name) }

  let(:task1_name) { 'Development' }
  let(:task2_name) { 'Determining requirements' }

  let(:harvest_time_service) { double }

  before do
    allow(harvest_time_service).to receive(:trackable_projects).and_return([project1, project2])
  end

  describe '#execute' do
    subject { command.execute }

    context 'when no matching projects were found' do
      let(:project) { 'Internal' }
      let(:task) { 'Development' }
      let(:notes) { 'Doing my stuff' }
      let(:hours) { 1.5 }

      it 'returns an error message' do
        expect(subject.text).to eq(Response::Text::PROJECT_NOT_FOUND)
      end
    end

    context 'when multiple projects were found' do
      let(:project) { 'We' }
      let(:task) { 'Development' }
      let(:notes) { 'Doing my stuff' }
      let(:hours) { 1.5 }

      it 'returns an error message' do
        expect(subject.text).to eq(Response::Text::MULTIPLE_PROJECTS_FOUND)
      end
    end

    context 'when no matching tasks were found' do
      let(:project) { 'Website' }
      let(:task) { 'Management' }
      let(:notes) { 'Doing my stuff' }
      let(:hours) { 1.5 }

      it 'returns an error message' do
        expect(subject.text).to eq(Response::Text::TASK_NOT_FOUND)
      end
    end

    context 'when multiple matching tasks were found' do
      let(:project) { 'Website' }
      let(:task) { 'De' }
      let(:notes) { 'Doing my stuff' }
      let(:hours) { 1.5 }

      it 'returns an error message' do
        expect(subject.text).to eq(Response::Text::MULTIPLE_TASKS_FOUND)
      end
    end
  end
end
