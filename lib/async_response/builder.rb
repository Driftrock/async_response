module AsyncResponse
  class Builder
    include AsyncResponse::Helper
    attr_reader :worker_class, :expires_at, :job_key
    def initialize(worker_class, expires_at, job_key)
      @worker_class = worker_class
      @expires_at = expires_at
      @job_key = job_key
    end

    def build(params)
      job = async_job || create_job(params)
      response = respond_with(job)
      # Set job as shown, needs to display at least once
      # before we discount it due to expiry
      job.shown! if job.finished?
      response
    end

    private

    def async_job
      @async_job ||= AsyncResponse::Job.valid_job(job_type,
                                                  hashed_job_key)
    end

    def create_job(params)
      @new_job ||= AsyncResponse::Job.create!(
        job_type: job_type,
        job_key: hashed_job_key,
        expires_at: expires_at || Time.zone.now,
        params: params
      )

      schedule_job(@new_job)
      @new_job
    end

    def respond_with(job)
      {
        # Shown is only internally applicable, indistinguishable
        # from finished as far as a user is concerned
        status: job.shown? ? 'finished' : job.status,
        percentage_completion: job.percentage_completion,
        data: job.data,
        error: job.error
      }
    end

    def schedule_job(job)
      worker_class.perform_async(job.id)
    end
  end
end
