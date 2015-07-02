FactoryGirl.define do
  factory :job, class: AsyncResponse::Job do
    job_type 'DummyWorkerClass'
    job_key Digest::SHA1.hexdigest('test')
    expires_at 5.minutes.from_now

    trait :incomplete do
      percentage_completion 20
      status :running
    end

    trait :expired do
      percentage_completion 40
      status :running
      expires_at 1.minute.ago
    end

    trait :finished do
      percentage_completion 100
      status :finished
      data({ a: 1 })
    end

    trait :errored do
      percentage_completion 80
      status :errored
      error('Test error')
    end
  end
end
