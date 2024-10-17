class SubjectsController < ApplicationController
    layout "mindcom"
    
    # List of permitted columns for sorting
    SORTABLE_COLUMNS = %w[mg_course_id name]  # Add other columns that should be sortable

    def index
        current_academic_year = MgTimeTable.where("start_date < ? AND ? < end_date", Date.today, Date.today)
            .where(is_deleted: 0, mg_school_id: session[:current_user_school_id])
            .pluck(:id)

        @current_academic_year_id = current_academic_year[0]
        @current_academic_year_id = params[:mg_time_table_id] if params[:mg_time_table_id]
        courses = MgCourse.where(is_deleted: 0, mg_school_id: session[:current_user_school_id], mg_time_table_id: @current_academic_year_id).pluck(:id)

        if session[:table_array].present?
            @table_array = session[:table_array]
            @id = session[:table_array_id]
            session[:table_array_id] = nil
            session[:table_array] = nil
        end

        # Handle sorting
        @subjects = MgSubject.includes(:mg_course)
            .where(mg_course_id: courses, is_deleted: 0, mg_school_id: session[:current_user_school_id], is_archive: 0)
            .order(sort_column + " " + sort_direction)
            .search(params[:search])

        respond_to do |format|
            format.js
            format.html
        end
    end


    def create
		MgSubject.transaction do
			@subjects = MgSubject.new(subject_params)
			@subjects.is_archive = 0
			@is_save = @subjects.save
			if @is_save
				batches = MgBatch.where(:is_deleted => 0, :mg_school_id => session[:current_user_school_id], :mg_course_id => @subjects.mg_course_id)
				batches.each do |batch|
					batch_subject_association = MgBatchSubject.new
					batch_subject_association.mg_batch_id = batch.id
					batch_subject_association.mg_subject_id = @subjects.id
					batch_subject_association.is_extra_curricular = @subjects.is_extra_curricular ? 1 : 0
					batch_subject_association.is_deleted = 0
					batch_subject_association.mg_school_id = session[:current_user_school_id]
					batch_subject_association.save
				end

                render json: { message: "Sports "}, status: :created  
			else
				render 'new'
			end
		end
	end



    private

    # Define the default column to sort by if none is provided
    def sort_column
        # Ensure only sortable columns are used
        SORTABLE_COLUMNS.include?(params[:sort]) ? params[:sort] : "mg_course_id"
    end

    # Define the sort direction, defaulting to ascending if none is provided
    def sort_direction
        %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end


    def subject_params
		params.require(:mg_subject).permit(:subject_name, :subject_code, :max_weekly_class, :mg_batch_id, :is_deleted, :mg_school_id, :mg_course_id, :is_core, :is_lab, :is_extra_curricular, :no_of_classes, :created_by, :updated_by, :index, :scoring_type)
	end
end
