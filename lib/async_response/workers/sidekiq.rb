module AsyncResponse
  module Workers
    module Sidekiq
      extend ActiveSupport::Concern

      def response_for(job_id, &block)
        job = AsyncResponse::Job.find(job_id)
        return unless job

        worker_response = WorkerResponse.new(job)
        data = block.call(worker_response)
        worker_response.finished!(data)

      rescue StandardError => e
        job.error = e.message
        job.errored!
        raise e
      end

      private

      class WorkerResponse
        attr_reader :job
        def initialize(job)
          @job = job
        end

        def params
          job.params
        end

        def finished!(data)
          job.data = data
          job.finished!
        end

        def increment_percentage!(increment)
          job.increment_percentage!(increment)
        end
      end
    end
  end
end
