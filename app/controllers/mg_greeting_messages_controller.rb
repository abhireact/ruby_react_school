class MgGreetingMessagesController < ApplicationController
  before_action :get_greeting_object, only: [:edit, :update, :destroy]
  before_action :login_required
  layout "mindcom"

  def index
    @greetings = MgGreetingMessage.where(mg_school_id: session[:current_user_school_id], is_deleted: false)
  end

  def new
    @greeting = MgGreetingMessage.new
  end

  def create
    @greeting = MgGreetingMessage.new(greeting_params)
    @greeting.created_by = greeting_params[:updated_by]
    @greeting.updated_by = greeting_params[:updated_by]
    @greeting.start_time = parse_datetime(greeting_params[:start_time])
    @greeting.end_time = parse_datetime(greeting_params[:end_time])
    if @greeting.save
      flash[:notice] = "Created successfully"
      redirect_to mg_greeting_messages_path
    else
      render 'new'
    end
  end

  # def edit
  # end

  def update
    if @greeting.update(start_time: parse_datetime(greeting_params[:start_time]),end_time: parse_datetime(greeting_params[:end_time]),message: greeting_params[:message],updated_by: greeting_params[:updated_by])
      flash[:notice] = "Updated successfully"
      redirect_to mg_greeting_messages_path
    else
      flash[:alert] = "Something went wrong!!"
      redirect_to mg_greeting_messages_path
    end
  end

  def destroy
    @greeting.destroy
    flash[:alert] = "Deleted successfully"
    redirect_to mg_greeting_messages_path
  end

  private

  def greeting_params
    params.require(:mg_greeting_message).permit(:start_time, :end_time, :message, :is_deleted, :mg_school_id, :updated_by, :created_by)
  end

  def get_greeting_object
    @greeting = MgGreetingMessage.find_by(id: params[:id], is_deleted: false)

    unless @greeting
      flash[:alert] = "Record not found!"
      redirect_to mg_greeting_messages_path
    end
  end

  def parse_datetime(datetime_str)
    DateTime.parse(datetime_str) rescue nil
  end

end
