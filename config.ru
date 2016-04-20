require './imgs'
require 'rack/contrib'

use Rack::PostBodyContentTypeParser

run Img_process