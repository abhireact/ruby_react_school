
  class SubjectArchivesController < ApplicationController
    helper_method :get_course_batch_name
      layout "mindcom"
    
    def index
        begin
            @classSection = get_course_batch_name
            @classSection.insert(0, ["All", "all"])
          rescue ActiveRecord::StatementInvalid => e
            flash[:error] = "Database error: Please check if the required columns exist"
            @classSection = []
          end
    end
  
    def subject_archive
      @classSection = get_course_batch_name
      @classSection.insert(0, ["All", "all"])
    end
  
    def create
      subjectID = params[:selectedemployees]
      subjectID.each do |eid|
        @subject = MgSubject.find(eid.to_i)
        if @subject.is_archive != 1
          @subject.update(is_archive: 1)
        end
      end
      flash[:notice] = "Subject Archived Successfully"
      redirect_to action: "archived_subject_list"
    end
  
    def archived_subject_list
      current_academic_year = MgTimeTable
        .where("start_date < ? AND ? < end_date", Date.today, Date.today)
        .where(is_deleted: 0, mg_school_id: session[:current_user_school_id])
        .pluck(:id)
      
      @current_academic_year_id = params[:mg_time_table_id] || current_academic_year
      
      courses = MgCourse
        .where(is_deleted: 0, 
               mg_school_id: session[:current_user_school_id], 
               mg_time_table_id: @current_academic_year_id)
        .pluck(:id)
      
      @subjects = MgSubject
        .includes(:mg_course)
        .where(is_archive: 1, 
               mg_course_id: courses, 
               is_deleted: 0, 
               mg_school_id: session[:current_user_school_id])
        .order('mg_course_id')
        .search(params[:search])
        .order(sort_column + " " + sort_direction)
        .paginate(page: params[:page], per_page: 10)
      
      respond_to do |format|
        format.js
        format.html
      end
    end
  
    def subject_unarchive
      subID = params[:id]
      @sub = MgSubject.find(subID)
      @sub.update(is_archive: 0)
      flash[:notice] = "Subject is Unarchived Successfully"
      redirect_to action: "archived_subject_list"
    end
  
    private
  
    def get_course_batch_name
        # Let's verify what columns are available first
        MgCourse
          .where(is_deleted: 0, mg_school_id: session[:current_user_school_id])
          .pluck(:name, :id)  # Make sure 'name' column exists in mg_courses table
      end
  end