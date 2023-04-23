# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def error_handler(error)
    redirect_to request.referrer, alert: error.message
  end
end
