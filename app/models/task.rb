class Task < ActiveRecord::Base
  belongs_to :board
  validates :body, presence: true
  validates :status, inclusion:  { in: %w(todo doing done) }
  default_scope {order("priority ASC")}
end
