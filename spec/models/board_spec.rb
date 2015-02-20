require 'rails_helper'

describe Board do
  
  it "has a valid factory" do
    expect(create(:board)).to be_valid
  end

  it "is invalid without a name" do
    expect(build(:board, name: nil)).to_not be_valid
  end

  it "should destroy associated tasks" do
    board = create(:board_with_tasks)
    tasks = board.tasks
    board.destroy
    expect(tasks).to be_empty
  end
  
end
