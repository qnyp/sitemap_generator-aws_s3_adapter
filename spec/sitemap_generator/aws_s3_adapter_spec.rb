require 'spec_helper'

describe SitemapGenerator::AwsS3Adapter do
  SITEMAP_FIXTURE = File.expand_path('../../fixtures/sitemap.xml', __FILE__)

  it 'has a version number' do
    expect(SitemapGenerator::AwsS3Adapter::VERSION).not_to be nil
  end

  describe '#write' do
    let(:options) {
      {
        access_key_id: 'A' * 20,
        secret_access_key: 'B' * 40,
        bucket_name: 'test-bucket',
        region: 'us-east-1',
      }
    }
    let(:compression) { false }
    let(:location) {
      SitemapGenerator::SitemapLocation.new(filename: SITEMAP_FIXTURE, compress: compression)
    }
    let(:raw_data) { File.read(SITEMAP_FIXTURE) }

    subject { described_class.new(options) }

    it 'instantiates S3 client with specified options' do
      allow(Aws::S3::Client).to receive(:new).and_call_original

      subject.write(location, raw_data)

      expect(Aws::S3::Client).to have_received(:new).with(
        access_key_id: options[:access_key_id],
        secret_access_key: options[:secret_access_key],
        region: options[:region]
      )
    end

    it "puts S3 object with 'application/xml' content type" do
      expect_any_instance_of(Aws::S3::Client).to receive(:put_object).with(
        acl: 'public-read',
        body: an_instance_of(File),
        bucket: options[:bucket_name],
        cache_control: 'private, max-age=0, no-cache',
        content_type: 'application/xml',
        key: location.path_in_public
      )

      subject.write(location, raw_data)
    end

    context 'bucket exists' do
      before do
        buckets = [double('bucket', name: options[:bucket_name])]
        response = double('response', buckets: buckets)
        allow_any_instance_of(Aws::S3::Client).to receive(:list_buckets).and_return(response)
      end

      it "doesn't create bucket" do
        expect_any_instance_of(Aws::S3::Client).not_to receive(:create_bucket)
        subject.write(location, raw_data)
      end
    end

    context "bucket doesn't exist" do
      before do
        buckets = [
          double('bucket', name: 'foo'),
          double('bucket', name: 'bar'),
        ]
        response = double('response', buckets: buckets)
        allow_any_instance_of(Aws::S3::Client).to receive(:list_buckets).and_return(response)
      end

      it 'creates bucket' do
        expect_any_instance_of(Aws::S3::Client).to receive(:create_bucket).with(
          acl: 'private',
          bucket: options[:bucket_name]
        )

        subject.write(location, raw_data)
      end
    end

    context 'compression enabled' do
      let(:compression) { true }

      it "puts S3 object with 'application/x-gzip' content type" do
        expect_any_instance_of(Aws::S3::Client).to receive(:put_object).with(
          acl: 'public-read',
          body: an_instance_of(File),
          bucket: options[:bucket_name],
          cache_control: 'private, max-age=0, no-cache',
          content_type: 'application/x-gzip',
          key: location.path_in_public
        )

        subject.write(location, raw_data)
      end
    end
  end
end
