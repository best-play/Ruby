class ImgProcess
  include Mongoid::Document

  field :task, type: String
  field :task_params, type: Hash
  field :task_status, type: String

  mount_uploader :image, ImageUploader
  mount_uploader :result, ImageUploader
end
