CarrierWave.configure do |config|
  config.storage = :fog
  config.fog_credentials = {
    provider:              "AWS",
    aws_access_key_id:     "AKIAJLVQKSEZL6MLR55A",
    aws_secret_access_key: "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",
    region:                "us-west-2"
  }
  config.cache_dir = "#{Rails.root}/tmp/uploads"
  config.fog_directory  = "deciortest"
  config.fog_public     = false
  config.fog_attributes = { "Cache-Control" => "max-age=#{365.day.to_i}" }
  config.storage = :fog
end
