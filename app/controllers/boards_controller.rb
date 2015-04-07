class BoardsController < ApplicationController
  layout 'application'

  def index
    if logged_in?
      if params[:search]
        @boards = Board.search(params[:search]).where("uid = ?", current_user.uid).order("created_at DESC")
      else
        @boards = Board.where("uid = ?", current_user.uid).order("created_at DESC")
      end
    else
      redirect_to root_path, :flash => { :error => "Please Log In" }
    end
  end

  def show
    if logged_in?
      @board = Board.find(params[:id])
      @todo = @board.tasks.select {|task| task.status == 'todo'}
      @doing = @board.tasks.select {|task| task.status == 'doing'}
      @done = @board.tasks.select {|task| task.status == 'done'}
    else
      redirect_to root_path, :flash => { :error => "Please Log In" }
    end
  end

  def new
  end

  def edit
    @board = Board.find(params[:id])
  end

  def create
    @board = Board.new(board_params)
    if @board.save
      redirect_to @board
    else
      render :new
    end
  end

  def destroy
    @board = Board.find(params[:id])
    @board.destroy
    redirect_to boards_path
  end

  def update
    @board = Board.find(params[:id])
    if @board.update(board_params)
      redirect_to @board
    else
      render :edit
    end
  end

  private

  def board_params
    params.require(:board).permit(:name).merge({"uid" => current_user.uid})
  end

  def logged_in?
    current_user
  end

end
