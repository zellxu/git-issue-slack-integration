require 'net/http'
require 'uri'
require 'json'

class IssueController < ApplicationController
  def slack
    return if params[:user_name]=='slackbot'
    text = params[:text][/[a-zA-Z]*\d+/]
    short_name = text[/[a-zA-Z]+/]
    issue_number = text[/\d+/]

    user = User.find_by_integration_token(params[:token])
    repo = short_name.nil? ? Repo.find(user.default_repo_id) : Repo.find_by_short_name(short_name)
    access_token = user.token
    uri = URI.parse("https://api.github.com/repos/#{repo.owner}/#{repo.name}/issues/#{issue_number}?access_token=#{access_token}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == "https")
    http.start
    res = http.request(Net::HTTP::Get.new(uri.to_s))

    issue = JSON.parse(res.body)
    number = issue['number']
    title = issue['title']
    url = issue['html_url']

    respond_to do |format|
      msg = {text: url.empty? ? "" : "#{repo.owner} / #{repo.name} \n <#{url}|Issue ##{number} #{title}>"}
      format.json {render json: msg}
    end
  end
end