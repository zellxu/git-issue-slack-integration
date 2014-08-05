class UsersController < ApplicationController
  def update
    if current_user.update_attributes(params[:user])
      redirect_to repos_path, notice: "Token successfully updated"
    else
      render "repos"
    end
  end
end