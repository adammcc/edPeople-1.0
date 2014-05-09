module Ep
  class Lib
    def self.bucket_path(bucket_suffix)
      "ep-#{ENV['EP_AWS_S3BUCKET']}-#{bucket_suffix}"
    end
  end
end