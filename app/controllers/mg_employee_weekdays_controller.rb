class MgEmployeeWeekdaysController < ApplicationController
  layout "mindcom"
  before_action :login_required

  def new 
    @employee_weekdays = MgEmployeeWeekday.new
    render layout: false
  end

  def index
    @employee_weekdays = MgEmployeeWeekday.where(is_deleted: 0, mg_school_id: session[:current_user_school_id])
    @weekdaychecked = MgEmployeeWeekday.where(is_deleted: 0, mg_school_id: session[:current_user_school_id]).pluck(:weekday)
  end

  def create
    mg_school_id = session[:current_user_school_id]
    user_id = session[:user_id]

    puts params[:weekdays].inspect
    obj = MgEmployeeWeekday.where(is_deleted: 0, mg_school_id: mg_school_id)
    obj.update_all(is_deleted: 1) if obj.present?
    if params[:weekdays].present?
      params[:weekdays].each do |weekday|
        employee_weekday = MgEmployeeWeekday.find_or_initialize_by(mg_school_id: mg_school_id, weekday: weekday)
        employee_weekday.is_deleted = 0
        employee_weekday.updated_by = user_id
        employee_weekday.save
      end 
    end
    flash[:notice] = "Weekdays updated successfully"
    redirect_to action: "index"
  end

  def show
    @employee_weekdays = MgEmployeeWeekday.find(params[:id])
    render layout: false
  end

  def edit
    @employee_weekdays = MgEmployeeWeekday.find(params[:id])
    render layout: false
  end

  def update
    @employee_weekdays = MgEmployeeWeekday.find(params[:id])
    if @employee_weekdays.update(employee_weekdays_params)
      redirect_back(fallback_location: employee_weekdays_path)
    else
      render 'edit'
    end
  end

  def delete
    @notice = ''
    begin
      MgEmployeeWeekday.transaction do
        @employee_weekdays = MgEmployeeWeekday.find_by(id: params[:id])
        @employee_weekdays.update(is_deleted: 1)
        @employee_weekdays.mg_events.update_all(is_deleted: 1)
        events_id = @employee_weekdays.mg_events.pluck(:id)
        MgEvent.where(id: events_id).each do |delete|
          delete.mg_guests.update_all(is_deleted: 1)
          delete.mg_albums.update_all(is_deleted: 1)
        end
      end
      @notice = "Event type deleted successfully"
    rescue => e
      puts e
      @notice = "Event type deletion unsuccessful, please contact admin"
    end
    redirect_to event_types_path, notice: @notice
  end

  private

  def employee_weekdays_params
    params.require(:employee_weekdays).permit(:name, :event_color, :is_deleted, :mg_school_id, :created_by, :updated_by)
  end

end
