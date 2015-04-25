module FeatureSpecHelper
  
  def login_with_oauth(service = :google)
    visit '/auth/#{service}/callback'
  end

end
