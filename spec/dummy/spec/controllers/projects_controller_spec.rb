require 'spec_helper'

RSpec.describe ProjectsController, type: :controller do
  context 'when job is complete' do
    let!(:job) do
      FactoryGirl.create(
        :job, :finished,
        data: { a: 1 },
        job_type: 'ProjectsIndexWorker',
        job_key: 'projects_index'
      )
    end

    it 'renders the job data' do
      get :index, format: :json

      expect(response.body).to eq(
        {
          status: 'finished',
          percentage_completion: 100,
          data: { a: 1 },
          error: nil
        }.to_json
      )
    end
  end

  context 'when there is no complete job' do
    it 'renders the job data' do
      get :index, format: :json
      get :index, format: :json

      expect(response.body).to eq(
        {
          status: 'finished',
          percentage_completion: 100,
          data: { job_a: 1 },
          error: nil
        }.to_json
      )
    end
  end
end
