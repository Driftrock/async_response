require 'spec_helper'

RSpec.describe AsyncResponse::Expirer do
  let!(:job) { FactoryGirl.create(:job, :finished) }

  subject { described_class.new(DummyWorkerClass, 'test') }

  it 'expires the job' do
    expect(job.expired?).to be_falsey
    subject.expire!
    expect(job.reload.expired?).to be_truthy
  end
end
