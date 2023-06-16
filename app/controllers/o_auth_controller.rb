require 'http'

class OAuthController < ApplicationController
  def index
    # TODO: Redirect the user to authorization page on Klaviyo.
  end

  def welcome
    # TODO: Implement
  end

  def authenticate_klaviyo
    params = {
      :client_id => ENV['OAUTH_CLIENT_ID'],
      :response_type => 'code',
      :redirect_uri => "https://localhost:3000/oauth/welcome",
      :scope => "campaigns:read", 
      :state => "", #TODO
      :code_challenge_method => "S256",
      :code_challenge => "WZRHGrsBESr8wYFZ9sx0tPURuZgG2lmzyvWpwXPKz8U", #PKCE code. Don't hardcoded like this like here.
    }
    
    recircet_to  "https://klaviyo.com/oauth/authorize?#{params.to_query}"
  end
end
