class ApplicationController < ActionController::API
  private

  def error?(obj)
    obj.is_a?(Hash) && obj.key?(:errors)
  end
end
