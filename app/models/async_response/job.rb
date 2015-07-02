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
  end
end
