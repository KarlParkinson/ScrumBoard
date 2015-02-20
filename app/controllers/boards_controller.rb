class BoardsController < ApplicationController

  def index
    @boards = Board.all
  end

  def show
    @board = Board.find(params[:id])
  end

  def new
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
      render :update
    end
  end

  private

  def board_params
    params.require(:board).permit(:name)
  end

end
