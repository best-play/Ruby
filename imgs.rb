require 'sinatra/base'
require 'sinatra/param'
require 'sinatra/json'
require 'sinatra-initializers'
require 'dotenv'
require 'mongoid'
require './models/img_process'

Dotenv.load

class Img_process < Sinatra::Application
  register Sinatra::Initializers
  configure do
    set :raise_sinatra_param_exceptions, true
    set show_exceptions: false
  end

  post '/process' do
    param :img_url, String, required: true
    param :task, String, in: ['save'], required: true
    param :task_params, Hash, required: true

    process = ImgProcess.create! params

    json({
             id: process.id.to_s
         })
  end

  get '/get_task' do
    param :id, String, required: true

    id = params['id']
    task = ImgProcess.find id

    json({
             id: task.id.to_s,
             img_url: task.img_url.to_s,
             task: task.task.to_s,
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