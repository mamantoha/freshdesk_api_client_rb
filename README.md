# Freshdesk API Client

[![Build Status][travis_badge]][travis]
[![Gem Version][rubygems_badge]][rubygems]
[![Code Climate][codeclimate_badge]][codeclimate]

A Ruby API client that interfaces with freshdesk.com web service. This client supports regular CRUD operation.

Please see [API documentation](http://freshdesk.com/api) for more information.

As of now,it supports the following:

* Solution Category
* Solution Folder
* Solution Article


To experiment with that code, run `bin/console` for an interactive prompt.

## Installation

The Freshdesk API client can be installd using Bundler or Rubygems.

### Bundler

Add this line to your application's Gemfile:

```ruby
gem 'freshdesk_api'
```

And then execute:

```
$ bundle
```

### Rubygems

Or install it yourself as:

```
$ gem install freshdesk_api
```

## Configuration

Configuration is done through a block returning an instance of `FreshdeskAPI::Client`. The block is mandatory and if not passed, an `ArgumentError` will be thrown.

```ruby
require 'freshdesk_api'

client = FreshdeskAPI::Client.new do |config|
  config.base_url = '<- your-freshdesk-url ->' # e.g. 'https://mydesk.freshdesk.com'
  config.username = 'login.email@freshdesk.com'
  config.password = 'your freshdesk password'

  require 'logger'
  config.logger = Logger.new(STDOUT)
end
```

Note: This FreshdeskAPI API client only supports basic authentication at the moment.

## Usage

The result of configuration is an instance of `FreshdeskAPI::Client` which can then be used in two different methods.

One way to use the client is to pass it in as an argument to individual classes.

```ruby
FreshdeskAPI::SolutionCategory.create!(client, name: 'API', description: 'API related documents')
FreshdeskAPI::SolutionArticle.find!(client, id: 1, 1: category_id, folder_id: 1)
FreshdeskAPI::SolutionFolder.update!(client, id: 1, category_id: 1, name: 'Folder API')
FreshdeskAPI::SolutionArticle.destroy!(client, id: 1, category_id: 1, folder_id: 1)
```
Another way is to use the instance methods under client.

```ruby
categories = client.solution_categories
category = categories.create!(name: 'API', description: 'API related documents')
category.update!(name: 'API v2', description: 'API related documents v2')
category = categories.find!(id: 1)
category.destroy!
```

The methods under `FreshdeskAPI::Client` (such as `.solution_categories`) return an instance of `FreshdeskAPI::Collection` a lazy-loaded list of that resource.

Actual requests may not be sent until an explicit `FreshdeskAPI::Collection#all!`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/mamantoha/freshdesk_api_client_rb/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License and Author

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

Copyright (c) 2015-2018 by Anton Maminov

[travis_badge]: http://img.shields.io/travis/mamantoha/freshdesk_api_client_rb.svg?style=flat
[travis]: https://travis-ci.org/mamantoha/freshdesk_api_client_rb

[rubygems_badge]: http://img.shields.io/gem/v/freshdesk_api.svg?style=flat
[rubygems]: https://rubygems.org/gems/freshdesk_api

[codeclimate_badge]: http://img.shields.io/codeclimate/github/mamantoha/freshdesk_api_client_rb.svg?style=flat
[codeclimate]: https://codeclimate.com/github/mamantoha/freshdesk_api_client_rb
