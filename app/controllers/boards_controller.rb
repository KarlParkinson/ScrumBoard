class BoardsController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout 'application'

  def index
    if valid_login?
      if params[:search]
        @boards = Board.search(params[:search]).where("uid = ?", current_user.uid).order("created_at DESC")
      else
        @boards = Board.where("uid = ?", current_user.uid).order("created_at DESC")
      end
    else
      flash[:expired] = true
      redirect_to signout_path
    end
  end

  def show
    if valid_login?
      if owns_board(params[:id])
        @board = Board.find(params[:id])
        @todo = @board.tasks.select {|task| task.status == 'todo'}
        @doing = @board.tasks.select {|task| task.status == 'doing'}
        @done = @board.tasks.select {|task| task.status == 'done'}
      else
        redirect_to boards_path
      end
    else
      flash[:expired] = true
      redirect_to signout_path
    end
  end

  def new
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  def edit
    @board = Board.find(params[:id])
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  def create
    if valid_login?
      @board = Board.new(board_params)
      respond_to do |format|
        if @board.save
          format.js {}
          format.html { redirect_to @board }
        else
          format.js { render :new }
          format.html { render :new }
        end
      end
    else
      flash[:expired] = true
      redirect_to signout_path
    end
  end

  def destroy
    @board = Board.find(params[:id])
    @board.destroy
    redirect_to boards_path
  end

  def update
    if valid_login?
      @board = Board.find(params[:id])
      respond_to do |format|
        if @board.update(board_params)
          format.js {}
          format.html { redirect_to board_path(@board) }
        else
          format.js { render :edit }
          format.html { render :edit }
        end
      end
    end
  end

  private

  def board_params
    params.require(:board).permit(:name).merge({"uid" => current_user.uid})
  end

end
