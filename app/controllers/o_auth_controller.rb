require 'http'
require 'rack/oauth2'
require 'securerandom'

class OAuthController < ApplicationController
  def index
    # TODO: Redirect the user to authorization page on Klaviyo.
  end

  def redirect
    code = params[:code]
    state = params[:state]
    oauth = OAuth.findy_by(state: state)
    client = oauth_client()
    client.authorization_code = code
    response = client.access_token!
    oauth.access_token = response.token_response.access_token
    oauth.refresh_token = response.token_response.refresh_token
    oauth.expires_at = Time.now.utc + response.token_response.expires_in
    oauth.save!
    redirect_to '/'
  end

  def authenticate_klaviyo    
    redirect_to authorization_uri, allow_other_host: true
  end

  private

  def oauth_client
    client_id = ENV['OAUTH_CLIENT_ID']
    client_secret = ENV['OAUTH_CLIENT_SECRET']
    Rack::OAuth2::Client.new(
      identifier: client_id,
      secret: client_secret,
      redirect_uri: "https://localhost:3000/oauth/redirect",
      host: "klaviyo.com",
      authorization_endpoint: "/oauth/authorize",
      token_endpoint: "/oauth/token")
  end

  def authorization_uri    
    code_verifier = SecureRandom.hex(128)
    code_challenge = code_challenge(code_verifier)

    state = SecureRandom.hex(32)
    o_auth_model = OAuth.create(code_verifier: code_verifier, code_challenge: code_challenge, state: state)

    oauth_client.authorization_uri(
      scope: "campaigns:read",
      state: state,
      code_challenge: ,
      code_challenge_method: :S256)
  end

  def code_challenge(code_verifier)
    Base64.urlsafe_encode64(
      OpenSSL::Digest::SHA256.digest(code_verifier)
    ).gsub(/=/, '')
  end
end
