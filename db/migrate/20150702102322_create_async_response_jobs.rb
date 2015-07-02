class CreateAsyncResponseJobs < ActiveRecord::Migration
  def change
    create_table :async_response_jobs do |t|
      t.string :job_type
      t.string :job_key
      t.string :scope
      t.integer :percentage_completion, default: 0
      t.integer :status, default: 0
      t.text :error
      t.text :data
      t.timestamp :expires_at
      t.timestamps null: false
    end
  end
end
