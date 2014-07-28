require 'net/http'
require 'uri'
require 'json'

class IssueController < ApplicationController
  def slack
    return if params[:user_name]=='slackbot'
    text = params[:text][/[a-zA-Z]+\d+/]
    repo = Repo.where(short_name: text[/[a-zA-Z]+/]).first
    issue_number = text[/\d+/]

    token = User.first.token
    uri = URI.parse("https://api.github.com/repos/#{repo.owner}/#{repo.name}/issues/#{issue_number}?access_token=#{token}")
    http = Net::HTTP.new(uri.host, uri.port) 
    http.use_ssl = (uri.scheme == "https")
    http.start
    res = http.request(Net::HTTP::Get.new(uri.to_s))

    issue = JSON.parse(res.body)
    number = issue['number']
    title = issue['title']
    url = issue['html_url']

    respond_to do |format|
      msg = {text: url.empty? ? "" : "<#{url}|Issue ##{number} #{title}>"}
      format.json {render json: msg}
    end
  end
end