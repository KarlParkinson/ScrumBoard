class Board < ActiveRecord::Base
  has_many :tasks, dependent: :destroy
  validates :name, presence: true
  validates_associated :tasks
end
