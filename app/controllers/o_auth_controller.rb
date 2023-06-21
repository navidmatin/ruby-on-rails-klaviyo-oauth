require 'http'
require 'rack/oauth2'
require 'securerandom'

class OAuthController < ApplicationController
  def redirect
    code = params[:code]
    state = params[:state]
    oauth = OAuth.find_by(state: state)
    response = access_token(code_verifier: oauth.code_verifier, code: code)
    handle_access_token_response(oauth, response)
    redirect_to '/'
  end

  def authenticate_klaviyo
    last_token = OAuth.expired_token.order(expires_at: :desc).first
    # If we have an expired token we can just use the refresh token to refresh it.
    if last_token
      response = access_token(code_verifier: last_token.code_verifier, refresh_token: last_token.refresh_token)
      if response
        handle_access_token_response(last_token, response)
        return redirect_to '/'
      end
    end
    # else we should go through the whole authorization process
    return redirect_to authorization_uri, allow_other_host: true
  end

  private

  def handle_access_token_response(oauth_data, response)
    oauth_data.access_token = response.token_response[:access_token]
    oauth_data.refresh_token = response.token_response[:refresh_token]
    oauth_data.expires_at = Time.now.utc + response.token_response[:expires_in]
    oauth_data.save!
  end

  def access_token(code_verifier:, code: nil, refresh_token: nil)
    client = oauth_client()
    if code
      client.authorization_code = code
    elsif refresh_token
       client.refresh_token = refresh_token
    end
    client.access_token!() do |request|
      # oauth2 library sets authorization, grant_type, and code
      request.headers["Content-Type"] = "application/x-www-form-urlencoded"
      request.body[:code_verifier] = code_verifier
      p request
    end
  end

  def oauth_client
    client_id = ENV['OAUTH_CLIENT_ID']
    client_secret = ENV['OAUTH_CLIENT_SECRET']
    Rack::OAuth2::Client.new(
      identifier: client_id,
      secret: client_secret,
      redirect_uri: "https://localhost:3000/oauth/redirect",
      host: "www.klaviyo.com",
      authorization_endpoint: "/oauth/authorize",
      token_endpoint: "/oauth/token")
  end

  def authorization_uri
    code_verifier = SecureRandom.alphanumeric(128)
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
      OpenSSL::Digest::SHA256.digest(code_verifier),
      padding: false
    )
  end
end
