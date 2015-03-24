class TasksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    @board = Board.find(params[:board_id])
    @task = @board.tasks.create(task_params)
    
    respond_to do |format|
      if @task.save
        format.js {}
        format.html { redirect_to board_path(@board), notice: 'Task was saved.' }
      else
        format.html { redirect_to board_path(@board), notice: 'Task could not be saved.' }
      end
    end
  end

  def destroy
    @board = Board.find(params[:board_id])
    @task = @board.tasks.find(params[:id])
    @task.destroy
    redirect_to board_path(@board)
  end

  def edit
  end

  def sort
    params[:order].each do |_, task|
      Task.find(task[:id]).update_attribute(:priority, task[:position])
    end
    render :nothing => true
  end

  def update
    @board = Board.find(params[:board_id])
    @task = @board.tasks.find(params[:id])
    @task.update task_params
    @task.update task_params
    render :nothing => true
  end

  private

  def task_params
    params.require(:task).permit(:body, :status)
  end

end
