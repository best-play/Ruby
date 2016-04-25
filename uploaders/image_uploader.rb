class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def move_to_cache
    true
  end

  def move_to_store
    true
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def store_dir
    "#{model.id}"
  end

  def cache_dir
    "tmp/#{model.id}"
  end

  # Обработка картинки
  process :resize_to_fit => [1000, 1000]
  process :radial_blur => 5

  def radial_blur amount
    manipulate! do |img|
      img.radial_blur amount
      img = yield img if block_given?
      img
    end
  end

end