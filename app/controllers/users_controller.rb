class UsersController < ApplicationController
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      redirect_to repos_path, notice: "Token successfully updated"
    else
      render "repos/edit"
    end
  end
end
