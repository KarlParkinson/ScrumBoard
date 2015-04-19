require 'rails_helper'

describe User do
  
  describe "from_omniauth" do

    let(:auth) { OmniAuth.config.mock_auth[:google_oauth2] }

    it "creates a user" do
      expect {
        User.from_omniauth(auth)
      }.to change(User, :count).by(1)
    end

    it "creates a user with correct attributes" do
      user = User.from_omniauth(auth)
      expect(user.provider).to eq auth.provider
      expect(user.uid).to eq auth.uid
      expect(user.name).to eq auth.info.name
      expect(user.oauth_token).to eq auth.credentials.token
      expect(user.oauth_expires_at).to eq auth.credentials.expires_at
    end
  end
end
