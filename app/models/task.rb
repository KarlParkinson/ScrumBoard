class Task < ActiveRecord::Base
  belongs_to :board
  validates :body, presence: true
  validates :status, inclusion:  { in: %w(todo doing done) }
end
