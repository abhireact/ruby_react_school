class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def get_course
    user = MgUser.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>session[:user_id])
    courses = view_context.get_course_by_academic_year(params[:mg_time_table_id])
    courses_ids = []
    courses.each do |v, i| courses_ids << i end
 
      courses_batches = view_context.get_course_batch_by_courses(courses_ids)
    if user.present? && user.user_type == "employee"
      employee = MgEmployee.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id], :mg_user_id=>session[:user_id])
      courses = view_context.get_employee_courses(employee.id, params[:mg_time_table_id]) if employee.present?
    end
    employee_courses_batches = view_context.get_employee_courses_and_batches(courses_ids)
    render :json=> {courses: courses, courses_batches: courses_batches, employee_courses_batches:employee_courses_batches}, :layout => false
  end

  
  def get_wing_course
    courses = MgCourse.where(mg_wing_id:params[:mg_wing_id],mg_time_table_id:params[:mg_time_table_id],is_deleted:0,mg_school_id:session[:current_user_school_id]).pluck(:course_name,:id) if params[:mg_wing_id].present?
    render :json => {:courses => courses}
  end

  def login_required
    user = MgUser.find_by(id: session[:user_id], is_deleted: 0)
    # if session[:user_id].present? && MgUser.find_by(:id=>session[:user_id], :is_deleted=>0).try(:mg_school_id).to_s==session[:current_user_school_id].to_s
    if session[:user_id].present? && user&.mg_school_id.to_s == session[:current_user_school_id].to_s
      # Allow access
    else
      redirect_to root_url, alert: 'You need to log in to access this page.'
    end
  end

  
end
