$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'sitemap_generator/aws_s3_adapter'
require 'sitemap_generator/aws_s3_adapter/version'

RSpec.configure do |config|
  Aws.config.update(stub_responses: true)
end
