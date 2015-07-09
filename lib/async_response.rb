require "haml"
require "jquery-rails"

module AsyncResponse
  module Helper
    def job_type
      worker_class.name
    end

    def hashed_job_key
      joined_job_key = job_key.join if job_key.respond_to?(:join)
      Digest::SHA1.hexdigest(joined_job_key || job_key)
    end
  end
end

require "async_response/engine"
require "async_response/builder"
require "async_response/expirer"
require "async_response/workers/sidekiq"
