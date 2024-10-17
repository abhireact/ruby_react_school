class DashboardController < ApplicationController
  layout "mindcom"
  def index
    @academic_years = MgTimeTable.where(mg_school_id:session[:current_user_school_id],is_deleted:0)
    @wings = MgWing.where(mg_school_id:session[:current_user_school_id],is_deleted:0)
    @courses = MgCourse.where(mg_time_table_id:@academic_years.map(&:id),mg_school_id:session[:current_user_school_id],is_deleted:0)
    @batches = MgBatch.where(mg_course_id:@courses.map(&:id),mg_school_id:session[:current_user_school_id],is_deleted:0)
    @redux_data={academic_years:@academic_years,wings:@wings,class:@courses,section:@batches}
  end
end
