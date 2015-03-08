require 'rails_helper'

describe BoardsController do

  describe "GET #index" do

    it "responds successfully with an HTTP 200 status code" do
      get :index
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the 'views/boards/index' template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "loads all the boards" do
      board = create(:board)
      get :index
      expect(assigns(:boards)).to eq [board]
    end

  end

  describe "GET #new" do

    it "renders the 'views/boards/new' template" do
      get :new
      expect(response).to render_template(:new)
    end

  end


  describe "GET #show" do

    let(:board) { create(:board_with_tasks) }

    it "renders the 'board' template" do
      get :show, id: create(:board)
      expect(response).to render_template(:show)
    end

    it "retrieves the correct board" do
      #board = create(:board)
      get :show, id: board
      expect(assigns(:board)).to eq board
    end

    #it "retrieves the 'todo' tasks" do
    #  get :show, id: board
    #  todo = board.tasks.select {|task| task.status == 'todo'}
    #  expect(assigns(:todo)).to eq todo
    #end

    it "retrieves the 'doing' tasks" do
    end

    it "retrieves the 'done' tasks'" do
    end

  end

  describe "POST #create" do

    context "with valid attributes" do

      it "creates a new board" do
        expect{
          post :create, board: attributes_for(:board)
        }.to change(Board, :count).by(1)
      end

      it "redirects to show the new board" do
        post :create, board: attributes_for(:board)
        expect(response).to redirect_to Board.last
      end

    end

    context "with invalid attributes" do
      
      it "does not save a new board" do
        board_attributes = attributes_for(:board)
        board_attributes[:name] = nil
        expect{
          post :create, board: board_attributes
        }.to_not change(Board, :count)
      end

      it "re-renders the new method" do
        board_attributes = attributes_for(:board)
        board_attributes[:name] = nil
        post :create, board: board_attributes
        expect(response).to render_template(:new)
      end

    end

  end

  describe "DELETE #destroy" do

    let(:board) { create(:board) }

    it "removes the board from the database" do
      delete :destroy, id: board
      expect{
        get :show, id: board
      }.to raise_error ActiveRecord::RecordNotFound
    end
    
    it "redirects to boards#index" do
      delete :destroy, id: board
      expect(response).to redirect_to boards_url
    end

  end

  describe "PUT #update" do

    let(:board) { create(:board, name: "test") }

    context "valid attributes" do
      
      it "locates the requested board" do
        put :update, id: board, board: board.attributes
        expect(assigns(:board)).to eq board
      end

      it "changes the board's attributes" do
        put :update, id: board, board: attributes_for(:board, name: "test_changed")
        board.reload
        expect(board.name).to eq "test_changed"
      end

      it "redirects to the updated board" do
        put :update, id: board, board: attributes_for(:board)
        expect(response).to redirect_to board
      end

    end

    context "invalid attributes" do
      
      it "does not change the requested board" do
        before_name = board.name
        put :update, id: board, board: attributes_for(:board, name: nil)
        board.reload
        expect(board.name).to eq before_name
      end
     
      it "re-renders the update method" do
        put :update, id: board, board: attributes_for(:board, name: nil)
        expect(response).to render_template(:edit)
      end

    end

  end
  
end
