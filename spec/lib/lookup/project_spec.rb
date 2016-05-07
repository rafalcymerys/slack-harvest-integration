require 'spec_helper'

RSpec.describe Lookup::Project do
  let(:lookup) { described_class.new(harvest_time_service) }
  
  let(:harvest_time_service) { double }

  let(:project1) { Harvest::TrackableProject.new(name: 'Website', code: 'AWEB') }
  let(:project2) { Harvest::TrackableProject.new(name: 'Webinar', code: 'AWEBSTO') }
  let(:project3) { Harvest::TrackableProject.new(name: 'Internal', code: nil) }
  let(:project4) { Harvest::TrackableProject.new(name: 'Internal management', code: nil) }

  before do
    allow(harvest_time_service).to receive(:trackable_projects).and_return([project1, project2, project3, project4])
  end

  describe '#find' do
    subject { lookup.find(phrase) }

    context 'when phrase matches multiple names' do
      let(:phrase) { 'Web' }

      it 'returns projects with these names' do
        expect(subject).to match_array([project1, project2])
      end
    end

    context 'when phrase matches name but with different case' do
      let(:phrase) { 'weB' }

      it 'returns projects with these names' do
        expect(subject).to match_array([project1, project2])
      end
    end

    context 'when phrase matches a single name' do
      let(:phrase) { 'Websi' }

      it 'returns the project with that name' do
        expect(subject).to eq([project1])
      end
    end

    context 'when phrase matches a single name exactly' do
      let(:phrase) { 'Website' }

      it 'returns the project with that name' do
        expect(subject).to eq([project1])
      end
    end

    context 'when phrase matches multiple names but one exactly' do
      let(:phrase) { 'Internal' }

      it 'returns the project with exact match' do
        expect(subject).to eq([project3])
      end
    end

    context 'when phrase matches part of code' do
      let(:phrase) { 'AWE' }

      it 'returns projects with matching codes' do
        expect(subject).to match_array([project1, project2])
      end
    end

    context 'when phrase matches a code exactly' do
      let(:phrase) { 'AWEBSTO' }

      it 'returns the project with that code' do
        expect(subject).to match_array([project2])
      end
    end

    context 'when pharse does not match anything' do
      let(:phrase) { 'Test' }

      it 'returns an empty array' do
        expect(subject).to eq([])
      end
    end
  end
end
