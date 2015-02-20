require 'faker'

FactoryGirl.define do
  factory :task do
    body { Faker::Lorem.sentence }
    status { ["todo", "doing", "done"].sample }
    board
  end
end
