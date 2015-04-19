require 'rails_helper'

describe TasksController do

  let(:valid_user) { create(:valid_user_login) }
  let(:invalid_user) { create(:invalid_user_login) }
  let (:board) { create(:board_with_tasks) }

  before(:each) do
    board.reload
  end

  describe "POST #create" do
    context "with valid login" do
      context "with valid attributes" do
        it "creates a new task" do
          before_tasks_length = board.tasks.length
          post :create, {:board_id => board.id, :task => attributes_for(:task)}, {:user_id => valid_user.id}
          board.reload
          expect(board.tasks.length).to eq before_tasks_length + 1
        end
      end

      context "with invalid attributes" do
        it "does not create a new task" do
          before_tasks_length = board.tasks.length
          post :create, {:board_id => board.id, :task => attributes_for(:task, status: "ttt")}, {:user_id => valid_user.id}
          board.reload
          expect(board.tasks.length).to eq before_tasks_length
        end
      end
    end

    context "with invalid login" do
      it "redirects to signout path" do
        post :create, {:board_id => board.id, :task => attributes_for(:task)}, {:user_id => invalid_user.id}
        expect(response).to redirect_to(signout_path)
      end
    end
  end

  describe "DELETE #destroy" do
    context "valid login" do
        it "deletes the task" do
        before_tasks_length = board.tasks.length
        task = board.tasks.to_a.pop
        delete :destroy, {:board_id => board.id, :id => task}, {:user_id => valid_user.id}
        board.reload
        expect(board.tasks.length).to eq before_tasks_length - 1
      end
    end

    context "invalid login" do
      it "redirects to signout path" do
        task = board.tasks.to_a.pop
        delete :destroy, {:board_id => board.id, :id => task}, {:user_id => invalid_user.id}
        expect(response).to redirect_to(signout_path)
      end
    end
  end

  describe "GET #edit" do

    let (:task) { board.tasks.to_a.pop }

    context "valid login" do
      it "renders the 'views/tasks/edit.js.erb' template" do
        get :edit, {:board_id => board.id, :id => task}, {:user_id => valid_user.id}, format: :js
        expect(response).to render_template(:edit)
      end

      it "locates the proper task" do
        get :edit, {:board_id => board.id, :id => task}, {:user_id => valid_user.id}, format: :js
        expect(assigns(:task)).to eq task
      end

      it "locates the proper board" do
        get :edit, {:board_id => board.id, :id => task}, {:user_id => valid_user.id}, format: :js
        expect(assigns(:board)).to eq board
      end
    end

    context "invalid login" do
      it "redirects to signout path" do
        get :edit, {:board_id => board.id, :id => task}, {:user_id => invalid_user.id}, format: :js
        expect(response).to redirect_to(signout_path)
      end
    end
  end

  describe "PATCH #update" do

    let(:task) { board.tasks.to_a.pop }

    context "valid login" do
      context "valid attributes" do
        it "locates the proper task" do
          patch :update, {:board_id => board.id, :id => task, :task => task.attributes}, {:user_id => valid_user.id}
          expect(assigns(:task)).to eq task
        end

        it "changes the task's attributes" do
          patch :update, {:board_id => board.id, :id => task, :task => attributes_for(:task, status: "doing")}, {:user_id => valid_user.id}
          board.reload
          expect(board.tasks.to_a.pop.status).to eq "doing"
        end
      end

      context "invalid attributes" do
        it "does not change the tasks's attributes" do
          body = task.body
          patch :update, {:board_id => board.id, :id => task, :task => attributes_for(:task, body: nil)}, {:user_id => valid_user.id}
          board.reload
          expect(board.tasks.to_a.pop.body).to eq body
        end

        it "renders the edit templete" do
          patch :update, {:board_id => board.id, :id => task, :task => attributes_for(:task, body: nil)}, {:user_id => valid_user.id}
          board.reload
          expect(response).to render_template(:edit)
        end
      end
    end

    context "invalid login" do
      it "redirects to signout path" do
         patch :update, {:board_id => board.id, :id => task, :task => task.attributes}, {:user_id => invalid_user.id}
      end
    end
  end
end
