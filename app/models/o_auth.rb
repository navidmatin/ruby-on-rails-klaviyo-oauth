class OAuth < ApplicationRecord
  encrypts :code_verifier
  encrypts :refresh_token
  encrypts :access_token

  scope :valid_token, -> { where.not(refresh_token: nil).where.not(access_token: nil).where("expires_at > ?", Time.now.utc) }
  scope :expired_token, -> { where.not(refresh_token: nil).where.not(access_token: nil).where("expires_at <= ?", Time.now.utc)}
end
