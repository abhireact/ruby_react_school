class UploadExcelController < ApplicationController
  layout "mindcom"
  def employee_data_exists
    school_id = session[:current_user_school_id]
    
    # Perform checks for all the entities
    department_exists = MgEmployeeDepartment.exists?(is_deleted: 0, mg_school_id: school_id)
    employee_profile_exists = MgEmployeePosition.exists?(is_deleted: 0, mg_school_id: school_id)
    salary_component_exists = MgSalaryComponent.exists?(mg_school_id: school_id, is_deleted: false)
    grade_exists = MgEmployeeGrade.exists?(is_deleted: 0, mg_school_id: school_id)
    employee_type_exists = MgEmployeeType.exists?(is_deleted: 0, mg_school_id: school_id)
    leave_type_exists = MgEmployeeLeaveType.exists?(is_deleted: 0, mg_school_id: school_id)
    employee_exists = MgEmployee.exists?(is_deleted: false, mg_school_id: school_id)
   
  
    # Render the results as a JSON object
    render json: {
      department_exists: department_exists,
      employee_profile_exists: employee_profile_exists,
      salary_component_exists: salary_component_exists,
      grade_exists: grade_exists,
      employee_type_exists: employee_type_exists,
      leave_type_exists: leave_type_exists,
      employee_exists: employee_exists
    }
  end
 
  def upload_departments
    current_time = Time.now
    school_id = session[:current_user_school_id]
    user_id = session[:user_id]
  
    # Arrays to track results
    created_departments = []
    duplicate_departments = []
    errors = []
  
    # Validate input
    unless params[:data].is_a?(Array)
      return render_json_response({
        status: 'error',
        message: 'Invalid data format. Expected an array of departments.',
        data: {}
      }, :unprocessable_entity)
    end
  
    # Sanitize and prepare departments
    @departments = params.require(:data).map do |department|
      department.permit(:department_name, :department_code, :row_number).to_h
    end
  
    # Check for duplicates first
    existing_departments = MgEmployeeDepartment.where(
      department_name: @departments.map { |dept| dept[:department_name] },
      mg_school_id: school_id,
      is_deleted: false
    ).pluck(:department_name).to_set
  
    ActiveRecord::Base.transaction do
      @departments.each_with_index do |department, index|
        department_name = department[:department_name]
  
        if existing_departments.include?(department_name)
          duplicate_departments << {
            row: department[:row_number] || (index + 1),
            name: department_name,
            error: "Employee Department '#{department_name}' already exists"
          }
        else
          begin
            MgEmployeeDepartment.create!(
              department_name: department_name,
              department_code: department[:department_code],
              is_deleted: false,
              mg_school_id: school_id,
              created_by: user_id,
              updated_by: user_id,
              created_at: current_time,
              updated_at: current_time
            )
            created_departments << { 
              row: department[:row_number] || (index + 1), 
              name: department_name 
            }
          rescue ActiveRecord::RecordInvalid => e
            errors << {
              row: department[:row_number] || (index + 1),
              name: department_name,
              error: e.message
            }
            raise ActiveRecord::Rollback # Ensure rollback of all changes if any error occurs
          end
        end
      end
  
      # If there are duplicates or errors, raise a rollback to undo any created records
      if duplicate_departments.any? || errors.any?
        raise ActiveRecord::Rollback
      end
    end
  
    # Prepare the response
    if duplicate_departments.any? || errors.any?
      render_json_response({
        status: 'error',
        message: 'Some Departments could not be processed. No departments were created.',
        data: {
          created: created_departments,
          duplicate: duplicate_departments,
          errors: errors
        }
      }, :unprocessable_entity)
    else
      render_json_response({
        status: 'success',
        message: 'All Departments processed successfully',
        data: {
          created: created_departments
        }
      }, :ok)
    end
  rescue StandardError => e
    handle_error(e)
  end
  
  def upload_positions
    current_time = Time.now
    school_id = session[:current_user_school_id]
    user_id = session[:user_id]
  
    # Arrays to track results
    created_positions = []
    duplicate_positions = []
    errors = []
  
    # Validate input
    unless params[:data].is_a?(Array)
      return render_json_response({
        status: 'error',
        message: 'Invalid data format. Expected an array of positions.',
        data: {}
      }, :unprocessable_entity)
    end
  
    # Sanitize and prepare positions
    @positions = params.require(:data).map do |position|
      position.permit(:category_name, :position_name, :row_number).to_h
    end
  
    # Use a transaction to ensure atomicity
    ActiveRecord::Base.transaction do
      @positions.each_with_index do |position, index|
        category_name = position[:category_name]
        position_name = position[:position_name]
        row_number = position[:row_number] || (index + 1)
  
        # Find the employee category
        employee_category = MgEmployeeCategory
                            .where(is_deleted: false)
                            .where(MgEmployeeCategory.arel_table[:category_name].matches(category_name))
                            .first
  
        if employee_category
          # Check for duplicate positions
          if MgEmployeePosition.exists?(position_name: position_name, mg_school_id: school_id, is_deleted: false)
            duplicate_positions << {
              row: row_number,
              name: position_name,
              error: "Position '#{position_name}' already exists"
            }
            raise ActiveRecord::Rollback, "Duplicate position found"
          else
            # Create the new position
            MgEmployeePosition.create!(
              mg_employee_category_id: employee_category.id,
              position_name: position_name,
              is_deleted: false,
              mg_school_id: school_id,
              created_by: user_id,
              updated_by: user_id,
              created_at: current_time,
              updated_at: current_time
            )
            created_positions << { 
              row: row_number,
              name: position_name 
            }
          end
        else
          errors << {
            row: row_number,
            name: position_name,
            error: "Category '#{category_name}' not found in the system"
          }
          raise ActiveRecord::Rollback, "Category not found"
        end
      end
    end
  
    # If there are errors or duplicates, return a failure response
    if duplicate_positions.any? || errors.any?
      render_json_response({
        status: 'error',
        message: 'Some Positions could not be processed. No positions were created.',
        data: {
          created: [],
          duplicate: duplicate_positions,
          errors: errors
        }
      }, :unprocessable_entity)
    else
      # Otherwise, return success
      render_json_response({
        status: 'success',
        message: 'All Positions processed successfully.',
        data: {
          created: created_positions,
          duplicate: [],
          errors: []
        }
      }, :ok)
    end
  rescue StandardError => e
    # Handle any unexpected errors
    handle_error(e)
  end
  
  
  
  
  def upload_employee_types
    current_time = Time.now
    school_id = session[:current_user_school_id]
    user_id = session[:user_id]
  
    # Arrays to track results
    created_types = []
    duplicate_types = []
    errors = []
  
    # Validate input
    unless params[:data].is_a?(Array)
      return render_json_response({
        status: 'error',
        message: 'Invalid data format. Expected an array of employee types.',
        data: {}
      }, :unprocessable_entity)
    end
  
    # Sanitize and prepare employee types
    @employee_types = params.require(:data).map do |type|
      type.permit(:employee_type, :row_number).to_h
    end
  
    # Start a transaction to ensure atomicity
    ActiveRecord::Base.transaction do
      begin
        # Process employee types
        @employee_types.each_with_index do |type, index|
          employee_type = type[:employee_type]
          row_number = type[:row_number] || (index + 1)
  
          # Check for duplicate employee types
          if MgEmployeeType.exists?(employee_type: employee_type, mg_school_id: school_id, is_deleted: false)
            duplicate_types << {
              row: row_number,
              name: employee_type,
              error: "Employee Type '#{employee_type}' already exists in the system"
            }
          else
            # Create the new employee type
            MgEmployeeType.create!(
              employee_type: employee_type,
              is_deleted: false,
              mg_school_id: school_id,
              created_by: user_id,
              updated_by: user_id,
              created_at: current_time,
              updated_at: current_time
            )
            created_types << { 
              row: row_number, 
              name: employee_type 
            }
          end
        end
  
        # If there are any duplicates or errors, rollback the transaction
        if duplicate_types.any? || errors.any?
          raise ActiveRecord::Rollback, 'Validation errors occurred'
        end
  
      rescue ActiveRecord::RecordInvalid => e
        errors << {
          row: row_number,
          name: employee_type,
          error: e.message
        }
        raise ActiveRecord::Rollback, 'Validation errors occurred'
      end
    end
  
    # Prepare the response based on the transaction outcome
    if duplicate_types.any? || errors.any?
      response = {
        status: 'error',
        message: 'Some Employee Types could not be processed. No changes have been made.',
        data: {
          created: created_types,
          duplicate: duplicate_types,
          errors: errors
        }
      }
      render_json_response(response, :unprocessable_entity)
    else
      response = {
        status: 'success',
        message: 'All Employee Types processed successfully',
        data: {
          created: created_types,
          duplicate: duplicate_types,
          errors: errors
        }
      }
      render_json_response(response, :ok)
    end
  rescue StandardError => e
    handle_error(e)
  end
  
  
  def upload_salary
    current_time = Time.now
    school_id = session[:current_user_school_id]
    user_id = session[:user_id]
  
    # Arrays to track results
    created_salary_components = []
    duplicate_salary_components = []
  
    # Validate input
    unless params[:data].is_a?(Array)
      return render_json_response({
        status: 'error',
        message: 'Invalid data format. Expected an array of salary components.',
        data: {}
      }, :unprocessable_entity)
    end
  
    # Sanitize and prepare salary components
    salary_components = params.require(:data).map do |component|
      component.permit(:account_name, :name, :is_deduction, :row_number).to_h
    end
  
    ActiveRecord::Base.transaction do
      # Process salary components
      salary_components.each_with_index do |salary_component, index|
        account_name = salary_component[:account_name]
        name = salary_component[:name]
        is_deduction = salary_component[:is_deduction]
        row_number = salary_component[:row_number] || (index + 1)
  
        # Fetch MgAccount based on school_id and account_name
        account_result = MgAccount.find_by(mg_school_id: school_id, mg_account_name: account_name, is_deleted: false)
  
        if account_result.blank?
          duplicate_salary_components << {
            row: row_number,
            name: account_name,
            error: "Invalid Account Name"
          }
          raise ActiveRecord::Rollback # Trigger rollback
        else
          # Check for existing salary component with the same name and account_id
          if MgSalaryComponent.exists?(name: name, mg_account_id: account_result.id, mg_school_id: school_id, is_deleted: false)
            duplicate_salary_components << {
              row: row_number,
              name: name,
              error: "Salary Component '#{name}' already exists"
            }
            raise ActiveRecord::Rollback # Trigger rollback
          else
            # Create the new salary component
            MgSalaryComponent.create!(
              name: name,
              mg_account_id: account_result.id,
              is_deduction: is_deduction,
              is_deleted: false,
              mg_school_id: school_id,
              created_by: user_id,
              updated_by: user_id,
              created_at: current_time,
              updated_at: current_time
            )
            created_salary_components << { 
              row: row_number, 
              name: name 
            }
          end
        end
      end
  
      # If we reach this point, everything was successful
      response = {
        status: 'success',
        message: 'All Salary Components processed successfully',
        data: {
          created: created_salary_components,
          duplicate: []
        }
      }
      render_json_response(response, :ok)
    rescue ActiveRecord::Rollback
      # Handle rollback scenario
      response = {
        status: 'error',
        message: 'No Salary Components were created due to errors',
        data: {
          created: [],
          duplicate: duplicate_salary_components
        }
      }
      render_json_response(response, :unprocessable_entity)
    end
  rescue StandardError => e
    handle_error(e)
  end
  
  
  
  def upload_employee_leave_types
    current_time = Time.now
    school_id = session[:current_user_school_id]
    user_id = session[:user_id]
  
    # Arrays to track results
    created_leave_types = []
    duplicate_leave_types = []
  
    # Validate input
    unless params[:data].is_a?(Array)
      return render_json_response({
        status: 'error',
        message: 'Invalid data format. Expected an array of leave types.',
        data: {}
      }, :unprocessable_entity)
    end
  
    # Sanitize and prepare leave types
    leave_types = params.require(:data).map do |leave_type|
      leave_type.permit(
        :leave_name, :leave_code, :max_leave_count, :reset_period, :reset_date,
        :is_auto_reset, :is_carry_forward, :status, :carry_forward_limit,
        :accumilation_count, :accumilation_period, :min_leave_count, 
        :is_accumilation, :minimum_year_experience, :minimum_month_experience,
        :gender, :is_leave_should_not_be_deducted, :marital_status, 
        :is_showable, :delay_deduction, :delay_time, :delay_days, 
        :leave_deduction_count, :monthly_limit, :row_number, :employee_type
      ).to_h
    end
  
    # Process leave types
    leave_types.each_with_index do |leave_type, index|
      leave_name = leave_type[:leave_name]
      employee_type = leave_type[:employee_type]
      row_number = leave_type[:row_number] || (index + 1)
  
      # Fetch MgEmployeeType based on school_id and employee_type
      employee_type_result = MgEmployeeType.find_by(
        mg_school_id: school_id, 
        employee_type: employee_type, 
        is_deleted: false
      )
  
      if employee_type_result.blank?
        duplicate_leave_types << {
          row: row_number,
          name: employee_type,
          error: "Invalid Employee Type"
        }
      else
        # Check for existing leave type with the same name and employee type
        if MgEmployeeLeaveType.exists?(
             leave_name: leave_name, 
             mg_employee_type_id: employee_type_result.id, 
             mg_school_id: school_id, 
             is_deleted: false
           )
          duplicate_leave_types << {
            row: row_number,
            name: leave_name,
            error: "Leave Type '#{leave_name}' already exists for this Employee Type"
          }
        else
          begin
            # Create the new leave type
            MgEmployeeLeaveType.create!(
              leave_name: leave_name,
              leave_code: leave_type[:leave_code],
              max_leave_count: leave_type[:max_leave_count],
              reset_period: leave_type[:reset_period],
              reset_date: leave_type[:reset_date],
              is_auto_reset: leave_type[:is_auto_reset],
              is_carry_forward: leave_type[:is_carry_forward],
              status: leave_type[:status],
              carry_forward_limit: leave_type[:carry_forward_limit],
              accumilation_count: leave_type[:accumilation_count],
              accumilation_period: leave_type[:accumilation_period],
              min_leave_count: leave_type[:min_leave_count],
              mg_employee_type_id: employee_type_result.id,
              is_deleted: false,
              mg_school_id: school_id,
              created_by: user_id,
              updated_by: user_id,
              created_at: current_time,
              updated_at: current_time,
              is_accumilation: leave_type[:is_accumilation],
              minimum_year_experience: leave_type[:minimum_year_experience],
              minimum_month_experience: leave_type[:minimum_month_experience],
              gender: leave_type[:gender],
              is_leave_should_not_be_deducted: leave_type[:is_leave_should_not_be_deducted],
              marital_status: leave_type[:marital_status],
              is_showable: leave_type[:is_showable],
              delay_deduction: leave_type[:delay_deduction],
              delay_time: leave_type[:delay_time],
              delay_days: leave_type[:delay_days],
              leave_deduction_count: leave_type[:leave_deduction_count],
              monthly_limit: leave_type[:monthly_limit]
            )
            created_leave_types << {
              row: row_number,
              name: leave_name
            }
          rescue ActiveRecord::RecordInvalid => e
            duplicate_leave_types << {
              row: row_number,
              name: leave_name,
              error: e.message
            }
          end
        end
      end
    end
  
    # Prepare the response
    response = {
      status: duplicate_leave_types.any? ? 'error' : 'success',
      message: duplicate_leave_types.any? ? 'Some Leave Types could not be processed' : 'All Leave Types processed successfully',
      data: {
        created: created_leave_types,
        duplicate: duplicate_leave_types
      }
    }
  
    # Render the response
    render_json_response(response, duplicate_leave_types.any? ? :unprocessable_entity : :ok)
  rescue StandardError => e
    handle_error(e)
  end
  
  def upload_grades
    current_time = Time.now
    school_id = session[:current_user_school_id]
    user_id = session[:user_id]
  
    # Arrays to track results
    created_employee_grades = []
    duplicate_employee_grades = []
  
    # Validate input
    unless params[:data].is_a?(Array)
      return render_json_response({
        status: 'error',
        message: 'Invalid data format. Expected an array of employee grades.',
        data: {}
      }, :unprocessable_entity)
    end
  
    # Sanitize and prepare employee grades
    employee_grades = params.require(:data).map do |grade|
      grade.permit(:grade_name, :row_number).to_h
    end
  
    # Process grades
    employee_grades.each_with_index do |grade, index|
      grade_name = grade[:grade_name]
      row_number = grade[:row_number] || (index + 1)
  
      # Check for existing grade with the same name
      if MgEmployeeGrade.exists?(grade_name: grade_name, mg_school_id: school_id, is_deleted: false)
        duplicate_employee_grades << {
          row: row_number,
          name: grade_name,
          error: "Employee Grade '#{grade_name}' already exists in the system"
        }
      else
        begin
          # Create the new employee grade
          MgEmployeeGrade.create!(
            grade_name: grade_name,
            is_deleted: false,
            mg_school_id: school_id,
            created_by: user_id,
            updated_by: user_id,
            created_at: current_time,
            updated_at: current_time
          )
          created_employee_grades << {
            row: row_number,
            name: grade_name
          }
        rescue ActiveRecord::RecordInvalid => e
          duplicate_employee_grades << {
            row: row_number,
            name: grade_name,
            error: e.message
          }
        end
      end
    end
  
    # Prepare the response
    response = {
      status: duplicate_employee_grades.any? ? 'error' : 'success',
      message: duplicate_employee_grades.any? ? 'Some Employee Grades could not be processed' : 'All Employee Grades processed successfully',
      data: {
        created: created_employee_grades,
        duplicate: duplicate_employee_grades
      }
    }
  
    # Render the response
    render_json_response(response, duplicate_employee_grades.any? ? :unprocessable_entity : :ok)
  rescue StandardError => e
    handle_error(e)
  end
  # def upload_employees
  #   current_time = Time.now
  #   school_id = session[:current_user_school_id]
  #   user_id = session[:user_id]
    
  #   # Arrays to track results
  #   created_employees = []
  #   failed_employees = []
    
  #   # Validate input
  #   unless params[:data].is_a?(Array)
  #     return render_json_response({
  #       status: 'error',
  #       message: 'Invalid data format. Expected an array of employees.',
  #       data: {}
  #     }, :unprocessable_entity)
  #   end
  
  #   # Start a transaction
  #   ActiveRecord::Base.transaction do
  #     begin
  #       employees_data = params[:data]
  #       employees_data.each_with_index do |employee_data, index|
  #         row_number = index + 1
  
  #         # Check for existing employee number
  #         existing_employee_number = MgEmployee.find_by(employee_number: employee_data[:employee_number], mg_school_id: school_id)
  #         if existing_employee_number
  #           failed_employees << { row: row_number, name: "#{employee_data[:first_name]} #{employee_data[:last_name]}", error: "Duplicate employee number" }
  #           next
  #         end
  
  #         # Check for existing mobile number
  #         existing_employee_mobile = MgPhone.find_by(phone_number: employee_data[:mobile_number], mg_school_id: school_id)
  #         if existing_employee_mobile
  #           failed_employees << { row: row_number, name: "#{employee_data[:first_name]} #{employee_data[:last_name]}", error: "Duplicate mobile number" }
  #           next
  #         end
  
  #         # Find or create related entities
  #         employee_department = MgEmployeeDepartment.find_or_create_by!(
  #           department_name: employee_data[:emp_department],
  #           mg_school_id: school_id,
  #           is_deleted: false
  #         )
  #         employee_category = MgEmployeeCategory.find_or_create_by!(
  #           category_name: employee_data[:emp_category],
  #           is_deleted: false
  #         )
  #         employee_type = MgEmployeeType.find_or_create_by!(
  #           employee_type: employee_data[:emp_type] || 'Default',
  #           mg_school_id: school_id,
  #           is_deleted: false
  #         )
  #         employee_position = MgEmployeePosition.find_or_create_by!(
  #           position_name: employee_data[:emp_profile] || 'Default',
  #           mg_school_id: school_id,
  #           is_deleted: false
  #         )
  #         employee_grade = MgEmployeeGrade.find_or_create_by!(
  #           grade_name: employee_data[:emp_grade] || 'Default',
  #           mg_school_id: school_id,
  #           is_deleted: false
  #         )
  
  #         # Generate username
  #         school_subdomain = MgSchool.find_by(id: school_id, is_deleted: false)&.subdomain
  #         highest_user = MgUser.where("user_name LIKE ?", "#{school_subdomain}E%")
  #                              .order(created_at: :desc).pluck(:user_name).first
  #         username = if highest_user&.casecmp?("#{school_subdomain}sim")
  #                      "#{school_subdomain}E1"
  #                    else
  #                      highest_number = highest_user.to_s.scan(/\d+/).last.to_i
  #                      "#{school_subdomain}E#{highest_number + 1}"
  #                    end
  
  #         # Create User
  #         user = MgUser.create!(
  #           user_name: username,
  #           first_name: employee_data[:first_name],
  #           middle_name: employee_data[:middle_name],
  #           last_name: employee_data[:last_name],
  #           email: employee_data[:email_id],
  #           password: 'employee123', # Default password
  #           user_type: "employee",
  #           mg_school_id: school_id,
  #           created_by: user_id,
  #           updated_by: user_id,
  #           created_at: current_time,
  #           updated_at: current_time
  #         )
  
  #         MgPhone.create!(
  #           phone_number: employee_data[:mobile_number],
  #           phone_type: 'mobile',
  #           notification: true,
  #           subscription: true,
  #           mg_user_id: user.id,
  #           mg_school_id: school_id,
  #           is_deleted: false,
  #           created_by: user_id,
  #           updated_by: user_id,
  #           created_at: current_time,
  #           updated_at: current_time
  #         )
          
  #         # Create Employee
  #         employee = MgEmployee.create!(
  #           mg_user_id: user.id,
  #           mg_employee_type_id: employee_type.id,
  #           mg_employee_category_id: employee_category.id,
  #           mg_employee_position_id: employee_position.id,
  #           mg_employee_department_id: employee_department.id,
  #           mg_employee_grade_id: employee_grade.id,
  #           max_no_of_class: employee_data[:max_class_per_day],
  #           hobby: employee_data[:hobby],
  #           extra_curricular: employee_data[:extra_curricular],
  #           sport_activity: employee_data[:sport_activity],
  #           employee_number: username,
  #           joining_date: employee_data[:employee_joining_date],
  #           first_name: employee_data[:first_name],
  #           middle_name: employee_data[:middle_name],
  #           last_name: employee_data[:last_name],
  #           gender: employee_data[:gender],
  #           job_title: employee_data[:job_title],
  #           qualification: employee_data[:qualification],
  #           date_of_birth: employee_data[:date_of_birth],
  #           marital_status: employee_data[:marital_status],
  #           father_name: employee_data[:father_name],
  #           mother_name: employee_data[:mother_name],
  #           blood_group: employee_data[:blood_group],
  #           is_referred: employee_data[:is_referred],
  #           referred_by: employee_data[:referred_by],
  #           adharnumber: employee_data[:aadhar_number],
  #           designation: employee_data[:emp_profile],
  #           is_ltc_applicable: employee_data[:ltc_applicable],
  #           last_working_day: employee_data[:last_work_day],
  #           experience_year: employee_data[:t_year_exp],
  #           experience_month: employee_data[:t_mon_exp],
  #           status: employee_data[:status],
  #           is_archive: false,
  #           is_deleted: false,
  #           emergency_contact_name: employee_data[:emergency_contact_name],
  #           emergency_contact_number: employee_data[:emergency_contact_number],
  #           language: employee_data[:language],
  #           nationality: employee_data[:nationality],
  #           mg_school_id: school_id,
  #           created_by: user_id,
  #           updated_by: user_id,
  #           created_at: current_time,
  #           updated_at: current_time
  #         )
  
  #         # Create Bank Details
  #         MgBankAccountDetail.create!(
  #           bank_name: employee_data[:bank_name],
  #           account_number: employee_data[:account_number],
  #           ifs_code: employee_data[:ifs_code],
  #           mg_school_id: school_id,
  #           mg_employee_id: employee.id,
  #           is_deleted: false,
  #           created_by: user_id,
  #           updated_by: user_id,
  #           created_at: current_time,
  #           updated_at: current_time
  #         )
  
  #         # Add to successful creation list
  #         created_employees << { 
  #           row: row_number, 
  #           name: "#{employee_data[:first_name]} #{employee_data[:last_name]} #{username}",
  #           username: username 
  #         }
  #       end
  #     rescue StandardError => e
  #       # Handle the exception and log the error
  #       failed_employees << { reason: e.message }
  #     end
  #   end
  
  #   # Prepare the response
  #   if failed_employees.any?
  #     render_json_response({
  #       status: 'error',
  #       message: 'Some employees could not be processed. No employees were created.',
  #       data: {
  #         created: created_employees,
  #         duplicate: failed_employees
  #       }
  #     }, :unprocessable_entity)
  #   else
  #     render_json_response({
  #       status: 'success',
  #       message: 'All employees processed successfully',
  #       data: {
  #         created: created_employees
  #       }
  #     }, :ok)
  #   end
  
  # rescue StandardError => e
  #   # Handle any other errors that may occur
  #   response = {
  #     status: 'error',
  #     message: e.message,
  #     data: { created: [], duplicate: failed_employees }
  #   }
  #   render_json_response(response, :unprocessable_entity)
  # end
  def upload_employees
    current_time = Time.now
    school_id = session[:current_user_school_id]
    user_id = session[:user_id]
    
    # Arrays to track results
    created_employees = []
    failed_employees = []
    
    # Validate input
    unless params[:data].is_a?(Array)
      return render_json_response({
        status: 'error',
        message: 'Invalid data format. Expected an array of employees.',
        data: {}
      }, :unprocessable_entity)
    end
  
    # Start a transaction
    ActiveRecord::Base.transaction do
      begin
        employees_data = params[:data]
        employees_data.each_with_index do |employee_data, index|
          row_number = index + 1
  
          begin
            # Check for existing employee number
            existing_employee_number = MgEmployee.find_by(employee_number: employee_data[:employee_number], mg_school_id: school_id)
            if existing_employee_number
              failed_employees << { row: row_number, name: "#{employee_data[:first_name]} #{employee_data[:last_name]}", error: "Duplicate employee number" }
              next
            end
  
            # Check for existing mobile number
            existing_employee_mobile = MgPhone.find_by(phone_number: employee_data[:mobile_number], mg_school_id: school_id)
            if existing_employee_mobile
              failed_employees << { row: row_number, name: "#{employee_data[:first_name]} #{employee_data[:last_name]}", error: "Duplicate mobile number" }
              next
            end
  
            # Find or create related entities
            employee_department = MgEmployeeDepartment.find_or_create_by!(
              department_name: employee_data[:emp_department],
              mg_school_id: school_id,
              is_deleted: false
            )
            employee_category = MgEmployeeCategory.find_or_create_by!(
              category_name: employee_data[:emp_category],
              is_deleted: false
            )
            employee_type = MgEmployeeType.find_or_create_by!(
              employee_type: employee_data[:emp_type] || 'Default',
              mg_school_id: school_id,
              is_deleted: false
            )
            employee_position = MgEmployeePosition.find_or_create_by!(
              position_name: employee_data[:emp_profile] || 'Default',
              mg_school_id: school_id,
              is_deleted: false
            )
            employee_grade = MgEmployeeGrade.find_or_create_by!(
              grade_name: employee_data[:emp_grade] || 'Default',
              mg_school_id: school_id,
              is_deleted: false
            )
  
            # Generate username
            school_subdomain = MgSchool.find_by(id: school_id, is_deleted: false)&.subdomain
            highest_user = MgUser.where("user_name LIKE ?", "#{school_subdomain}E%")
                                 .order(created_at: :desc).pluck(:user_name).first
            username = if highest_user&.casecmp?("#{school_subdomain}sim")
                         "#{school_subdomain}E1"
                       else
                         highest_number = highest_user.to_s.scan(/\d+/).last.to_i
                         "#{school_subdomain}E#{highest_number + 1}"
                       end
  
            # Create User
            user = MgUser.create!(
              user_name: username,
              first_name: employee_data[:first_name],
              middle_name: employee_data[:middle_name],
              last_name: employee_data[:last_name],
              email: employee_data[:email_id],
              password: 'employee123', # Default password
              user_type: "employee",
              mg_school_id: school_id,
              created_by: user_id,
              updated_by: user_id,
              created_at: current_time,
              updated_at: current_time
            )
  
            MgPhone.create!(
              phone_number: employee_data[:mobile_number],
              phone_type: 'mobile',
              notification: true,
              subscription: true,
              mg_user_id: user.id,
              mg_school_id: school_id,
              is_deleted: false,
              created_by: user_id,
              updated_by: user_id,
              created_at: current_time,
              updated_at: current_time
            )
            
            # Create Employee
            employee = MgEmployee.create!(
              mg_user_id: user.id,
              mg_employee_type_id: employee_type.id,
              mg_employee_category_id: employee_category.id,
              mg_employee_position_id: employee_position.id,
              mg_employee_department_id: employee_department.id,
              mg_employee_grade_id: employee_grade.id,
              max_no_of_class: employee_data[:max_class_per_day],
              hobby: employee_data[:hobby],
              extra_curricular: employee_data[:extra_curricular],
              sport_activity: employee_data[:sport_activity],
              employee_number: username,
              joining_date: employee_data[:employee_joining_date],
              first_name: employee_data[:first_name],
              middle_name: employee_data[:middle_name],
              last_name: employee_data[:last_name],
              gender: employee_data[:gender],
              job_title: employee_data[:job_title],
              qualification: employee_data[:qualification],
              date_of_birth: employee_data[:date_of_birth],
              marital_status: employee_data[:marital_status],
              father_name: employee_data[:father_name],
              mother_name: employee_data[:mother_name],
              blood_group: employee_data[:blood_group],
              is_referred: employee_data[:is_referred],
              referred_by: employee_data[:referred_by],
              adharnumber: employee_data[:aadhar_number],
              designation: employee_data[:emp_profile],
              is_ltc_applicable: employee_data[:ltc_applicable],
              last_working_day: employee_data[:last_work_day],
              experience_year: employee_data[:t_year_exp],
              experience_month: employee_data[:t_mon_exp],
              status: employee_data[:status],
              is_archive: false,
              is_deleted: false,
              emergency_contact_name: employee_data[:emergency_contact_name],
              emergency_contact_number: employee_data[:emergency_contact_number],
              language: employee_data[:language],
              nationality: employee_data[:nationality],
              mg_school_id: school_id,
              created_by: user_id,
              updated_by: user_id,
              created_at: current_time,
              updated_at: current_time
            )
  
            # Create Bank Details
            MgBankAccountDetail.create!(
              bank_name: employee_data[:bank_name],
              account_number: employee_data[:account_number],
              ifs_code: employee_data[:ifs_code],
              mg_school_id: school_id,
              mg_employee_id: employee.id,
              is_deleted: false,
              created_by: user_id,
              updated_by: user_id,
              created_at: current_time,
              updated_at: current_time
            )
  
            # Add to successful creation list
            created_employees << { 
              row: row_number, 
              name: "#{employee_data[:first_name]} #{employee_data[:last_name]} #{username}",
              username: username 
            }
          rescue StandardError => e
            # Handle individual record errors
            failed_employees << { row: row_number, name: "#{employee_data[:first_name]} #{employee_data[:last_name]}", error: e.message }
            next
          end
        end
      rescue StandardError => e
        # Handle transaction-level errors
        render_json_response({
          status: 'error',
          message: 'An unexpected error occurred during processing.',
          data: {
            created: created_employees,
            duplicate: failed_employees
          }
        }, :unprocessable_entity) and return
      end
    end
  
    # Prepare the response
    if failed_employees.any?
      render_json_response({
        status: 'error',
        message: 'Some employees could not be processed. No employees were created.',
        data: {
          created: created_employees,
          duplicate: failed_employees
        }
      }, :unprocessable_entity)
    else
      render_json_response({
        status: 'success',
        message: 'All employees processed successfully',
        data: {
          created: created_employees
        }
      }, :ok)
    end
  rescue StandardError => e
    # Handle unexpected errors
    render_json_response({
      status: 'error',
      message: e.message,
      data: { created: [], duplicate: failed_employees }
    }, :unprocessable_entity)
  end
  
  
  def upload_assign_class_teacher 
    
  end 
  
  
  
  



end
  
  
 