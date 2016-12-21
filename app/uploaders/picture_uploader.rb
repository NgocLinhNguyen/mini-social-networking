# encoding: utf-8

class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  version :profile_large do
    process resize_to_fill: [200, 200]
  end

  version :profile_normal do
    process resize_to_fill: [72, 72]
  end

  version :profile_small do
    process resize_to_fill: [48, 48]
  end

  version :thumb do
    process resize_to_fill: [140, 140]
  end

  version :cover do
    process resize_to_fill: [900, 200]
  end
end
