class ImgProcess
  include Mongoid::Document

  field :img_url, type: String
  field :task, type: String
  field :task_params, type: Hash
  field :task_status, type: String
end