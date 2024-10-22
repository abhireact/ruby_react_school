class SubjectsController < ApplicationController
    layout "mindcom"
    
    # List of permitted columns for sorting
    SORTABLE_COLUMNS = %w[mg_course_id name]  # Add other columns that should be sortable

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
	    @subjects = MgSubject.includes(:mg_course).where(:mg_course_id => courses, :is_deleted => 0, :mg_school_id => session[:current_user_school_id], is_archive: 0).order('mg_course_id').search(params[:search]).order(sort_column + " " + sort_direction)
	    respond_to do |format|
            format.html # renders the default index.html.erb
            format.json do
              if params[:api_request].present?
                render json: @subjects, status: :created
              else
                render json: { error: "API request parameter missing" }, status: :bad_request
              end
            end
          end
    end

    def create
        MgSubject.transaction do
            @subjects = MgSubject.new(subject_params)
            @subjects.mg_school_id = session[:current_user_school_id]
            @subjects.is_deleted = 0
            @subjects.created_by = session[:user_id]
            @subjects.updated_by = session[:user_id]
            @subjects.is_archive = 0  # Set the default values as needed
    
            if @subjects.save
                # Once the subject is saved, create associated batch subjects
                batches = MgBatch.where(is_deleted: 0, mg_school_id: session[:current_user_school_id], mg_course_id: @subjects.mg_course_id)
                
                batches.each do |batch|
                    MgBatchSubject.create(
                        mg_batch_id: batch.id,
                        mg_subject_id: @subjects.id,
                        is_extra_curricular: @subjects.is_extra_curricular ? 1 : 0,
                        is_deleted: 0,
                        mg_school_id: session[:current_user_school_id]
                    )
                end
    
                render json: { message: "Subject created successfully" }, status: :created
            else
                # Check the validation errors if subject creation fails
                render json: { message: "Subject creation failed", errors: @subjects.errors.full_messages }, status: :unprocessable_entity
            end
        end
    end
    
    

    def update
        MgSubject.transaction do
            @subjects = MgSubject.find(params[:id])
            @sub = MgBatchSubject.find_by(:mg_subject_id => params[:id])
    
            # Update the subject
            @subjects.update(subject_params)
    
            if @subjects.present?
                # Check if the @sub object exists before updating
                if @sub.present?
                    @sub.update(:is_extra_curricular => params[:subjects][:is_extra_curricular])
                else
                    # Handle case where @sub is nil, either by creating a new record or logging an error
                    # Optional: Create a new MgBatchSubject if needed
                    MgBatchSubject.create(
                        mg_subject_id: @subjects.id,
                        is_extra_curricular: params[:subjects][:is_extra_curricular],
                        mg_school_id: session[:current_user_school_id],
                        is_deleted: 0
                    )
                end
    
                # Update all associated batch subjects
                batch_subjects = MgBatchSubject.where(:mg_subject_id => params[:id])
                batch_subjects.update_all(
                    is_extra_curricular: params[:subjects][:is_extra_curricular],
                    scoring_type: params[:subjects][:scoring_type]
                )
    
                render json: { message: "Subject Updated" }, status: :created
            else
                render json: { message: "Subject Update Failed" }, status: :ok
            end
        end
    end
    
    def destroy
		@notice = ""
		created_by = session[:user_id]
		@subject = MgSubject.find(params[:id])
		table_array = @subject.can_destroy?
		if table_array.present?
			session[:table_array] = table_array
			session[:table_array_id] = params[:id]
			@notice = "Subject is in use. Cannot delete subject."
            render json: { message: "Subject created successfully" }, status: :created
		else
			@subject.update(:is_deleted => 1, :updated_by => created_by)
			flash[:notice] = "Subject Deleted Successfully."
            render json: { message: "Subject created successfully" }, status: :created
		end
	end






# subject section get data
def batch_subject_asso
    @current_academic_year_id = if params[:mg_time_table_id].present?
      params[:mg_time_table_id]
    else
      view_context.get_current_academic_year(session[:current_user_school_id])
    end

    courses = MgCourse.where(
      mg_time_table_id: @current_academic_year_id,
      is_deleted: 0,
      mg_school_id: session[:current_user_school_id]
    ).pluck(:id)

    @batches = MgBatch.where(
      is_deleted: 0,
      mg_school_id: session[:current_user_school_id],
      mg_course_id: courses
    ).includes(:mg_course)

    respond_to do |format|
      format.html
      format.js # For AJAX requests
    end
  end


    private

    def sort_column
		MgSubject.column_names.include?(params[:sort]) ? params[:sort] : 'subject_name'
	end

	def sort_direction
		%w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
	end


    def subject_params
		params.require(:subjects).permit(:subject_name, :subject_code, :max_weekly_class, :mg_batch_id, :is_deleted, :mg_school_id, :mg_course_id, :is_core, :is_lab, :is_extra_curricular, :no_of_classes, :created_by, :updated_by, :index, :scoring_type)
	end
end
