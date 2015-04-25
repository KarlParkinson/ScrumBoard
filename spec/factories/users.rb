FactoryGirl.define do

  factory :valid_user_login, class: User do
    provider "MyString"
    uid "MyString"
    name "MyString"
    oauth_token "MyString"
    oauth_expires_at (Time.now + 3600)
  end

  factory :invalid_user_login, class: User do
    provider "MyString"
    uid "MyString"
    name "MyString"
    oauth_token "MyString"
    oauth_expires_at (Time.now - 3600)
  end

  factory :wrong_user, class: User do
    provider "MyString"
    uid "SomethingDifferent"
    name "MyString"
    oauth_token "MyString"
    oauth_expires_at (Time.now + 3600)
  end
end
