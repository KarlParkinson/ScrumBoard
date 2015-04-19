class TasksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    if valid_login?
      @board = Board.find(params[:board_id])
      new_task_pos = @board.tasks.select {|task| task.status == params[:task][:status]}.length + 1
      @task = @board.tasks.create(task_params)
      @task.priority = new_task_pos
    
      respond_to do |format|
        if @task.save
          format.js {}
          format.html { redirect_to board_path(@board), notice: 'Task was saved.' }
        else
          format.html { redirect_to board_path(@board), notice: 'Task could not be saved.' }
        end
      end
    else
      flash[:expired] = true
      redirect_to signout_path
    end
  end

  def destroy
    if valid_login?
      @board = Board.find(params[:board_id])
      @task = @board.tasks.find(params[:id])
      respond_to do |format|
        if @task.destroy
          format.js {}
          format.html { redirect_to board_path(@board), notice: 'Task was deleted.' }
        else
          format.html { redirect_to board_path(@board), notice: 'Task was  not deleted.' }
        end
      end
    else
      flash[:expired] = true
      redirect_to signout_path
    end
  end
 
  def edit
    if valid_login?
      @board = Board.find(params[:board_id])
      @task = @board.tasks.find(params[:id])
      respond_to do |format|
        format.js {}
        format.html {}
      end
    else
      flash[:expired] = true
      redirect_to signout_path
    end
  end

  def sort
    params[:order].each do |_, task|
      Task.find(task[:id]).update_attribute(:priority, task[:position])
    end
    render :nothing => true
  end

  def update
    if valid_login?
      @board = Board.find(params[:board_id])
      @task = @board.tasks.find(params[:id])
      respond_to do |format|
        if @task.update task_params
          format.js {}
          format.html { redirect_to board_path(@board) }
        else
          format.js { render :edit }
          format.html { render :edit }
       #   format.html { redirect_to board_path(@board), notice: 'Task was not updated.' }
        end
      end
    else
      flash[:expired] = true
      redirect_to signout_path
    end
  end
    
  private

  def task_params
    params.require(:task).permit(:body, :status)
  end

end
