class BudaWorker < ApplicationJob
  queue_as :default

  def perform(service, method_name)
    service.send(method_name)
  end
end
