module AsyncResponse
  class ResponsesController < ApplicationController

    def index
      render locals: { jobs: jobs }
    end

    def show
      render json: job
    end

    def destroy
      job.destroy
      redirect_to async_response.responses_path
    end

    protected

    def jobs
      @jobs ||= AsyncResponse::Job.order(id: :desc)
        .limit(10)
    end

    def job
      @job ||= AsyncResponse::Job.find(params[:id])
    end
  end
end
