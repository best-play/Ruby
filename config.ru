require './imgs'
require 'rack/contrib'
require 'sidekiq/web'

use Rack::PostBodyContentTypeParser

run Rack::URLMap.new('/' => Img_process, '/sidekiq' => Sidekiq::Web)
