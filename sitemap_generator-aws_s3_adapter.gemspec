# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sitemap_generator/aws_s3_adapter/version'

Gem::Specification.new do |spec|
  spec.name          = 'sitemap_generator-aws_s3_adapter'
  spec.version       = SitemapGenerator::AwsS3Adapter::VERSION
  spec.authors       = ['Junya Ogura', 'qnyp, inc.']
  spec.email         = ['junyaogura@gmail.com']

  spec.summary       = %q(Yet another AWS S3 adapter for sitemap_generator gem.)
  spec.description   = %q(Yet another AWS S3 adapter for sitemap_generator gem. This adapter works with official aws-sdk gem instead of fog.)
  spec.homepage      = 'https://github.com/qnyp/sitemap_generator-aws_s3_adapter'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'aws-sdk', '~> 2.2.0'
  spec.add_runtime_dependency 'sitemap_generator', '~> 5.1.0'

  spec.add_development_dependency 'bundler', '~> 1.11'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
