# frozen_string_literal: true

module ControllerSpecHelper
  def body
    JSON.parse(response.body)
  end
end