class Task < ActiveRecord::Base

  validates :title, presence: true
  validates :state, inclusion: {in: ["todo", "doing", "done"]}

end
