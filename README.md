# SitemapGenerator::AwsS3Adapter

This is a yet another AWS S3 adapter for [sitemap_generator](https://github.com/kjvarga/sitemap_generator), built with official [aws-sdk](https://rubygems.org/gems/aws-sdk) v2.

## Motivation

fog introduces [bunch of runtime dependencies](https://rubygems.org/gems/fog). :weary:

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sitemap_generator-aws_s3_adapter'
```

And then execute:

```console
$ bundle
```

## Usage

Add following lines to your app's `config/sitemap.rb`.

```ruby
SitemapGenerator::Sitemap.adapter = SitemapGenerator::AwsS3Adapter.new(
  access_key_id: '...',
  secret_access_key: '...',
  region: '...',
  bucket_name: '...'
)
```

If the specified bucket doesn't exist, it will create in the region automatically.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec sitemap_generator-aws_s3_adapter` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sitemap_generator-aws_s3_adapter. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
