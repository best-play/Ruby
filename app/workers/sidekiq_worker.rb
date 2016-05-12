class SidekiqWorker
  include Sidekiq::Worker
  def perform(process_id)
    task = ImgProcess.find process_id
    image = MiniMagick::Image.open(task.image.current_path)

    if task.task == 'resize'
      @width = task.task_params['width'] ? task.task_params['width'].to_s : 500
      @height = task.task_params['height'] ? task.task_params['height'].to_s : 500

      task.result = image.resize (@width + 'x' + @height)
      task.task_status = 'done'
      task.save!

    elsif task.task == 'blur'
      @amount = task.task_params['amount'] ? task.task_params['amount'].to_s : 5

      task.result = image.radial_blur @amount
      task.task_status = 'done'
      task.save!
    end
  end
end