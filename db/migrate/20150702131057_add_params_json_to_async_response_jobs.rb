class AddParamsJsonToAsyncResponseJobs < ActiveRecord::Migration
  def change
    add_column :async_response_jobs, :params_json, :text
  end
end
