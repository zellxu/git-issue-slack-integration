class ReposController < ApplicationController
  def index
    @repos = current_user.repos if session[:user_id]
  end

  def new
    @repo = current_user.repos.new
  end

  def create
    @repo = current_user.repos.new(params[:repo])
    if @repo.save
      #question
      current_user.update_attributes(default_repo_id: @repo.id) if current_user.repos.count <= 1
      redirect_to repos_path, notice: "Repo successfully created"
    else
      render "new"
    end
  end

  def edit
    @repo = Repo.find(params[:id])
  end

  def update
    @repo = Repo.find(params[:id])
    if @repo.update_attributes(params[:repo])
      redirect_to repos_path, notice: "Repo successfully updated"
    else
      render "edit"
    end
  end

  def destroy
    @repo = Repo.find(params[:id])
    @repo.destroy
    redirect_to repos_path
  end

  def make_default
    current_user.update_attributes(default_repo_id: params[:id])
    redirect_to repos_path
  end

end