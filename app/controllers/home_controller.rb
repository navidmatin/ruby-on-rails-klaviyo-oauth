require 'http'

class HomeController < ApplicationController
  def index
  end

  # Sample api call to campaigns.
  def campaigns
    token = OAuth.valid_token.first
    http = HTTP.auth("Bearer #{token&.access_token}")
    headers = {
      Authorization: "Bearer #{token&.access_token}",
      Accept: 'application/json',
      revision: Date.current.strftime('%Y-%m-%d')
    }
    response = HTTP.headers(headers).get('https://a.klaviyo.com/api/campaigns/');
    if response.status.success?
      @campaigns = JSON.parse(response.body)
    else
      @campaigns = {response_status: response.status, response_body: response.body }.to_json
    end
    render json: @campaigns
  end
end
