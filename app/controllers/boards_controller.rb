class BoardsController < ApplicationController
  skip_before_action :verify_authenticity_token
  layout 'application'

  def index
    check_login
    if logged_in?
      if params[:search]
        @boards = Board.search(params[:search]).where("uid = ?", current_user.uid).order("created_at DESC")
      else
        @boards = Board.where("uid = ?", current_user.uid).order("created_at DESC")
      end
    else
      flash[:message] = "Please Login."
      redirect_to root_path
    end
  end

  def show
    check_login
    if logged_in?
      @board = Board.find(params[:id])
      @todo = @board.tasks.select {|task| task.status == 'todo'}
      @doing = @board.tasks.select {|task| task.status == 'doing'}
      @done = @board.tasks.select {|task| task.status == 'done'}
    else
      flash[:message] = "Please Login."
      redirect_to root_path
    end
  end

  def new
    respond_to do |format|
      format.js {}
      format.html {}
    end
  end

  def edit
    check_login
    @board = Board.find(params[:id])
    respond_to do |format|
      format.js {}
      format.html { redirect_to board_path(@board) }
    end
  end

  def create
    check_login
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
    check_login
    @board = Board.find(params[:id])
    respond_to do |format|
      if @board.update(board_params)
        format.js {}
        format.html { redirect_to board_path(@board) }
      else
        format.html { redirect_to board_path(@board), notice: "Board was not renamed." }
      end
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
