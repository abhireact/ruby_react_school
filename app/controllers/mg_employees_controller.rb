class MgEmployeesController < ApplicationController
    include JsonResponseHelper # Include the concern
        
    layout "mindcom"
  
    def index
      if session[:class_table].present?
        @table_array = session[:class_table]
        @course_id = session[:table_array_class_id]
        session[:table_array_employee_id] = nil
        session[:class_table] = nil
      end
  
      @classes = MgCourse.where(mg_school_id: session[:current_user_school_id], is_deleted: 0).order(:id)
      @batches = MgBatch.where(mg_school_id: session[:current_user_school_id], is_deleted: 0)
      @academic_year_data = MgTimeTable.where(mg_school_id: session[:current_user_school_id], is_deleted: 0).order(:id)
      @wings_data = MgWing.where(mg_school_id: session[:current_user_school_id], is_deleted: 0)
      @sectionClass = MgBatch.where(is_deleted: 0, mg_school_id: session[:current_user_school_id])
                             .joins(:mg_course)
                             .pluck(
                               Arel.sql("CONCAT(mg_courses.course_name, '-', mg_batches.name)"),
                               Arel.sql("mg_batches.id"),
                               Arel.sql("mg_batches.mg_employee_id"),
                               Arel.sql("mg_courses.mg_time_table_id"),
                               Arel.sql("mg_courses.mg_wing_id"),
                               Arel.sql("mg_courses.id")
                             ).map do |name, mg_batch_id,mg_employee_id, mg_time_table_id, mg_wing_id, mg_course_id|
                               {
                                 name: name,
                                 mg_batch_id: mg_batch_id,
                                 mg_employee_id:mg_employee_id,
                                 mg_time_table_id: mg_time_table_id,
                                 mg_wing_id: mg_wing_id,
                                 mg_course_id: mg_course_id
                               }
                             end
                             @employees_data = MgEmployee
                             .where(is_deleted: 0, mg_school_id: session[:current_user_school_id], mg_employee_category_id: 2, is_archive: 0)
                             .joins("INNER JOIN mg_users ON mg_users.id = mg_employees.mg_user_id")
                             .joins("INNER JOIN mg_employee_departments ON mg_employee_departments.id = mg_employees.mg_employee_department_id")
                             .joins("INNER JOIN mg_addresses AS temporary_addresses ON temporary_addresses.mg_user_id = mg_employees.mg_user_id AND temporary_addresses.address_type = 'Temporary'")
                             .joins("INNER JOIN mg_addresses AS permanent_addresses ON permanent_addresses.mg_user_id = mg_employees.mg_user_id AND permanent_addresses.address_type = 'Permanent'")
                             .select("mg_employees.*, 
                                      mg_users.user_name AS user_name, 
                                      mg_employee_departments.department_name AS department_name, 
                                      temporary_addresses.address_line1 AS temporary_address_line1, 
                                      temporary_addresses.address_line2 AS temporary_address_line2, 
                                      temporary_addresses.city AS temporary_city, 
                                      temporary_addresses.state AS temporary_state, 
                                      temporary_addresses.country AS temporary_country, 
                                      temporary_addresses.pin_code AS temporary_pin_code,
                                      permanent_addresses.address_line1 AS permanent_address_line1, 
                                      permanent_addresses.address_line2 AS permanent_address_line2, 
                                      permanent_addresses.city AS permanent_city, 
                                      permanent_addresses.state AS permanent_state, 
                                      permanent_addresses.country AS permanent_country, 
                                      permanent_addresses.pin_code AS permanent_pin_code")
         
                           
                             @archive_data = MgEmployee
                             .where(is_deleted: 0, mg_school_id: session[:current_user_school_id], mg_employee_category_id: 2, is_archive: 1)
                             .joins("INNER JOIN mg_users ON mg_users.id = mg_employees.mg_user_id")
                             .joins("INNER JOIN mg_employee_departments ON mg_employee_departments.id = mg_employees.mg_employee_department_id")
                             .select("mg_employees.*, mg_users.user_name AS user_name, mg_employee_departments.department_name AS department_name")
                           
                        
       @reasons_data =MgArchiveReason.where(is_deleted: 0,user_type:"Employee").pluck(:reason_name,:id)
     
       @employee_department=MgEmployeeDepartment.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
       @employee_category = MgEmployeeCategory.where(is_deleted: 0);

       @employee_type = MgEmployeeType.where(is_deleted: 0, mg_school_id: session[:current_user_school_id])

       @employee_position = MgEmployeePosition.where(is_deleted: 0, mg_school_id: session[:current_user_school_id])

       @employee_grade = MgEmployeeGrade.where(is_deleted: 0, mg_school_id: session[:current_user_school_id])

   
   
    
        
    
      
      
       @react_data = {
        section_class: @sectionClass,
        classes: @classes,
        batches: @batches,
        academic_year_data:@academic_year_data,
        wings_data:@wings_data,
        employees_data:@employees_data,
        reasons_data:@reasons_data,
        employee_department:@employee_department,
        employee_category:@employee_category,
        employee_type:@employee_type,
        employee_position:@employee_position,
        employee_grade:@employee_grade,
        archive_data:@archive_data
      }
    end

    def create_employee
      current_time = Time.now
      school_id = session[:current_user_school_id]
      user_id = session[:user_id]
    
      # Validate input (expecting a single employee object instead of an array)
    
      begin
    
      # Check for existing mobile number in MgPhone
    existing_phone = MgPhone.find_by(phone_number: params[:mobile_number], is_deleted: false)
    if existing_phone
      return render_json_response({
        status: 'error',
        message: "Mobile number already exists: #{params[:mobile_number]}"
      }, :unprocessable_entity)
    end

    # Check for existing email id in User
    # existing_user = MgUser.find_by(email: params[:email_id], is_deleted: false)
    # if existing_user
    #   return render_json_response({
    #     status: 'error',
    #     message: "Email ID already exists: #{params[:email_id]}"
    #   }, :unprocessable_entity)
    # end
     
        
    
        # Find required related entities
        employee_department = MgEmployeeDepartment.find_by(
          department_name: params[:emp_department],
          mg_school_id: school_id,
          is_deleted: false
        )
        return render_json_response({
          status: 'error',
          message: "Employee department not found: #{params[:emp_department]}"
        }, :unprocessable_entity) unless employee_department
    
        employee_category = MgEmployeeCategory.find_by(
          category_name: params[:emp_category],
          is_deleted: false
        )
        return render_json_response({
          status: 'error',
          message: "Employee category not found: #{params[:emp_category]}"
        }, :unprocessable_entity) unless employee_category
    
        employee_type = MgEmployeeType.find_by(
          employee_type: params[:emp_type],
          mg_school_id: school_id,
          is_deleted: false
        )
        return render_json_response({
          status: 'error',
          message: "Employee type not found: #{params[:emp_type]}"
        }, :unprocessable_entity) unless employee_type
    
        employee_position = MgEmployeePosition.find_by(
          position_name: params[:emp_profile],
          mg_school_id: school_id,
          is_deleted: false
        )
        return render_json_response({
          status: 'error',
          message: "Employee position not found: #{params[:emp_profile]}"
        }, :unprocessable_entity) unless employee_position
    
        employee_grade = MgEmployeeGrade.find_by(
          grade_name: params[:emp_grade],
          mg_school_id: school_id,
          is_deleted: false
        )
        return render_json_response({
          status: 'error',
          message: "Employee grade not found: #{params[:emp_grade]}"
        }, :unprocessable_entity) unless employee_grade
    
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
          first_name: params[:first_name],
          middle_name: params[:middle_name],
          last_name: params[:last_name],
          email: params[:email_id],
          password: 'employee123', # Use a dynamically generated password
          user_type: "employee",
          mg_school_id: school_id,
          created_by: user_id,
          updated_by: user_id,
          created_at: current_time,
          updated_at: current_time,
          is_deleted: false,
        )
    
        # Create Phone record
        MgPhone.create!(
          phone_number: params[:mobile_number],
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
    
        # Create Addresses
        MgAddress.create!(
          mg_user_id: user.id,
          mg_school_id: school_id,
          address_line1: params[:temporary_address_line1],
          address_line2: params[:temporary_address_line2],
          address_type: "Temporary",
          city: params[:temporary_city],
          state: params[:temporary_state],
          country: params[:temporary_country],
          pin_code: params[:temporary_pin_code],
          notification: true,
          subscription: true,
          is_deleted: false,
          created_by: user_id,
          updated_by: user_id,
          created_at: current_time,
          updated_at: current_time
        )
    
        MgAddress.create!(
          mg_user_id: user.id,
          mg_school_id: school_id,
          address_line1: params[:permanent_address_line1],
          address_line2: params[:permanent_address_line2],
          address_type: "Permanent",
          city: params[:permanent_city],
          state: params[:permanent_state],
          country: params[:permanent_country],
          pin_code: params[:permanent_pin_code],
          notification: true,
          subscription: true,
          is_deleted: false,
          created_by: user_id,
          updated_by: user_id,
          created_at: current_time,
          updated_at: current_time
        )
    
        # Create Employee
        MgEmployee.create!(
          mg_user_id: user.id,
          mg_employee_type_id: employee_type.id,
          mg_employee_category_id: employee_category.id,
          mg_employee_position_id: employee_position.id,
          mg_employee_department_id: employee_department.id,
          mg_employee_grade_id: employee_grade.id,
          max_no_of_class: params[:max_class_per_day],
          hobby: params[:hobby],
          extra_curricular: params[:extra_curricular],
          sport_activity: params[:sport_activity],
          employee_number: username,
          joining_date: params[:employee_joining_date],
          first_name: params[:first_name],
          middle_name: params[:middle_name],
          last_name: params[:last_name],
          gender: params[:gender],
          job_title: params[:job_title],
          qualification: params[:qualification],
          date_of_birth: params[:date_of_birth],
          marital_status: params[:marital_status],
          father_name: params[:father_name],
          mother_name: params[:mother_name],
          blood_group: params[:blood_group],
          is_referred: params[:is_referred],
          referred_by: params[:referred_by],
          adharnumber: params[:aadhar_number],
          designation: params[:emp_profile],
          is_ltc_applicable: params[:ltc_applicable],
          last_working_day: params[:last_work_day],
          experience_year: params[:t_year_exp],
          experience_month: params[:t_mon_exp],
          status: params[:status],
          is_archive: false,
          is_deleted: false,
          emergency_contact_name: params[:emergency_contact_name],
          emergency_contact_number: params[:emergency_contact_number],
          language: params[:language],
          nationality: params[:nationality],
          mg_school_id: school_id,
          created_by: user_id,
          updated_by: user_id,
          created_at: current_time,
          updated_at: current_time
        )
    
        # Create Bank Details
        MgBankAccountDetail.create!(
          bank_name: params[:bank_name],
          account_number: params[:account_number],
          ifs_code: params[:ifs_code],
          mg_school_id: school_id,
          mg_employee_id: user.id,
          is_deleted: false,
          created_by: user_id,
          updated_by: user_id,
          created_at: current_time,
          updated_at: current_time
        )
    
        # Successful response
        render_json_response({
          status: 'success',
          message: "Employee created successfully.",
          data: { username: username }
        }, :ok)
    
      rescue StandardError => e
        # Handle unexpected errors
        render_json_response({
          status: 'error',
          message: "An unexpected error occurred: #{e.message}",
          data: {}
        }, :unprocessable_entity)
      end
    end
    
    def get_employee
      begin
        school_id = session[:current_user_school_id]
        employee_id = params[:id]
    
        # Fetch the employee record
        employee = MgEmployee.find_by(id: employee_id, mg_school_id: school_id, is_deleted: false)
        return render_json_response({
          status: 'error',
          message: "Employee not found with ID: #{employee_id}"
        }, :not_found) unless employee
    
        # Fetch associated details
        user = MgUser.find_by(id: employee.mg_user_id, is_deleted: false)
        department = MgEmployeeDepartment.find_by(id: employee.mg_employee_department_id, is_deleted: false)
        category = MgEmployeeCategory.find_by(id: employee.mg_employee_category_id, is_deleted: false)
        employee_type = MgEmployeeType.find_by(id: employee.mg_employee_type_id, is_deleted: false)
        position = MgEmployeePosition.find_by(id: employee.mg_employee_position_id, is_deleted: false)
        grade = MgEmployeeGrade.find_by(id: employee.mg_employee_grade_id, is_deleted: false)
        temporary_address = MgAddress.find_by(mg_user_id: user&.id, address_type: "Temporary", is_deleted: false)
        permanent_address = MgAddress.find_by(mg_user_id: user&.id, address_type: "Permanent", is_deleted: false)
        phone = MgPhone.find_by(mg_user_id:employee.mg_user_id, is_deleted: false)
        bank_details = MgBankAccountDetail.find_by(mg_employee_id:  employee.mg_user_id, is_deleted: false)
    
        # Compile the data
        employee_data = {
          first_name: employee.first_name,
          middle_name: employee.middle_name,
          last_name: employee.last_name,
          date_of_birth: employee.date_of_birth,
          employee_joining_date: employee.joining_date,
          last_work_day: employee.last_working_day,
          gender: employee.gender,
          job_title: employee.job_title,
          qualification: employee.qualification,
          max_class_per_day: employee.max_no_of_class,
          t_year_exp: employee.experience_year,
          t_mon_exp: employee.experience_month,
          aadhar_number: employee.adharnumber,
          father_name: employee.father_name,
          mother_name: employee.mother_name,
          marital_status: employee.marital_status,
          blood_group: employee.blood_group,
          emp_department: department&.department_name || "",
          emp_category: category&.category_name || "",
          emp_type: employee_type&.employee_type || "",
          emp_profile: position&.position_name || "",
          emp_grade: grade&.grade_name || "",
          hobby: employee.hobby,
          ltc_applicable: employee.is_ltc_applicable,
          is_referred: employee.is_referred,
          referred_by: employee.referred_by,
          status: employee.status,
          bank_name: bank_details&.bank_name || "",
          account_number: bank_details&.account_number || "",
          ifs_code: bank_details&.ifs_code || "",
          mobile_number: phone&.phone_number || "",
          email_id: user&.email || "",
          emergency_contact_number: employee.emergency_contact_number,
          emergency_contact_name: employee.emergency_contact_name,
          temporary_address_line1: temporary_address&.address_line1 || "",
          temporary_address_line2: temporary_address&.address_line2 || "",
          temporary_city: temporary_address&.city || "",
          temporary_state: temporary_address&.state || "",
          temporary_country: temporary_address&.country || "",
          temporary_pin_code: temporary_address&.pin_code || "",
          permanent_address_line1: permanent_address&.address_line1 || "",
          permanent_address_line2: permanent_address&.address_line2 || "",
          permanent_city: permanent_address&.city || "",
          permanent_state: permanent_address&.state || "",
          permanent_country: permanent_address&.country || "",
          permanent_pin_code: permanent_address&.pin_code || "",
          language: employee.language,
          nationality: employee.nationality,
          extra_curricular: employee.extra_curricular,
          sport_activity: employee.sport_activity,
          employee_number: employee.employee_number
        }
    
        # Successful response
        render_json_response({
          status: 'success',
          message: 'Employee details retrieved successfully.',
          data: employee_data
        }, :ok)
      rescue StandardError => e
        # Handle unexpected errors
        Rails.logger.error "Error retrieving employee: #{e.message}"
        render_json_response({
          status: 'error',
          message: "An unexpected error occurred: #{e.message}",
          data: {}
        }, :unprocessable_entity)
      end
    end
    def get_all_employees
      begin
        school_id = session[:current_user_school_id]
    
        # Fetch all employees for the current school
        employees = MgEmployee.where(mg_school_id: school_id, is_deleted: false)
    
        # Return an error if no employees are found
        if employees.empty?
          return render_json_response({
            status: 'error',
            message: "No employees found in the system.",
            data: {}
          }, :not_found)
        end
    
        # Initialize an array to hold the employee data
        employees_data = []
    
        # Loop through each employee to gather their details
        employees.each do |employee|
          user = MgUser.find_by(id: employee.mg_user_id, is_deleted: false)
          department = MgEmployeeDepartment.find_by(id: employee.mg_employee_department_id, is_deleted: false)
          category = MgEmployeeCategory.find_by(id: employee.mg_employee_category_id, is_deleted: false)
          employee_type = MgEmployeeType.find_by(id: employee.mg_employee_type_id, is_deleted: false)
          position = MgEmployeePosition.find_by(id: employee.mg_employee_position_id, is_deleted: false)
          grade = MgEmployeeGrade.find_by(id: employee.mg_employee_grade_id, is_deleted: false)
          temporary_address = MgAddress.find_by(mg_user_id: user&.id, address_type: "Temporary", is_deleted: false)
          permanent_address = MgAddress.find_by(mg_user_id: user&.id, address_type: "Permanent", is_deleted: false)
          phone = MgPhone.find_by(mg_user_id: employee.mg_user_id, is_deleted: false)
          bank_details = MgBankAccountDetail.find_by(mg_employee_id: employee.mg_user_id, is_deleted: false)
    
          # Collect the data for each employee
          employees_data << {
            id:employee.id,
            first_name: employee.first_name,
            middle_name: employee.middle_name,
            last_name: employee.last_name,
            date_of_birth: employee.date_of_birth,
            employee_joining_date: employee.joining_date,
            last_work_day: employee.last_working_day,
            gender: employee.gender,
            job_title: employee.job_title,
            qualification: employee.qualification,
            max_class_per_day: employee.max_no_of_class,
            t_year_exp: employee.experience_year,
            t_mon_exp: employee.experience_month,
            aadhar_number: employee.adharnumber,
            father_name: employee.father_name,
            mother_name: employee.mother_name,
            marital_status: employee.marital_status,
            blood_group: employee.blood_group,
            emp_department: department&.department_name || "",
            emp_category: category&.category_name || "",
            emp_type: employee_type&.employee_type || "",
            emp_profile: position&.position_name || "",
            emp_grade: grade&.grade_name || "",
            hobby: employee.hobby,
            ltc_applicable: employee.is_ltc_applicable,
            is_referred: employee.is_referred,
            referred_by: employee.referred_by,
            status: employee.status,
            bank_name: bank_details&.bank_name || "",
            account_number: bank_details&.account_number || "",
            ifs_code: bank_details&.ifs_code || "",
            mobile_number: phone&.phone_number || "",
            email_id: user&.email || "",
            emergency_contact_number: employee.emergency_contact_number,
            emergency_contact_name: employee.emergency_contact_name,
            temporary_address_line1: temporary_address&.address_line1 || "",
            temporary_address_line2: temporary_address&.address_line2 || "",
            temporary_city: temporary_address&.city || "",
            temporary_state: temporary_address&.state || "",
            temporary_country: temporary_address&.country || "",
            temporary_pin_code: temporary_address&.pin_code || "",
            permanent_address_line1: permanent_address&.address_line1 || "",
            permanent_address_line2: permanent_address&.address_line2 || "",
            permanent_city: permanent_address&.city || "",
            permanent_state: permanent_address&.state || "",
            permanent_country: permanent_address&.country || "",
            permanent_pin_code: permanent_address&.pin_code || "",
            language: employee.language,
            nationality: employee.nationality,
            extra_curricular: employee.extra_curricular,
            sport_activity: employee.sport_activity,
            employee_number: employee.employee_number
          }
        end
    
        # Successful response with all employee data
        render_json_response({
          status: 'success',
          message: 'All employee details retrieved successfully.',
          data: employees_data
        }, :ok)
      rescue StandardError => e
        # Handle unexpected errors
        Rails.logger.error "Error retrieving employees: #{e.message}"
        render_json_response({
          status: 'error',
          message: "An unexpected error occurred: #{e.message}",
          data: {}
        }, :unprocessable_entity)
      end
    end
    
    def delete_employee
      begin
        school_id = session[:current_user_school_id]
        employee_id = params[:id]
        
        # Fetch the employee record
        employee = MgEmployee.find_by(id: employee_id, mg_school_id: school_id, is_deleted: false)
        
        # If employee is not found, return an error response
        return render_json_response({
          status: 'error',
          message: "Employee not found with ID: #{employee_id}"
        }, :not_found) unless employee
        
        # Set employee and related records to soft delete
        current_time = Time.now
        user_id = session[:user_id]
    
        # Soft delete related records: Addresses, Phone, Bank Account Details, etc.
        MgAddress.where(mg_user_id: employee.mg_user_id).update_all(is_deleted: true, updated_by: user_id, updated_at: current_time)
        MgPhone.where(mg_user_id: employee.mg_user_id).update_all(is_deleted: true, updated_by: user_id, updated_at: current_time)
        MgBankAccountDetail.where(mg_employee_id: employee.id).update_all(is_deleted: true, updated_by: user_id, updated_at: current_time)
        
        # Soft delete the employee record itself
        employee.update!(is_deleted: true, updated_by: user_id, updated_at: current_time)
    
        # Soft delete the associated user (this will affect all other dependencies related to the user)
        MgUser.where(id: employee.mg_user_id).update_all(is_deleted: true, updated_by: user_id, updated_at: current_time)
    
        # Return a success response
        render_json_response({
          status: 'success',
          message: "Employee   Deleted Successfully."
        }, :ok)
      rescue StandardError => e
        # Handle unexpected errors
        Rails.logger.error "Error deleting employee: #{e.message}"
        render_json_response({
          status: 'error',
          message: "An unexpected error occurred: #{e.message}",
          data: {}
        }, :unprocessable_entity)
      end
    end
    
    
    def update_employee
      begin
        current_time = Time.now
        school_id = session[:current_user_school_id]
        user_id = session[:user_id]
        employee_id = params[:id]
    
        # Find the employee record
        employee = MgEmployee.find_by(id: employee_id, mg_school_id: school_id, is_deleted: false)
        return render_json_response({
          status: 'error',
          message: "Employee not found with ID: #{employee_id}"
        }, :not_found) unless employee
    
        # Find or validate related entities
        employee_department = MgEmployeeDepartment.find_by(
          department_name: params[:emp_department],
          mg_school_id: school_id,
          is_deleted: false
        )
        return render_json_response({
          status: 'error',
          message: "Employee department not found: #{params[:emp_department]}"
        }, :unprocessable_entity) unless employee_department
    
        employee_category = MgEmployeeCategory.find_by(
          category_name: params[:emp_category],
          is_deleted: false
        )
        return render_json_response({
          status: 'error',
          message: "Employee category not found: #{params[:emp_category]}"
        }, :unprocessable_entity) unless employee_category
    
        employee_type = MgEmployeeType.find_by(
          employee_type: params[:emp_type],
          mg_school_id: school_id,
          is_deleted: false
        )
        return render_json_response({
          status: 'error',
          message: "Employee type not found: #{params[:emp_type]}"
        }, :unprocessable_entity) unless employee_type
    
        employee_position = MgEmployeePosition.find_by(
          position_name: params[:emp_profile],
          mg_school_id: school_id,
          is_deleted: false
        )
        return render_json_response({
          status: 'error',
          message: "Employee position not found: #{params[:emp_profile]}"
        }, :unprocessable_entity) unless employee_position
    
        employee_grade = MgEmployeeGrade.find_by(
          grade_name: params[:emp_grade],
          mg_school_id: school_id,
          is_deleted: false
        )
        return render_json_response({
          status: 'error',
          message: "Employee grade not found: #{params[:emp_grade]}"
        }, :unprocessable_entity) unless employee_grade
    
        # Update User details
        user = MgUser.find_by(id: employee.mg_user_id, is_deleted: false)
        user.update!(
          first_name: params[:first_name],
          middle_name: params[:middle_name],
          last_name: params[:last_name],
          email: params[:email_id],
          updated_by: user_id,
          updated_at: current_time
        )
    
 
    # Update or create Phone record
    phone = MgPhone.find_or_initialize_by(mg_user_id: user.id)
    phone.update!(
      phone_number: params[:mobile_number],
      updated_by: user_id,
      updated_at: current_time
    )

    # Update or create Addresses
    temporary_address = MgAddress.find_or_initialize_by(mg_user_id: user.id, address_type: "Temporary")
    temporary_address.update!(
      address_line1: params[:temporary_address_line1],
      address_line2: params[:temporary_address_line2],
      city: params[:temporary_city],
      state: params[:temporary_state],
      country: params[:temporary_country],
      pin_code: params[:temporary_pin_code],
      updated_by: user_id,
      updated_at: current_time,
      mg_school_id: school_id,
      is_deleted: false
    )

    permanent_address = MgAddress.find_or_initialize_by(mg_user_id: user.id, address_type: "Permanent")
    permanent_address.update!(
      address_line1: params[:permanent_address_line1],
      address_line2: params[:permanent_address_line2],
      city: params[:permanent_city],
      state: params[:permanent_state],
      country: params[:permanent_country],
      pin_code: params[:permanent_pin_code],
      updated_by: user_id,
      updated_at: current_time,
      mg_school_id: school_id,
      is_deleted: false
    )
    
        # Update Employee record
        employee.update!(
          mg_employee_type_id: employee_type.id,
          mg_employee_category_id: employee_category.id,
          mg_employee_position_id: employee_position.id,
          mg_employee_department_id: employee_department.id,
          mg_employee_grade_id: employee_grade.id,
          max_no_of_class: params[:max_class_per_day],
          hobby: params[:hobby],
          extra_curricular: params[:extra_curricular],
          sport_activity: params[:sport_activity],
          joining_date: params[:employee_joining_date],
          first_name: params[:first_name],
          middle_name: params[:middle_name],
          last_name: params[:last_name],
          gender: params[:gender],
          job_title: params[:job_title],
          qualification: params[:qualification],
          date_of_birth: params[:date_of_birth],
          marital_status: params[:marital_status],
          father_name: params[:father_name],
          mother_name: params[:mother_name],
          blood_group: params[:blood_group],
          is_referred: params[:is_referred],
          referred_by: params[:referred_by],
          adharnumber: params[:aadhar_number],
          designation: params[:emp_profile],
          is_ltc_applicable: params[:ltc_applicable],
          last_working_day: params[:last_work_day],
          experience_year: params[:t_year_exp],
          experience_month: params[:t_mon_exp],
          status: params[:status],
          emergency_contact_name: params[:emergency_contact_name],
          emergency_contact_number: params[:emergency_contact_number],
          language: params[:language],
          nationality: params[:nationality],
          updated_by: user_id,
          updated_at: current_time
        )
    
     # Update or create Bank Details
     bank_details = MgBankAccountDetail.find_or_initialize_by(mg_employee_id: employee.id)
     bank_details.update!(
       bank_name: params[:bank_name],
       account_number: params[:account_number],
       ifs_code: params[:ifs_code],
       updated_by: user_id,
       updated_at: current_time,
       mg_school_id: school_id,
       is_deleted: false
     )
        # Return success response
        render_json_response({
          status: 'success',
          message: "Employee updated successfully.",
          data: { employee_id: employee.id }
        }, :ok)
    
      rescue ActiveRecord::RecordNotFound => e
        render_json_response({
          status: 'error',
          message: "Record not found: #{e.message}",
          data: {}
        }, :not_found)
      rescue StandardError => e
        Rails.logger.error "Error updating employee: #{e.message}"
        render_json_response({
          status: 'error',
          message: "An unexpected error occurred: #{e.message}",
          data: {}
        }, :unprocessable_entity)
      end
    end
    
    

end
