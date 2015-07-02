module AsyncResponse
  class Builder
    attr_reader :worker_class, :expires_at, :job_key
    def initialize(worker_class, expires_at, job_key)
      @worker_class = worker_class
      @expires_at = expires_at
      @job_key = job_key
    end

    def build(params)
      respond_with(async_job || create_job(params))
    end

    private

    def async_job
      @async_job ||= AsyncResponse::Job.valid_job(job_type, job_key)
    end

    def create_job(params)
      @new_job ||= AsyncResponse::Job.create!(
        job_type: job_type,
        job_key: job_key,
        expires_at: expires_at,
        params: params
      )

      schedule_job(@new_job)
      @new_job
    end

    def respond_with(job)
      {
        status: job.status,
        percentage_completion: job.percentage_completion,
        data: job.data,
        error: job.error
      }
    end

    def job_type
      worker_class.name
    end

    def schedule_job(job)
      worker_class.perform_async(job.id)
    end
  end
end
