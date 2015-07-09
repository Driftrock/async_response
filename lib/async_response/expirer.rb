module AsyncResponse
  class Expirer
    include Helper
    attr_reader :worker_class, :job_key
    def initialize(worker_class, job_key)
      @worker_class = worker_class
      @job_key = job_key
    end

    def expire!
      AsyncResponse::Job.expire!(job_type, hashed_job_key)
    end
  end
end
