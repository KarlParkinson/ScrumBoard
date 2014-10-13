require 'test_helper'

class TaskTest < ActiveSupport::TestCase

  test "should not save task without a title" do
    task = Task.new
    assert_not task.save, "Saved a task without a title"
  end

  test "should not have a task state other than 'todo', 'doing', or 'done'" do
    task = Task.new(title: 'Test Task', description: 'A test task', state: 'finished')
    assert_not task.save, "Saved a task with an invalid state"
  end

  test "should be able to change task state" do
  end

  test "should be able to edit task title" do
  end

  test "should be able to edit task description" do
  end

  
  # test "the truth" do
  #   assert true
  # end
end
