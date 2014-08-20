require 'net/http'
require 'uri'

class ReposController < ApplicationController

  helper_method :repo

  def index
    if(session[:user_id])
      @repos = current_user.repos
      access_token = current_user.token
      uri = URI.parse("https://api.github.com/user/orgs?access_token=#{access_token}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")
      http.start
      res = http.request(Net::HTTP::Get.new(uri.to_s))
      @organizations = JSON.parse(res.body)
      @org_repos = Hash.new
      @organizations.each do |org|
        uri = URI.parse("https://api.github.com/orgs/#{org['login']}/repos?type=member&access_token=#{access_token}")
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme == "https")
        http.start
        res = http.request(Net::HTTP::Get.new(uri.to_s))
        @org_repos.merge!({org['login'] => JSON.parse(res.body)})
      end
      uri = URI.parse("https://api.github.com/user/repos?access_token=#{access_token}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")
      http.start
      res = http.request(Net::HTTP::Get.new(uri.to_s))
      @user_repos = JSON.parse(res.body)
    end
  end

  def new
    @repo = current_user.repos.new(params[:repo])
    respond_to do |format|
      format.js
      format.html
    end
  end

  def create
    @repo = current_user.repos.new(params[:repo])
    respond_to do |format|
      @result = @repo.save
      current_user.update_attributes(default_repo_id: @repo.id) if @result && current_user.repos.count <= 1
      @flash_message = {notice: "Repo successfully created"}
      format.js
      format.html
    end
  end

  def edit
    respond_to do |format|
      format.js
      format.html
    end
  end

  def update
    respond_to do |format|
      @result = repo.update_attributes(params[:repo])
      @flash_message = {notice: "Repo successfully updated"}
      format.js
      format.html
    end
  end

  def destroy
    repo.destroy
    current_user.update_attributes(default_repo_id: current_user.repos.first.try(:id)) if current_user.default_repo_id==repo.id
    current_user.update_attributes(default_repo_id: nil) if current_user.repos.count == 0
    redirect_to root_path
  end

  def make_default
    current_user.update_attributes(default_repo_id: params[:id])
    redirect_to root_path
  end

  def repo
    @repo ||= current_user.repos.find(params[:id])
  end
end