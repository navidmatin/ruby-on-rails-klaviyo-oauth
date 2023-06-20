class OAuth < ApplicationRecord
  encrypts :code_verifier
  encrypts :refresh_token
  encrypts :access_token
end
