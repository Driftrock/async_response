# AsyncResponse

Easily create async JSON responses with Rails 4+.

## Install
```ruby
# add the gem to your Gemfile
gem 'async_response'
```

```shell
bundle install
rake async_response:install:migrations
rake db:migrate
```

```ruby
# config/routes.rb
mount AsyncResponse::Engine => "/async_response"
```

You can use authentication, e.g.
```ruby
admin_authenticated do
  mount AsyncResponse::Engine => "/async_response"
end
```

## Usage
Currently the gem requires Sidekiq but this should become optional.

```ruby
class ProjectsController < ApplicationController
  include AsyncResponse::Concerns::AsyncController
  
  def index
    async_response(
      ProjectsIndexWorker,
      expires_at: 5.minutes.from_now,
      job_key: 'projects_index_1_10',
      params: {
        page: 1,
        limit: 10
      }
    )
  end
  
  def expire!
    # To expire a response
    async_response_expire!(ProjectsIndexWorker, job_key: 'projects_index_1_10')
  end
end

class ProjectsIndexWorker
  include Sidekiq::Worker
  include AsyncResponse::Workers::Sidekiq
  
  sidekiq_options retry: false
  # Is recommended to disable retries

  def perform(job_id)
    response_for(job_id) do |response|
      # return a Hash that will be stored as a JSON
      { projects: [...] }
    end
  end
end
```

## Responses

```ruby
# When started
# GET projects#index
{ status: 'started', percentage_completion: 0, data: nil, error: nil }

# When finished
# GET projects#index
{
  status: 'finished',
  percentage_completion: 100,
  data: { projects: [...] },
  error: nil
}
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/shapeshifter/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

This project rocks and uses MIT-LICENSE.
