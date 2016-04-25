CarrierWave.configure do |config|
  config.root = File.join(Dir.pwd, 'public/uploads/')
  config.asset_host = ENV['ASSETS_HOST']

  config.permissions = 0666
  config.directory_permissions = 0777
end
