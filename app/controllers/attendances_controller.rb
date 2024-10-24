class AttendancesController < ApplicationController
  before_action :login_required
  layout "mindcom"
  
  def get_start_date_end_date
    holiday = MgHoliday.find(params[:mg_holiday_id])
    @start_date = holiday.holiday_start_date.to_s.split('-')
    @end_date = holiday.holiday_end_date.to_s.split('-')
    render layout: false
  end

  def holiday_lists
    mg_school_id = session[:current_user_school_id]
    school = MgSchool.find(mg_school_id)
    @date_format = school.date_format
    if params[:mg_time_table_id].present?
      @mg_holiday = MgHoliday.where(is_deleted: 0, mg_school_id: mg_school_id, mg_time_table_id: params[:mg_time_table_id]).order(:holiday_start_date)
      @time_table_id = params[:mg_time_table_id]
      respond_to do |format|
        format.js
        format.html
      end
    end
  end

  def holiday_new
    if params[:time_table_id].present?
      academic_year = MgTimeTable.find_by(is_deleted: 0, mg_school_id: session[:current_user_school_id], id: params[:time_table_id])
      start_date = academic_year.start_date.strftime("%d/%m/%Y")
      end_date = academic_year.end_date.strftime("%d/%m/%Y")
      render json: { start_date: start_date, end_date: end_date }, layout: false
    end

    @applicable = MgEmployeeCategory.where(is_deleted: 0).pluck(:category_name, :id)
    @applicable.unshift(["All", "all"], ["Student", "student"])
  end

  def holiday_submit
    @mg_holiday = MgHoliday.new(holiday_params)
    time_format = MgSchool.find(session[:current_user_school_id]).date_format
    @mg_holiday.holiday_start_date = Date.strptime(params[:holiday][:holiday_start_date], time_format)
    @mg_holiday.holiday_end_date = Date.strptime(params[:holiday][:holiday_end_date], time_format)
    @mg_holiday.mg_time_table_id = params[:mg_time_table_id]
    applicable = params[:applicable_for]
    case applicable
    when "all"
      @mg_holiday.applicable_for = "All"
    when "student"
      @mg_holiday.is_for_student = true
      @mg_holiday.applicable_for = "Student"
    else
      @mg_holiday.is_for_employee = true
      @mg_holiday.mg_employee_category_id = applicable
      emp_category = MgEmployeeCategory.find(applicable)
      @mg_holiday.applicable_for = emp_category.category_name
    end

    if @mg_holiday.save
      flash[:notice] = "Holiday created successfully"
    else
      flash[:error] = "Date is overlapping"
    end
    redirect_to controller: 'attendances', action: 'holiday_lists'
  end

  def holiday_detail
    mg_school_id = session[:current_user_school_id]
    school = MgSchool.find(mg_school_id)
    @date_format = school.date_format
    @mg_holiday = MgHoliday.find(params[:id])
  end

  def holiday_edit
    mg_school_id = session[:current_user_school_id]
    school = MgSchool.find(mg_school_id)
    @date_format = school.date_format
    @mg_holiday = MgHoliday.find(params[:id])

    if @mg_holiday.mg_time_table_id.present?
      academic_year = MgTimeTable.find_by(is_deleted: 0, mg_school_id: mg_school_id, id: @mg_holiday.mg_time_table_id)
      @start_date = academic_year.start_date.strftime("%d/%m/%Y")
      @end_date = academic_year.end_date.strftime("%d/%m/%Y")
    end

    @applicable = MgEmployeeCategory.where(is_deleted: 0).pluck(:category_name, :id)
    @applicable.unshift(["All", "all"], ["Student", "student"])
  end

  def holiday_delete
    @mg_holiday = MgHoliday.find(params[:id])
    if MgDependancyClass.holiday_dependancy("mg_holiday_id", params[:id])
      flash[:error] = "Cannot delete, this wing has dependencies"
    else
      @mg_holiday.update(is_deleted: 1)
      flash[:notice] = "Deleted successfully"
    end

    redirect_to controller: 'attendances', action: 'holiday_lists'
  end

  def holiday_update
    @mg_holiday = MgHoliday.find(params[:holiday][:id])
    @mg_holiday.holiday_name = params[:holiday][:holiday_name]
    time_format = MgSchool.find(session[:current_user_school_id]).date_format
    @mg_holiday.holiday_start_date = Date.strptime(params[:holiday][:holiday_start_date], time_format)
    @mg_holiday.holiday_end_date = Date.strptime(params[:holiday][:holiday_end_date], time_format)
    @mg_holiday.description = params[:holiday][:description]
    applicable = params[:applicable_for]
    case applicable
    when "all"
      @mg_holiday.update(applicable_for: "All", is_for_student: nil, is_for_employee: nil, mg_employee_category_id: nil)
    when "student"
      @mg_holiday.update(applicable_for: "Student", is_for_student: true, is_for_employee: nil, mg_employee_category_id: nil)
    else
      emp_category = MgEmployeeCategory.find(applicable)
      @mg_holiday.update(applicable_for: emp_category.category_name, is_for_student: nil, is_for_employee: true, mg_employee_category_id: applicable)
    end

    if @mg_holiday.save
      flash[:notice] = "Holiday updated successfully"
    else
      flash[:error] = "Date is overlapping"
    end
    redirect_to controller: 'attendances', action: 'holiday_lists'
  end

  def holidays_pdf
    mg_school_id = session[:current_user_school_id]
    school = MgSchool.find(mg_school_id)
    holidays = MgHoliday.where(is_deleted: 0, mg_school_id: mg_school_id, mg_time_table_id: params[:mg_time_table_id]).order(:holiday_start_date)
    @@date_format = school.date_format
    pdf = Prawn::Document.new(page_layout: :landscape) do
      @@school_logo = school.logo.url(:medium, timestamp: false)
      repeat :all do
        # Header
        bounding_box([bounds.left, bounds.top], align: :right, width: bounds.width) do
          font "Helvetica"
          if File.exists?("#{Rails.root}/public/#{@@school_logo}")
            image("#{Rails.root}/public/#{@@school_logo}", width: 45)
          end
          move_up 15
          text school.school_name, align: :center, size: 18
          stroke_horizontal_rule
        end

        # Footer
        bounding_box([bounds.left, bounds.bottom + 5], width: bounds.width) do
          font "Helvetica"
          stroke_horizontal_rule
          move_down 10
          draw_text "Powered By - ©", at: [550, 3]
          image "#{Rails.root}/app/assets/images/mindcom-logo.png", at: [645, 15], width: 45, align: :right
        end
      end

      text "Holiday Lists", align: :center, size: 18
      move_down 15

      table([["Holiday Name", "Holiday Start Date", "Holiday End Date", "Applicable for"]], column_widths: [145], cell_style: { size: 12 }, position: :center)

      holidays.each do |holiday|
        table([[holiday.holiday_name, holiday.holiday_start_date.strftime(@@date_format), holiday.holiday_end_date.strftime(@@date_format), holiday.applicable_for]], column_widths: [145], cell_style: { size: 12 }, position: :center)
      end
    end

    send_data pdf.render, filename: "holidays.pdf", type: "application/pdf", disposition: "inline", info: { CreationDate: Time.now }
  end

  private

  def holiday_params
    params.require(:holiday).permit(:holiday_name, :holiday_start_date, :holiday_end_date, :description, :mg_time_table_id)
  end

end
