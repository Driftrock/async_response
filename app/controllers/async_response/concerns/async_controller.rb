module AsyncResponse
  module Concerns
    module AsyncController
      extend ActiveSupport::Concern

      included do
      end

      def async_response(worker_class, expires_at: 5.minutes_from_now,
                         job_key: nil, params: nil)

        response_json = AsyncResponse::Builder
          .new(worker_class, expires_at, job_key)
          .build(params)

        render(json: response_json)
      end

      def async_response_expire!(worker_class, job_key: nil)
        AsyncResponse::Expirer.new(worker_class, job_key).expire!
      end
    end
  end
end
