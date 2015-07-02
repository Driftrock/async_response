class ProjectsController < ApplicationController
  include AsyncResponse::Concerns::AsyncController

  def index
    respond_to do |format|
      format.json do
        async_response(
          ProjectsIndexWorker,
          expires_at: 5.minutes.from_now,
          job_key: 'projects_index',
          params: {
            page: 1,
            limit: 10
          }
        )
      end
    end
  end
end

class ProjectsIndexWorker
  include AsyncResponse::Workers::Sidekiq

  def self.perform_async(job_id)
    new.perform(job_id)
  end

  def perform(job_id)
    response_for(job_id) do |response|
      { job_a: 1 }
    end
  end
end

