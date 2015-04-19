require 'rails_helper'

describe BoardsController do

  let(:valid_user) { create(:valid_user_login) }
  let(:invalid_user) { create(:invalid_user_login) }

  describe "GET #index" do
    context "with valid login" do
      it "responds successfully with an HTTP 200 status code" do
        get :index, {}, {:user_id => valid_user.id}
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "renders the 'views/boards/index' template" do
        get :index, {}, {:user_id => valid_user.id}
        expect(response).to render_template(:index)
      end

      it "loads all the boards with no search param" do
        board = create(:board)
        get :index, {}, {:user_id => valid_user.id}
        expect(assigns(:boards)).to eq [board]
      end

      it "loads all the boards with a search param" do
        board = create(:board)
        get :index, {:search => board.name}, {:user_id => valid_user.id}
        expect(assigns(:boards)).to eq [board]
      end
    end
    
    context "with invalid login" do
      it "redirects back to signout path" do
        get :index, {}, {:user_id => invalid_user.id}
        expect(response).to redirect_to(signout_path)
      end
    end
  end

  describe "GET #new" do
    it "renders the 'views/boards/new.js.erb' template" do
      get :new, format: :js
      expect(response).to render_template(:new)
    end

    it "renders the 'views/boards/new.html.erb' template" do
      get :new, format: :html
      expect(response).to render_template(:new)
    end
  end

  describe "GET #show" do
    context "valid user login" do
      
      let(:board) { create(:board_with_tasks) }

      it "renders the 'board' template" do
        get :show, {:id => board}, {:user_id => valid_user.id}
        expect(response).to render_template(:show)
      end

      it "retrieves the correct board" do
        get :show, {:id => board}, {:user_id => valid_user.id}
        expect(assigns(:board)).to eq board
      end

      it "retrieves the 'todo' tasks" do
        board.reload
        get :show, {:id => board}, {:user_id => valid_user.id}
        todo = board.tasks.select {|task| task.status == 'todo'}
        expect(assigns(:todo)).to eq todo
      end

      it "retrieves the 'doing' tasks" do
        board.reload
        get :show, {:id => board}, {:user_id => valid_user.id}
        doing = board.tasks.select {|task| task.status == 'doing'}
        expect(assigns(:doing)).to eq doing
      end

      it "retrieves the 'done' tasks'" do
        board.reload
        get :show, {:id => board}, {:user_id => valid_user.id}
        done = board.tasks.select {|task| task.status == 'done'}
        expect(assigns(:done)).to eq done
      end
    end

    context "invalid user login" do
      it "redirects back to signout path" do
        get :show, {:id => ""}, {:user_id => invalid_user.id}
        expect(response).to redirect_to(signout_path)
      end
    end
  end

  describe "POST #create" do
    context "valid login" do
      context "with valid attributes" do
        it "creates a new board" do
          expect{
            post :create, {:board => attributes_for(:board)}, {:user_id => valid_user.id}
          }.to change(Board, :count).by(1)
        end

        it "redirects to show the new board" do
          post :create, {:board => attributes_for(:board)}, {:user_id => valid_user.id}
          expect(response).to redirect_to Board.last
        end
      end

      context "with invalid attributes" do
        it "does not save a new board" do
          board_attributes = attributes_for(:board)
          board_attributes[:name] = nil
          expect{
            post :create, {:board => board_attributes}, {:user_id => valid_user.id}
          }.to_not change(Board, :count)
        end

        it "re-renders the new method" do
          board_attributes = attributes_for(:board)
          board_attributes[:name] = nil
          post :create, {:board => board_attributes}, {:user_id => valid_user.id}
          expect(response).to render_template(:new)
        end
      end
    end

    context "invalid login" do
      it "redirects back to signout path" do
        post :create, {:board => ""}, {:user_id => invalid_user.id}
        expect(response).to redirect_to(signout_path)
      end
    end
  end

  describe "DELETE #destroy" do

    let(:board) { create(:board) }

    it "removes the board from the database" do
      delete :destroy, {:id => board}, {:user_id => valid_user.id}
      expect{
        get :show, {:id => board}, {:user_id => valid_user.id}
      }.to raise_error ActiveRecord::RecordNotFound
    end
    
    it "redirects to boards#index" do
      delete :destroy, {:id => board}, {:user_id => valid_user.id}
      expect(response).to redirect_to boards_url
    end
  end

  describe "PATCH #update" do
    context "valid login" do

      let(:board) { create(:board, name: "test") }

      context "valid attributes" do
        it "locates the requested board" do
          patch :update, {:id => board, :board => board.attributes}, {:user_id => valid_user.id}
          expect(assigns(:board)).to eq board
        end

        it "changes the board's attributes" do
          patch :update, {:id => board, :board => attributes_for(:board, name: "test_changed")}, {:user_id => valid_user.id}
          board.reload
          expect(board.name).to eq "test_changed"
        end

        it "redirects to the updated board" do
          patch :update, {:id => board, :board => attributes_for(:board)}, {:user_id => valid_user.id}
          expect(response).to redirect_to board
        end
      end

      context "invalid attributes" do
        it "does not change the requested board" do
          before_name = board.name
          patch :update, {:id => board, :board => attributes_for(:board, name: nil)}, {:user_id => valid_user.id}
          board.reload
          expect(board.name).to eq before_name
        end
        
        it "re-renders the edit method" do
          patch :update, {:id => board, :board => attributes_for(:board, name: nil)}, {:user_id => valid_user.id}
          expect(response).to render_template(:edit)
        end
      end
    end
  end
end
