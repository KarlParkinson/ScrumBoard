require 'faker'

FactoryGirl.define do
  factory :board do
    name { Faker::App.name }

    factory :board_with_tasks do

      transient do
        tasks_count 6
      end

      after(:create) do |board, evaluator|
        create_list(:task, evaluator.tasks_count, board: board)
      end
    end
  end
end
