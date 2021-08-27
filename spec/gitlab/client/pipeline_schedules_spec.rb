# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Gitlab::Client do
  describe '.pipeline_schedules' do
    before do
      stub_get('/projects/3/pipeline_schedules', 'pipeline_schedules')
      @pipeline_schedules = Gitlab.pipeline_schedules(3)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/pipeline_schedules')).to have_been_made
    end

    it "returns a response of project's pipeline schedules" do
      expect(@pipeline_schedules).to be_a Gitlab::PaginatedResponse
    end
  end

  describe '.pipeline_schedule' do
    before do
      stub_get('/projects/3/pipeline_schedules/5', 'pipeline_schedule')
      @pipeline_schedule = Gitlab.pipeline_schedule(3, 5)
    end

    it 'gets the correct resource' do
      expect(a_get('/projects/3/pipeline_schedules/5')).to have_been_made
    end

    it "returns a response of project's pipeline schedules" do
      expect(@pipeline_schedule).to be_a Gitlab::ObjectifiedHash
    end
  end

  describe '.create_pipeline_schedule' do
    before do
      stub_post('/projects/3/pipeline_schedules', 'pipeline_schedule_create')
      @pipeline_schedule_create = Gitlab.create_pipeline_schedule(3)
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/3/pipeline_schedules')).to have_been_made
    end

    it 'returns a single pipeline schedule' do
      expect(@pipeline_schedule_create).to be_a Gitlab::ObjectifiedHash
    end

    it 'returns information about a pipeline schedule' do
      expect(@pipeline_schedule_create.owner.name).to eq('Administrator')
    end
  end

  describe '.edit_pipeline_schedule' do
    before do
      stub_put('/projects/3/pipeline_schedules/13', 'pipeline_schedule_update')
      @pipeline_schedule_update = Gitlab.edit_pipeline_schedule(3, 13)
    end

    it 'gets the correct resource' do
      expect(a_put('/projects/3/pipeline_schedules/13')).to have_been_made
    end

    it 'returns a single pipeline schedule' do
      expect(@pipeline_schedule_update).to be_a Gitlab::ObjectifiedHash
    end

    it 'returns information about a pipeline schedule' do
      expect(@pipeline_schedule_update.owner.name).to eq('Administrator')
    end
  end

  describe '.pipeline_schedule_take_ownership' do
    before do
      stub_post('/projects/3/pipeline_schedules/13/take_ownership', 'pipeline_schedule')
      @pipeline_schedule = Gitlab.pipeline_schedule_take_ownership(3, 13)
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/3/pipeline_schedules/13/take_ownership')).to have_been_made
    end

    it 'returns information about the pipeline schedule' do
      expect(@pipeline_schedule.created_at).to eq('2017-05-19T13:31:08.849Z')
      expect(@pipeline_schedule.description).to eq('Test schedule pipeline')
    end
  end

  describe '.run_pipeline_schedule' do
    before do
      stub_post('/projects/3/pipeline_schedules/13/play', 'pipeline_schedule_run')
      @pipeline_schedule_run = Gitlab.run_pipeline_schedule(3, 13)
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/3/pipeline_schedules/13/play')).to have_been_made
    end

    it 'returns created message' do
      expect(@pipeline_schedule_run).to be_a Gitlab::ObjectifiedHash
    end
  end

  describe '.delete_pipeline_schedule' do
    before do
      stub_delete('/projects/3/pipeline_schedules/13', 'pipeline_schedule')
      @pipeline_schedule = Gitlab.delete_pipeline_schedule(3, 13)
    end

    it 'gets the correct resource' do
      expect(a_delete('/projects/3/pipeline_schedules/13')).to have_been_made
    end

    it 'returns a single pipeline' do
      expect(@pipeline_schedule).to be_a Gitlab::ObjectifiedHash
    end

    it 'returns information about the deleted pipeline' do
      # expect(@pipeline_schedule.id).to eq(13)
    end
  end

  describe '.create_pipeline_schedule_variable' do
    before do
      stub_post('/projects/3/pipeline_schedules/13/variables', 'pipeline_schedule_variable')
        .with(body: { key: 'NEW VARIABLE', value: 'new value' })
      @pipeline_schedule_variable = Gitlab.create_pipeline_schedule_variable(3, 13,
                                                                             key: 'NEW VARIABLE',
                                                                             value: 'new value')
    end

    it 'gets the correct resource' do
      expect(a_post('/projects/3/pipeline_schedules/13/variables')
        .with(body: { key: 'NEW VARIABLE', value: 'new value' })).to have_been_made
    end

    it 'returns a single variable' do
      expect(@pipeline_schedule_variable).to be_a Gitlab::ObjectifiedHash
    end

    it 'returns the created variable' do
      expect(@pipeline_schedule_variable.value).to eq('new value')
    end
  end

  describe '.edit_pipeline_schedule_variable' do
    before do
      stub_put('/projects/3/pipeline_schedules/13/variables/NEW%20VARIABLE', 'pipeline_schedule_variable_update')
        .with(body: { value: 'update value' })
      @pipeline_schedule_variable = Gitlab.edit_pipeline_schedule_variable(3, 13, 'NEW VARIABLE', value: 'update value')
    end

    it 'returns a single variable' do
      expect(@pipeline_schedule_variable).to be_a Gitlab::ObjectifiedHash
    end

    it 'has the updated value' do
      expect(@pipeline_schedule_variable.value).to eq('update value')
    end
  end

  describe '.delete_pipeline_schedule_variable' do
    before do
      stub_delete('/projects/3/pipeline_schedules/13/variables/NEW%20VARIABLE', 'pipeline_schedule_variable')
      @pipeline_schedule_variable = Gitlab.delete_pipeline_schedule_variable(3, 13, 'NEW VARIABLE')
    end

    it 'returns a single variable' do
      expect(@pipeline_schedule_variable).to be_a Gitlab::ObjectifiedHash
    end

    it 'has the value of the deleted variable' do
      expect(@pipeline_schedule_variable.value).to eq('new value')
    end
  end
end
