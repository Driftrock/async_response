require 'spec_helper'

RSpec.describe AsyncResponse::Builder do
  class DummyWorkerClass
  end

  subject do
    described_class.new(
      DummyWorkerClass,
      5.minutes.from_now,
      'test'
    )
  end

  let(:params) do
    { a: 1, b: 2 }
  end

  before do
    allow(DummyWorkerClass).to receive(:perform_async)
  end

  context 'when job does not exist' do
    it 'creates the job' do
      expect {
        subject.build(params)
      }.to change(AsyncResponse::Job, :count).by(1)
    end

    it 'creates the job with correct params' do
      subject.build(params)
      expect(AsyncResponse::Job.last.params).to eq params
    end

    it 'schedule the job execution' do
      expect(DummyWorkerClass).to receive(:perform_async)
      subject.build(params)
    end
  end

  context 'when job is not complete' do
    let!(:job) { FactoryGirl.create(:job, :incomplete) }

    it 'renders the job status' do
      response = subject.build(params)
      expect(response).to eq(
        { status: 'running', percentage_completion: 20,
          data: nil, error: nil }
      )
    end
  end
end
