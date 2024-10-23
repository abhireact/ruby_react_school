class SubjectsController < ApplicationController
    layout "mindcom"
    
    # List of permitted columns for sorting
    SORTABLE_COLUMNS = %w[mg_course_id name]  # Add other columns that should be sortable


    def subject_archive
      @classSection = view_context.get_course_batch_name
      @classSection.insert(0, ["All", "all"])
    end
  
    def subject_archive_create
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



    def archived_subject_list
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


    def batch_subject_asso
      current_academic_year = view_context.get_current_academic_year(session[:current_user_school_id])
      @current_academic_year_id = current_academic_year
      @current_academic_year_id = params[:mg_time_table_id] if params[:mg_time_table_id]
      courses = MgCourse.where(:mg_time_table_id => @current_academic_year_id, :is_deleted => 0, :mg_school_id => session[:current_user_school_id]).pluck(:id)
      @batches = MgBatch.where(:is_deleted => 0, :mg_school_id => session[:current_user_school_id], :mg_course_id => courses).paginate(page: params[:page], per_page: 10)
    end
  
    def emp_subject_asso
      employee_category = MgEmployeeCategory.find_by(:category_name => "Teaching Staff", :is_deleted => 0)
      @employees = MgEmployee.where(:is_deleted => 0, :mg_employee_category_id => employee_category.id, :mg_school_id => session[:current_user_school_id], :is_archive => 0).paginate(page: params[:page], per_page: 10)
    end
  
    def select_subject
      @batches = MgBatch.find(params[:id])
      @subjects = MgSubject.where(:is_deleted => 0, :mg_school_id => session[:current_user_school_id], :mg_course_id => @batches.mg_course_id)
      @selected_subjects = MgBatchSubject.where(:mg_batch_id => "#{@batches.id}", :is_deleted => 0)
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
    
    def show
      @subjects = MgSubject.find(params[:id])
      render :layout => false
    end
  
    def edit
      @subjects = MgSubject.find(params[:id])
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




    def destroy
      subject = MgSubject.find_by(id: params[:id])
      if subject
        subject.update(is_deleted: 1)
        redirect_to subjects_path, notice: 'Subject deleted successfully'
      else
        redirect_to subjects_path, alert: 'Subject not found'
      end
    end
  
    # Batch subject assignment
    def batch_subject
      @batches = MgBatch.where(is_deleted: 0, mg_school_id: session[:current_user_school_id])
      sub_ids = params[:sub_id_list]
      emp_ids = params[:checked_employee_list]
      un_sub_ids = params[:un_checked_sub_id_list]
      batch_id = params[:batch_id]
  
      # Assign subjects to employees in batch
      if sub_ids.present? && emp_ids.present?
        sub_ids.each_with_index do |subject_id, i|
          batch_subject_association = MgBatchSubject.find_or_initialize_by(
            mg_batch_id: batch_id,
            mg_subject_id: subject_id,
            mg_school_id: session[:current_user_school_id],
            is_deleted: 0
            )
          batch_subject_association.update(
            mg_employee_id: emp_ids[i],
            is_deleted: 0,
            is_extra_curricular: 0,
            updated_by: session[:user_id]
            )
        end
      end
  
      # Unassign subjects
      if un_sub_ids.present?
        un_sub_ids.each do |subject_id|
          batch_subject_association = MgBatchSubject.find_by(
            is_deleted: 0, mg_batch_id: batch_id, mg_subject_id: subject_id, mg_school_id: session[:current_user_school_id]
            )
          batch_subject_association.update(is_deleted: 1) if batch_subject_association.present?
        end
      end
  
      redirect_to subjects_batch_subject_asso_path
    end
  
    # Assign subjects to an employee
    def emp_subject
      if request.xhr?
          employee_id = params[:employee]
          assigned_subjects = params[:assigned_subjects].to_a
          unassigned_sub = params[:batch_sub].split - assigned_subjects
  
          # Unassign subjects
          unassigned_sub.each do |subject_id|
            MgEmployeeSubject.where(mg_employee_id: employee_id,mg_subject_id: subject_id,is_deleted: 0,mg_school_id: session[:current_user_school_id]).update_all(is_deleted: 1)
          end
  
          # Assign new subjects
        assigned_subjects.each do |subject_id|
          MgEmployeeSubject.find_or_create_by(mg_employee_id: employee_id,mg_subject_id: subject_id,is_deleted: 0,mg_school_id: session[:current_user_school_id])
        end
        render js: "window.location = '/subjects/emp_subject_asso'"
      end
    end
  
    # Select subjects for an employee
    def select_subject_emp
      @employee = MgEmployee.find(params[:id])
      emp_id = @employee.id
      @subjects = MgSubject.where(is_deleted: 0, mg_school_id: session[:current_user_school_id])
      @selected_subjects = MgEmployeeSubject.where(
        mg_employee_id: emp_id, is_deleted: 0, mg_school_id: session[:current_user_school_id]
        ).pluck(:mg_subject_id)
      @courses = MgCourse.where(is_deleted: 0, mg_school_id: session[:current_user_school_id]).pluck(:course_name, :id)
    end
  
    # Employee mark entry permission (departments)
    def employee_mark_entry_permission
      @departments = MgEmployeeDepartment.where(mg_school_id: session[:current_user_school_id], is_deleted: 0)
  
      if params[:departments].present?
        employees = MgEmployee.where(
          mg_employee_department_id: params[:departments],
          mg_school_id: session[:current_user_school_id],
          is_deleted: 0
          )
  
        if employees.present?
          @employee_array = []
          s_no = 0
          employees.each do |employee|
            employee_position = MgEmployeePosition.find_by(id: employee.mg_employee_position_id, mg_school_id: session[:current_user_school_id], is_deleted: 0)
            emp_position = employee_position&.position_name&.upcase || ''
            category_name = MgEmployeeCategory.find_by(id: employee.mg_employee_category_id, is_deleted: 0)&.category_name
  
            if category_name == 'Teaching Staff' || ["PRINCIPAL", "ADMIN"].include?(emp_position)
              s_no += 1
              @employee_array << {
                s_no: s_no,
                user_id: employee.employee_number,
                employee_name: employee.employee_name,
                designation: emp_position,
                mark_entry_access: employee.mark_entry_access
              }
            end
          end
        else
          flash[:notice] = "Teaching Staff Employees not found!"
        end
      end
  
      render layout: false
    end
  
    # Grant or revoke mark entry permission for employees
    def employee_marks_access
      user_ids = params["user_ids"]
      employees = MgEmployee.where(employee_number: user_ids,mg_school_id: session[:current_user_school_id],is_deleted: 0
        )
  
      emp_names = []
      employees.each do |employee|
        if employee.update(mark_entry_access: true)
          emp_names << employee.employee_name
        end
      end
  
      departments = params["departments"] - params["user_ids"]
      if departments.present?
        MgEmployee.where(
          mg_employee_department_id: departments,
          mg_school_id: session[:current_user_school_id],
          is_deleted: 0,
          mark_entry_access: true
          ).where.not(id: employees.pluck(:id)).update_all(mark_entry_access: nil)
      end
  
      flash[:success] = "#{emp_names.join(', ')} successfully granted mark entry access."
      redirect_to action: "employee_mark_entry_permission"
    end
  
    # Employee other mark entry permission
    def employee_other_mark_entry_permission
      @departments = MgEmployeeDepartment.where(mg_school_id: session[:current_user_school_id], is_deleted: 0)
    end
  
    def employee_other_marks_permission
      if params[:departments].present?
        employees = MgEmployee.where(mg_employee_department_id: params[:departments], mg_school_id: session[:current_user_school_id], is_deleted: 0)
        if employees.present?
          @departments = []
          @employee_array = []
          s_no = 0
          employees.each do |employee|
            employee_position = MgEmployeePosition.find_by(id: employee.mg_employee_position_id, mg_school_id: session[:current_user_school_id], is_deleted: 0)
            emp_position = employee_position&.position_name&.upcase || ""
            category_name = MgEmployeeCategory.find_by(id: employee.mg_employee_category_id, is_deleted: 0)
            if category_name.present? || %w[PRINCIPAL ADMIN].include?(emp_position)
              category_name = category_name&.category_name
              if (category_name == "Teaching Staff" && employee_position.present?) || %w[PRINCIPAL ADMIN].include?(emp_position)
                s_no += 1
                @employee_array << {
                  s_no: s_no,
                  id: employee.id,
                  user_id: employee.employee_number,
                  employee_name: employee.employee_name,
                  designation: employee_position.position_name,
                  other_mark_entry_access: employee.other_mark_entry_access
                }
              end
            end
          end
        else
          flash[:notice] = "Teaching Staff Employees are not there!"
        end
  
        render layout: false
      end
    end
  
    def employee_other_marks_access
      user_ids = params["user_ids"]
      employees = MgEmployee.where(employee_number: user_ids, mg_school_id: session[:current_user_school_id], is_deleted: 0)
  
      emp_arr = []
      employees.each do |employee|
        employee.update(other_mark_entry_access: true)
        emp_arr << employee.employee_name
      end
  
      departments = params["departments"] - params["user_ids"]
      @departments = MgEmployeeDepartment.where(id: departments, mg_school_id: session[:current_user_school_id], is_deleted: 0)
  
      if params["departments"].present?
        emp_ids = employees.pluck(:id)
        permissed_employees = MgEmployee.where(mg_employee_department_id: params["departments"], mg_school_id: session[:current_user_school_id], is_deleted: 0, mark_entry_access: true)
  
        permissed_employees.each do |employee|
          unless emp_ids.include?(employee.id)
            employee.update(other_mark_entry_access: nil)
          end
        end
      end
  
      flash[:success] = "#{emp_arr.join(', ')}: Other mark entry access granted successfully"
      redirect_to controller: "subjects", action: "employee_other_mark_entry_permission"
    end
  
    def employee_other_subject_new
      @employee = MgEmployee.find_by(id: params[:employee_id], is_deleted: 0)
    end
  
    def employee_other_subject_index
      @time_table_id = params[:academicyear_id]
      @course_id = params[:course_id]
      @batch_id = params[:batch_id]
      @employee_id = params[:employee_id]
      @co_scholastic_component_id = params[:co_scholastic_component_id]
  
      if @co_scholastic_component_id == "0"
        emp_particular_subjects = MgEmployeeOtherSubject.find_by(
          mg_employee_id: @employee_id,
          mg_batch_id: @batch_id,
          mg_course_id: @course_id,
          is_deleted: 0,
          mg_school_id: session[:current_user_school_id],
          mg_co_scholastic_exam_particular_id: @co_scholastic_component_id
          )
  
        @co_scholastic_particular = [{
          id: 0,
          name: "HEIGHT & WEIGHT",
          subject_access: emp_particular_subjects&.physical_measurement || false
        }]
      else
        component_id = MgCbscCoScholasticExamComponents.where(id: @co_scholastic_component_id, mg_school_id: session[:current_user_school_id], is_deleted: 0).pluck(:id)
        @co_scholastic_particular = MgCbscCoScholasticExamParticular.where(mg_school_id: session[:current_user_school_id], is_deleted: 0, mg_cbsc_co_scholastic_exam_component_id: component_id)
      end
  
      render layout: false
    end
  
    def other_mark_entry_subject_access
      @co_scholastic_component_id = params["co_scholastic_component_id"]
      @co_scholastic_particular = params["co_scholastic_particular"]
      employee_id = params["employee_id"]
      course_id = params["course_id"]
      batch_id = params["batch_id"]
  
      employee_subjects = MgEmployeeOtherSubject.where(mg_employee_id: employee_id,mg_batch_id: batch_id,mg_course_id: course_id,is_deleted: 0,mg_school_id: session[:current_user_school_id])
  
      if @co_scholastic_particular.present?
        @co_scholastic_particular.each do |particular|
          co_scholastic_particular = MgCbscCoScholasticExamParticular.where(mg_school_id: session[:current_user_school_id],is_deleted: 0,id: particular.to_i,mg_cbsc_co_scholastic_exam_component_id: @co_scholastic_component_id.to_i)
  
          if co_scholastic_particular.present?
            co_scholastic_particular.update_all(subject_access: true)
          end
  
          @other_subject = MgEmployeeOtherSubject.create(mg_co_scholastic_exam_particular_id: particular.to_i,mg_cbsc_co_scholastic_exam_component_id: @co_scholastic_component_id.to_i,mg_employee_id: employee_id,mg_course_id: course_id,mg_batch_id: batch_id,is_deleted: 0,mg_school_id: session[:current_user_school_id],created_by: session[:user_id],updated_by: session[:user_id])
  
          if particular.to_i == 0
            @other_subject.update(physical_measurement: true)
          end
        end
      end
  
      if @co_scholastic_component_id == "0"
        employee_subjects.update_all(physical_measurement: params[:employees_check_box] == "true")
      else
        employee_subjects.each do |emp|
          if !@co_scholastic_particular.include?(emp.mg_co_scholastic_exam_particular_id.to_s)
            emp.update(is_deleted: 1)
            co_scholastic_particular = MgCbscCoScholasticExamParticular.where(mg_school_id: session[:current_user_school_id],is_deleted: 0,id: emp.mg_co_scholastic_exam_particular_id,mg_cbsc_co_scholastic_exam_component_id: @co_scholastic_component_id.to_i)
  
            co_scholastic_particular.update_all(subject_access: nil) if co_scholastic_particular.present?
          end
        end
      end
  
      redirect_to controller: "subjects", action: "employee_other_subject_new"
    end
  
  
    def get_employees_by_subject
      mg_time_table_id = params[:mg_time_table_id]
      wing_id = params[:wing_id]
      course_id = params[:course_id]
      batch_id = params[:batch_id]
  
      subj_id = MgSubject.where(mg_course_id: course_id, is_deleted: false, mg_school_id: session[:current_user_school_id]).pluck(:id)
      emp_ids = MgEmployeeSubject.where(mg_subject_id: subj_id, is_deleted: false, mg_school_id: session[:current_user_school_id]).pluck(:mg_employee_id)
      employees = MgEmployee.where(id: emp_ids, is_deleted: false, mg_school_id: session[:current_user_school_id]).pluck(:first_name, :id)
  
      render json: { employees: employees }, layout: false
    end
  
    def employee_subjects
      @batchID = params[:batch_id]
      @mg_time_table_id = params[:mg_time_table_id]
      @employee_id = params[:employee]
  
      empo = MgEmployee.find_by(id: @employee_id, is_deleted: false, mg_school_id: session[:current_user_school_id])
      return unless empo
  
      emp_sub_ids = MgEmployeeSubject.where(mg_employee_id: empo.id, is_deleted: false, mg_school_id: session[:current_user_school_id]).pluck(:mg_subject_id).uniq
      batch_sub_ids = MgBatchSubject.where(mg_subject_id: emp_sub_ids, mg_batch_id: @batchID, is_deleted: false, mg_school_id: session[:current_user_school_id], is_extra_curricular: false).pluck(:mg_subject_id)
  
      if batch_sub_ids.present?
        @subjects = MgSubject.where(id: batch_sub_ids, is_deleted: false, mg_school_id: session[:current_user_school_id])
      end
  
      render layout: false
    end
  
    def get_subject_batch_id
      return unless params[:mg_course_id].present?
  
      batch_ids = MgBatch.where(mg_course_id: params[:mg_course_id], is_deleted: false).pluck(:id)
      @employee_subjects = MgEmployeeSubject.where(is_deleted: false, mg_school_id: session[:current_user_school_id], mg_employee_id: params[:employee]).pluck(:mg_subject_id)
      @batch_subjects = MgBatchSubject.where(is_deleted: false, mg_school_id: session[:current_user_school_id], mg_batch_id: batch_ids).pluck(:mg_subject_id)
  
      assigned_subject_ids = @batch_subjects & @employee_subjects
      @assigned_subjects = MgSubject.where(is_deleted: false, mg_school_id: session[:current_user_school_id], id: assigned_subject_ids)
  
      @subjects = MgSubject.where(is_deleted: false, mg_school_id: session[:current_user_school_id], id: @batch_subjects)
  
      available_subjects_ids = @subjects - @assigned_subjects.ids
      @available_subjects = MgSubject.where(is_deleted: false, mg_school_id: session[:current_user_school_id], id: available_subjects_ids)
  
      render layout: false
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
