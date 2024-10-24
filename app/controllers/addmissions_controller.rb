class AddmissionsController < ApplicationController
    layout "mindcom"

  def index
        @admission = MgAdmissionSetting.where(is_deleted: 0, mg_school_id: session[:current_user_school_id])
        @xyz =  MgTimeTable.where(mg_school_id:session[:current_user_school_id],is_deleted:0)
        @admission_array = []
        @admission.each do |admission|
          # Only process if academic year exists
          if academic_year = MgTimeTable.find_by(id: admission.mg_time_table_id, is_deleted: false)
            admission_hash = {
              id: admission.id,
              mg_time_table_id: academic_year.name,
              start_date: admission.start_date,
              end_date: admission.end_date
            }
            @admission_array << admission_hash
          end
        end
      



        @data = {
          admission_array: @admission_array,
          academic_year: @xyz
        }
      end



      def create
        @admission = MgAdmissionSetting.new(mg_admission_settings_params)
        # @admission.mg_time_table_id = params[:mg_time_table_id]
        @admission.mg_school_id = session[:current_user_school_id] # Assuming this links it to the current school
        @admission.is_deleted= 0
        @admission.created_by = session[:user_id] # Assuming this links it to the current school
        @admission.updated_by = session[:user_id] # Assumin
        if @admission.save
          render json: @admission, status: :created
        else
          render json: { errors: @admission.errors.full_messages }, status: :unprocessable_entity
        end
      end
    
      def update
        @admission = MgAdmissionSetting.find(params[:id])
        @admission.mg_time_table_id = params[:mg_time_table_id]
        if @admission.update(mg_admission_settings_params)
          render json: @admission, status: :ok
        else
          render json: { errors: @admission.errors.full_messages }, status: :unprocessable_entity
        end
      end


  def delete
    @admission = MgAdmissionSetting.find(params[:id])
    admission_setting = MgAdmissionSettingDetail.where(mg_admission_setting_id: params[:id], is_deleted: false)
    if admission_setting.empty?
      @admission.update(is_deleted: true)
      # flash[:notice] = "Deleted Successfully"
      render json: { message: 'Academic year deleted successfully' }, status: :ok

    else
      render json: { errors: 'Academic year not found or already deleted' }, status: :not_found
    end
  end

  def admission_setting_detail
    @setting_detail = []
    @admission_details = MgAdmissionSettingDetail.new
    @admission = MgAdmissionSetting.find_by(is_deleted: false, mg_school_id: session[:current_user_school_id], id: params[:id])
    @setting_detail = MgAdmissionSettingDetail.where(is_deleted: false, mg_school_id: session[:current_user_school_id], mg_admission_setting_id: params[:id])
    @course_name = MgCourse.where(mg_time_table_id: @admission.mg_time_table_id, is_deleted: false, mg_school_id: session[:current_user_school_id]).pluck(:id, :course_name)
  end

  def admission_setting_detail_create
    @admission = MgAdmissionSetting.find_by(is_deleted: false, mg_school_id: session[:current_user_school_id], id: params[:mg_admission_setting_detail][:admission_setting_id])
    
    course_id = []
    maximum_form_per_day = []
    maximium_form_arr = []
    start_date_arr = []
    end_date_arr = []
    from_year_arr = []
    to_year_arr = []
    from_month_arr = []
    to_month_arr = []
    from_day_arr = []
    to_day_arr = []
    amount_arr = []
    status_arr = []
    
    if params[:course].present?
      courses = params[:course]
      courses.each do |course|
        course_id << course
        maximum_form_per_day << params["maximum_form_per_day-#{course}"]
        maximium_form_arr << params["maximum_form-#{course}"]
        start_date_arr << params["start_date-#{course}"]
        end_date_arr << params["end_date-#{course}"]
        from_year_arr << params["from_year-#{course}"]
        to_year_arr << params["to_year-#{course}"]
        from_month_arr << params["from_month-#{course}"]
        to_month_arr << params["to_month-#{course}"]
        from_day_arr << params["from_day-#{course}"]
        to_day_arr << params["to_day-#{course}"]
        amount_arr << params["amount-#{course}"]
        status_arr << params["status-#{course}"]
      end

      admission_details_arr = []
      (0...course_id.count).each do |i|
        admissionDetails = MgAdmissionSettingDetail.find_by(mg_admission_setting_id: @admission.id, mg_course_id: course_id[i], mg_school_id: session[:current_user_school_id], is_deleted: false)
        if admissionDetails.present?
          admissionDetails.update(
            maximum_form_per_day: maximum_form_per_day[i], 
            maximum_form: maximium_form_arr[i],
            start_date: start_date_arr[i], 
            end_date: end_date_arr[i], 
            from_year: from_year_arr[i], 
            to_year: to_year_arr[i], 
            from_month: from_month_arr[i], 
            to_month: to_month_arr[i], 
            from_day: from_day_arr[i], 
            to_day: to_day_arr[i], 
            status: status_arr[i],
            amount: amount_arr[i]
          )
        else
          @admission_details = MgAdmissionSettingDetail.new(
            mg_admission_setting_id: params[:mg_admission_setting_detail][:admission_setting_id],
            mg_course_id: course_id[i],
            is_deleted: false,
            mg_school_id: session[:current_user_school_id],
            created_by: session[:user_id],
            updated_by: session[:user_id],
            start_date: start_date_arr[i],
            end_date: end_date_arr[i],
            maximum_form_per_day: maximum_form_per_day[i],
            maximum_form: maximium_form_arr[i],
            from_year: from_year_arr[i],
            to_year: to_year_arr[i],
            from_month: from_month_arr[i],
            to_month: to_month_arr[i],
            from_day: from_day_arr[i],
            to_day: to_day_arr[i],
            amount: amount_arr[i],
            status: status_arr[i]
          )
          admission_details_arr << @admission_details
        end
      end
      MgAdmissionSettingDetail.import(admission_details_arr)
      flash[:notice] = "Admission details processed successfully"
      redirect_to mg_admission_settings_admission_setting_detail_path(id: params[:mg_admission_setting_detail][:admission_setting_id])
    else
      flash[:alert] = "Admission details not created successfully"
      redirect_to mg_admission_settings_admission_setting_detail_path(id: params[:mg_admission_setting_detail][:admission_setting_id])
    end
  end

      private
def mg_admission_settings_params
        params.require(:addmissions).permit(:start_date, :end_date, :mg_time_table_id, :mg_school_id, :updated_by, :created_by, :is_deleted)
 end    
end
