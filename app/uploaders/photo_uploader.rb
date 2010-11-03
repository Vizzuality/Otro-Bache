# encoding: utf-8

class PhotoUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick

  storage :file
  # storage :s3

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process :resize_horizontal_or_vertical

    def resize_horizontal_or_vertical
      manipulate! do |img|
        img = if img.rows < img.columns
          img.resize_to_fill(240, 177)
        else
          img.resize_to_fill(178, 241)
        end
      end
    end
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
