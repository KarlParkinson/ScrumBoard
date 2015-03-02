require 'rails_helper'

describe TasksController do

  describe "POST #create" do
    
    context "with valid attributes" do
      
      let (:board) { create(:board) }

      it "creates a new task" do
        before_tasks_length = board.tasks.length
        post :create, board_id: board.id, task: attributes_for(:task)
        board.reload
        expect(board.tasks.length).to eq before_tasks_length + 1
      end
        
    end

    context "with invalid attributes" do

      let (:board) { create(:board) }

      it "does not create a new task" do
        before_tasks_length = board.tasks.length
        post :create, board_id: board.id, task: attributes_for(:task, status: "ttt")
        board.reload
        expect(board.tasks.length).to eq before_tasks_length
      end

    end

  end

  describe "DELETE #destroy" do
    
    let(:board) { create(:board) }

    before do
      create(:task, board: board)
      board.reload
    end

    it "deletes the task" do
      before_tasks_length = board.tasks.length
      task = board.tasks.to_a.pop
      delete :destroy, board_id: board.id, id: task
      board.reload
      expect(board.tasks.length).to eq before_tasks_length - 1
    end

  end

  describe "PUT #update" do
    
    context "valid attributes" do
      
      let(:board) { create(:board) }
      let(:task) { create(:task, board: board, status: "todo") }
      
      before do
        board.reload
      end

      it "locates the proper task" do
        put :update, board_id: board.id, id: task, task: task.attributes
        expect(assigns(:task)).to eq task
      end

      it "changes the task's attributes" do
        put :update, board_id: board.id, id: task, task: attributes_for(:task, status: "doing")
        board.reload
        expect(board.tasks.to_a.pop.status).to eq "doing"
      end

    end

  end

end
