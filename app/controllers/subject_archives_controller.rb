
  class SubjectArchivesController < ApplicationController
    helper_method :get_course_batch_name
      layout "mindcom"
      def subject_archive
        @classSection = view_context.get_course_batch_name
        @classSection.insert(0, ["All", "all"])
    end
  
    def create
        subjectID = params[:selectedemployees]
        subjectID.each do |eid|
            @subject = MgSubject.find(eid.to_i)
            if @subject.is_archive != 1
                @subject.update(:is_archive => 1)
            end
        end
        flash[:notice] = "Subject Archived Successfully"
        redirect_to :action => "archived_subject_list"
    end
  
    def index
        current_academic_year = MgTimeTable.where("start_date < \"#{Date.today}\" && \"#{Date.today}\" < end_date").where(:is_deleted => 0, :mg_school_id => session[:current_user_school_id]).pluck(:id)
        @current_academic_year_id = current_academic_year
        @current_academic_year_id = params[:mg_time_table_id] if params[:mg_time_table_id]
        courses = MgCourse.where(:is_deleted => 0, :mg_school_id => session[:current_user_school_id], :mg_time_table_id => @current_academic_year_id).pluck(:id)
        @subjects = MgSubject.includes(:mg_course).where(:is_archive => 1, :mg_course_id => courses, :is_deleted => 0, :mg_school_id => session[:current_user_school_id])
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
        @sub.update(:is_archive => 0)
        flash[:notice] = "Subject is Unarchived Successfully"
        redirect_to :action => "archived_subject_list"
    end
  
    def get_subject
        ids = params[:department_id]
        @subject = []
        if ids != 'all'
            @subIDs = MgBatchSubject.where(:is_deleted => 0, :mg_batch_id => params[:department_id]).pluck(:mg_subject_id)
            if @subIDs.present?
                @subIDs.each do |subID|
                    subject = MgSubject.where(:is_archive => 0, :id => subID).pluck(:subject_code, :id)
                    @subject.push(subject)
                end
            end
        else
            subject = MgSubject.where(:is_archive => 0, :is_deleted => 0, :mg_school_id => session[:current_user_school_id]).pluck(:subject_code, :id)
            subject.each do |sub|
                @subject.push([[sub[0], sub[1]]])
            end
        end
        respond_to do |format|
            format.json { render json: @subject }
        end
    end
  
    def new
        @subjects = MgSubject.new
    end
  
    def index_old_delete
      # for dependency Added By Deepak Starts
      if session[:table_array].present?
          @table_array = session[:table_array]
          @id = session[:table_array_id]
          session[:table_array_id] = nil
          session[:table_array] = nil
      end
      # for dependency Added By Deepak Ends
      @subjects = MgSubject.where(:is_deleted => 0, :mg_school_id => session[:current_user_school_id])
      .order('mg_course_id')
      .search(params[:search])
      .order(sort_column + " " + sort_direction)
      .paginate(page: params[:page], per_page: 10)
    end
  
      def index
          current_academic_year = MgTimeTable.where("start_date < \"#{Date.today}\" && \"#{Date.today}\" < end_date")
          .where(:is_deleted => 0, :mg_school_id => session[:current_user_school_id])
          .pluck(:id)
  
          @current_academic_year_id = current_academic_year[0]
          @current_academic_year_id = params[:mg_time_table_id] if params[:mg_time_table_id]
          courses = MgCourse.where(:is_deleted => 0, :mg_school_id => session[:current_user_school_id], :mg_time_table_id => @current_academic_year_id).pluck(:id)
          if session[:table_array].present?
              @table_array = session[:table_array]
              @id = session[:table_array_id]
              session[:table_array_id] = nil
              session[:table_array] = nil
          end
          @subjects = MgSubject.includes(:mg_course).where(:mg_course_id => courses, :is_deleted => 0, :mg_school_id => session[:current_user_school_id], is_archive: 0).order('mg_course_id').search(params[:search])
          respond_to do |format|
              format.js
              format.html
          end
      end

      
  
      def batch_subject_asso
          current_academic_year = view_context.get_current_academic_year(session[:current_user_school_id])
          @current_academic_year_id = current_academic_year
          @current_academic_year_id = params[:mg_time_table_id] if params[:mg_time_table_id]
          courses = MgCourse.where(:mg_time_table_id => @current_academic_year_id, :is_deleted => 0, :mg_school_id => session[:current_user_school_id]).pluck(:id)
          @batches = MgBatch.where(:is_deleted => 0, :mg_school_id => session[:current_user_school_id], :mg_course_id => courses).paginate(page: params[:page], per_page: 10)
      end
  
    private
  
    def get_course_batch_name
        MgCourse.where(is_deleted: 0, mg_school_id: session[:current_user_school_id]).pluck(:name, :id)
      end
  end