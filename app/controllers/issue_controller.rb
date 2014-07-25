require 'net/http'
require 'uri'
require 'json'

class IssueController < ApplicationController
  def index
    return if params[:user_name]=='slackbot'
    issue_number = params[:text][/\d+/]
    uri = URI.parse("https://api.github.com/repos/Scoutmob/scoutmob-shoppe/issues/#{issue_number}?access_token=07756a7beb8e570d32599bbe122abb1e490ea8f7")
    http = Net::HTTP.new(uri.host, uri.port) 
    http.use_ssl = (uri.scheme == "https")
    http.start 
    res = http.request(Net::HTTP::Get.new(uri.to_s))

    issue = JSON.parse(res.body)
    number = issue['number']
    title = issue['title']
    url = issue['html_url']

    respond_to do |format|
      msg = {text: "<#{url}|Issue ##{number} #{title}>", status: "ok", message: "success"}
      format.json {render json: msg}
    end
  end
end