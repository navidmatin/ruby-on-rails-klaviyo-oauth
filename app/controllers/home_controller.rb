require 'http'

class HomeController < ApplicationController
  def index
  end

  def campaigns
    response = HTTP.get('https://a.klaviyo.com/api/campaigns/');
    if response.status.success?
      @campaigns = JSON.parse(response.body)
    else
      @campaigns = {response_status: response.status}.to_json
    end
    render json: @campaigns
  end
end
