module Admin
  class BaseController < ApplicationController
    before_action :authenticate_driver!
    before_action :authorize_admin!
  end
end
