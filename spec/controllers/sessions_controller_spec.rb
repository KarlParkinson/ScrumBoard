require 'rails_helper'

describe SessionsController do

  before do
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
  end

  describe "POST #create" do

    it "should create a user" do
      expect {
        post :create, provider: :google_oauth2
      }.to change(User, :count).by(1)
    end

    it "should create the session" do
      expect(session[:user_id]).to be_nil
      post :create, provider: :google_oauth2
      expect(session[:user_id]).to_not be_nil
    end

    it "redirects to boards path" do
      post :create, provider: :google_oauth2
      expect(response).to redirect_to(boards_path)
    end
  end

  describe "GET #destroy" do

    let(:valid_user) { create(:valid_user_login) }

    it "sets session[:user_id] to nil" do
      get :destroy, {}, {:user_id => valid_user.id}
      expect(session[:user_id]).to be_nil
    end

    it "redirects to root" do
      get :destroy
      expect(response).to redirect_to(root_path)
    end
  end

end
