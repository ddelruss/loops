class LoopsController < ApplicationController
  def index
    @current_login = Login.new
  end
  def nodes
    # access with hash notation e.g. @current_login[:user]
    @current_login = params[:login]
  end
end
