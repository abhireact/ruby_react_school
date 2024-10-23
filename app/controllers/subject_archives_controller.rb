
  class SubjectArchivesController < ApplicationController
    helper_method :get_course_batch_name
      layout "mindcom"
      def subject_archive
        @classSection = view_context.get_course_batch_name
        @classSection.insert(0, ["All", "all"])
    end

    def archived_subject_list
      current_academic_year = MgTimeTable
        .where("start_date < ?", Date.today)
        .where("? < end_date", Date.today)
        .where(is_deleted: 0, mg_school_id: session[:current_user_school_id])
        .pluck(:id)
    
      @current_academic_year_id = params[:mg_time_table_id] || current_academic_year
      courses = MgCourse
        .where(is_deleted: 0, mg_school_id: session[:current_user_school_id], mg_time_table_id: @current_academic_year_id)
        .pluck(:id)
    
      # Whitelisting sort column and direction to avoid invalid SQL or injection issues
      sort_column = params[:sort_column].presence_in(['mg_course_id', 'subject_code', 'name']) || 'mg_course_id'
      sort_direction = %w[asc desc].include?(params[:sort_direction]) ? params[:sort_direction] : 'asc'
    
      @subjects = MgSubject
        .includes(:mg_course)
        .where(is_archive: 1, mg_course_id: courses, is_deleted: 0, mg_school_id: session[:current_user_school_id])
        .search(params[:search])
        .order("#{sort_column} #{sort_direction}")
    
      respond_to do |format|
        format.js
        format.html
        format.json { render json: @subjects }
      end
    end
    
    def subject_unarchive
      subID = params[:id]
      @sub = MgSubject.find(subID)
      
      if @sub.update(is_archive: 0)
        flash[:notice] = "Subject is Unarchived Successfully"
      else
        flash[:alert] = "Failed to unarchive subject."
      end
    
      redirect_to action: "archived_subject_list"
    end
    

 
    def subject_archive_create
        
        subjectID = params[:selectedemployees]
        subjectID.each do |eid|
          @subject = MgSubject.find_by(id: eid.to_i)
          if @subject
            # binding.pry
            if @subject.is_archive != 1
              @subject.update(is_archive: 1)
            end
          else
            flash[:alert] = "Subject with ID #{eid} not found"
            # redirect_to action: "archived_subject_list" and return
          end
        end
        flash[:notice] = "Subject Archived Successfully"
        # render json: { error: "API request parameter missing" }, status: :bad_request
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
        if params[:api_request].present?
            render json: @subject, status: :created
          else
            render json: { error: "API request parameter missing" }, status: :bad_request
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