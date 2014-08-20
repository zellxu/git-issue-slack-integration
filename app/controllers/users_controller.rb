class UsersController < ApplicationController

  def update
    respond_to do |format|
      result = current_user.update_attributes(params[:user])
      @flash_message = result ? {notice: "Token successfully updated"} : {alert: "Token has been used by another user"}
      format.js
      format.html
    end
  end

end