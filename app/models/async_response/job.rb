module AsyncResponse
  class Job < ActiveRecord::Base
    enum status: [:started, :running, :finished, :errored]
    serialize :data, JSON
    validates :job_type, :expires_at, presence: true

    def self.valid_job(type, key)
      record = where(job_type: type, job_key: key).last
      return nil unless record
      return nil if record.expired?

      record
    end

    def params=(hash)
      self.params_json = hash.to_json
    end

    def params
      JSON.parse(params_json).deep_symbolize_keys rescue nil
    end

    def expired?
      expires_at < Time.now
    end

    def finished!
      increment_percentage(100)
      self.status = :finished
      save!
    end

    def increment_percentage(increment)
      total = (percentage_completion || 0) + increment
      total = [[total, 100].min, 0].max
      self.percentage_completion = total
    end

    def increment_percentage!(increment)
      increment_percentage(increment)
      save!
    end
  end
end
