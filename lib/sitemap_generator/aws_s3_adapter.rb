require 'sitemap_generator'

begin
  require 'aws-sdk'
rescue LoadError
  raise LoadError, "Missing required 'aws-sdk. Please 'gem install aws-sdk'."
end

module SitemapGenerator
  # Adapter for S3 with aws-sdk gem.
  class AwsS3Adapter
    # Public: Initialize an instance.
    #
    # access_key_id     - An Access Key ID String.
    # secret_access_key - A Secret Access Key String.
    # bucket_name       - A bucket name String.
    # region            - A region name String.
    #
    # Returns nothing.
    def initialize(opts = {})
      @access_key_id = opts[:access_key_id]
      @secret_access_key = opts[:secret_access_key]
      @bucket_name = opts[:bucket_name]
      @region = opts[:region]
    end

    # Public: Writes a sitemap to S3 bucket.
    #
    # location - A SitemapGenerator::SitemapLocation object.
    # raw_data - A raw data String.
    #
    # Returns nothing.
    def write(location, raw_data)
      SitemapGenerator::FileAdapter.new.write(location, raw_data)

      create_bucket unless bucket_exists?
      put_sitemap(location)
    end

    private

    # Internal: Retuns S3 client object.
    #
    # Returns a Aws::S3::Client.
    def s3_client
      @s3_client ||= Aws::S3::Client.new(
        access_key_id: @access_key_id,
        secret_access_key: @secret_access_key,
        region: @region
      )
    end

    # Internal: Returns whether the target bucket does exist?
    #
    # Returns boolean.
    def bucket_exists?
      resp = s3_client.list_buckets
      bucket = resp.buckets.find { |i| i.name == @bucket_name }
      bucket != nil
    end

    # Internal: Creates a new bucket.
    #
    # Returns nothing.
    def create_bucket
      s3_client.create_bucket(acl: 'private', bucket: @bucket_name)
    end

    # Internal: Put a sitemap into the bucket.
    #
    # location - A SitemapGenerator::SitemapLocation object.
    #
    # Returns nothing.
    def put_sitemap(location)
      content_type = location[:compress] ? 'application/x-gzip' : 'application/xml'

      s3_client.put_object(
        acl: 'public-read',
        body: File.open(location.path),
        bucket: @bucket_name,
        cache_control: 'private, max-age=0, no-cache',
        content_type: content_type,
        key: location.path_in_public
      )
    end
  end
end
