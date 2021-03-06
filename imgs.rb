require 'sinatra/base'
require 'sinatra/param'
require 'sinatra/json'
require 'sinatra-initializers'
require 'dotenv'
require 'mongoid'
require 'carrierwave/mongoid'
require 'sidekiq'
require 'sidekiq/api'

require './uploaders/image_uploader'
require './models/img_process'
require './app/workers/sidekiq_worker'

Dotenv.load

class Img_process < Sinatra::Application
  register Sinatra::Initializers
  configure do
    set :raise_sinatra_param_exceptions, true
    set show_exceptions: false
    set :public_folder, 'public/uploads'
  end

  post '/process' do
    param :image, String, required: true
    param :task, String, in: ['resize', 'blur'], required: true
    param :task_params, Hash, required: true

    process = ImgProcess.new params
    process.remote_image_url = params['image']
    process.task_status = 'in progress'

    process.save!

    SidekiqWorker.perform_async(process.id.to_s)

    json({
        id: process.id.to_s,
        img_url: '',
        task: process.task.to_s,
        task_status: process.task_status.to_s,
        task_params: process.task_params.to_s,
    })
  end

  get '/task' do
    param :id, String, required: true

    id = params['id']
    task = ImgProcess.find id

    json({
        id: task.id.to_s,
        img_url: task.result.url.to_s,
        task: task.task.to_s,
        task_status: task.task_status.to_s,
        task_params: task.task_params.to_s,
    })
  end

  error Sinatra::Param::InvalidParameterError do
    status 422
    json({
        error: "#{env['sinatra.error'].param} is invalid"
    })
  end

  error Mongoid::Errors::DocumentNotFound do
    status 404
    json({
        error: "Task Not Found"
    })
  end
end