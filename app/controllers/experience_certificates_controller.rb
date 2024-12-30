class ExperienceCertificatesController < ApplicationController
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
                             .select("mg_employees.*, mg_users.user_name AS user_name, mg_employee_departments.department_name AS department_name")
                             @archive_data = MgEmployee
                             .where(is_deleted: 0, mg_school_id: session[:current_user_school_id], mg_employee_category_id: 2, is_archive: 1)
                             .joins("INNER JOIN mg_users ON mg_users.id = mg_employees.mg_user_id")
                             .joins("INNER JOIN mg_employee_departments ON mg_employee_departments.id = mg_employees.mg_employee_department_id")
                             .select("mg_employees.*, mg_users.user_name AS user_name, mg_employee_departments.department_name AS department_name")
                           
                        
       @reasons_data =MgArchiveReason.where(is_deleted: 0,user_type:"Employee").pluck(:reason_name,:id)
       @employee_department=MgEmployeeDepartment.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:department_name,:id)
                           
      
   
   
    
        
    
      @react_data = {
        section_class: @sectionClass,
        classes: @classes,
        batches: @batches,
        academic_year_data:@academic_year_data,
        wings_data:@wings_data,
        employees_data:@employees_data,
        reasons_data:@reasons_data,
        employee_department:@employee_department,
        archive_data:@archive_data
      }
    end


    def issue_certificates
      employee_id = params[:id]
      @employee = MgEmployee.find_by(id: employee_id, is_deleted: 0, mg_school_id: session[:current_user_school_id])
    
      if @employee.present?
        emp_number = @employee.employee_number
        first_name = @employee.first_name
        last_name = @employee.last_name
        middle_name = @employee.middle_name
        full_name = "#{first_name} #{middle_name.to_s} #{last_name}"
    
        experience_certificate = MgCertificateTracking.find_by(
          mg_employee_id: employee_id,
          certificate_type: "EXPERIENCE",
          is_deleted: 0,
          mg_school_id: session[:current_user_school_id]
        )
    
        certificate_details = if experience_certificate.present?
          {
            date_of_issue: experience_certificate.date_of_issue&.strftime("%d/%m/%Y"),
            issued_times: experience_certificate.issued_times
          }
        else
          {
        date_of_issue:"",
        issued_times:""
          }
        end
    
        render json: {
          employee: {
            employee_number: emp_number,
            full_name: full_name
          },
          certificate: certificate_details
        }
      else
        render json: { error: "Employee not found or deleted" }, status: :not_found
      end
    end

    def show_employee_certificate
    
    
      if params[:id].present?
        employee_id = params[:id]
        employee_exp_certificate = MgEmployeeExperienceCertificate.find_by(
          is_deleted: 0,
          mg_school_id: session[:current_user_school_id],
          mg_employee_id: employee_id
        )
    
        if employee_exp_certificate.present?
          render json: {
            success: true,
            certificate: {
              id: employee_exp_certificate.id,
              employee_id: employee_exp_certificate.mg_employee_id,
              school_id: employee_exp_certificate.mg_school_id,
              title: employee_exp_certificate.title,
              employee_name: employee_exp_certificate.employee_name,
              guardian_title: employee_exp_certificate.guardian_title,
              guardian_name: employee_exp_certificate.guardian_name,
              cnic_number: employee_exp_certificate.cnic_number,
              subjects: employee_exp_certificate.subjects,
              designation: employee_exp_certificate.designation,
              joining_date: employee_exp_certificate.joining_date,
              last_working_date: employee_exp_certificate.last_working_date,
              title_sub: employee_exp_certificate.title_sub,
              title_sub1: employee_exp_certificate.title_sub1,
              title_sub2: employee_exp_certificate.title_sub2,
              created_at: employee_exp_certificate.created_at,
              updated_at: employee_exp_certificate.updated_at
            }
          }
        else
          render json: { success: false, error: "Experience certificate not found for the given employee." }, status: :not_found
        end
      else
        render json: { success: false, error: "Employee ID is missing." }, status: :bad_request
      end
    end


    def create_experience_certificate
      ActiveRecord::Base.transaction do
        # Initialize the certificate
        emp_exp_certfct = MgEmployeeExperienceCertificate.new(
          mg_school_id: session[:current_user_school_id],
          mg_employee_id: params[:employee_id],  # Corrected param
          title: params[:title],
          employee_name: params[:employee_name],  # Corrected param
          guardian_title: params[:guardian_title],  # Corrected param
          guardian_name: params[:guardian_name],
          subjects: params[:subjects],
          designation: params[:designation],
          joining_date: params[:joining_date],
          last_working_date: params[:last_working_date],  # Corrected param
          title_sub: params[:title_sub],
          title_sub1: params[:title_sub1],
          title_sub2: params[:title_sub2],
          is_deleted: 0,
          created_by: session[:user_id],
          updated_by: session[:user_id]
        )
    
        # Save the certificate
        if emp_exp_certfct.save
          render json: { message: "Employee experience certificate created successfully.", certificate: emp_exp_certfct }, status: :created
        else
          raise ActiveRecord::Rollback, emp_exp_certfct.errors.full_messages.join(", ")
        end
      end
    rescue ActiveRecord::Rollback => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
    
    def update_experience_certificate
      ActiveRecord::Base.transaction do
        # Find the existing certificate by its ID (assuming params[:id] is provided)
        @emp_exp_certfct = MgEmployeeExperienceCertificate.find_by(id: params[:id])
    
        # Check if the certificate exists
        if @emp_exp_certfct
          # Parse dates into Date objects if they are not already in the correct format
          joining_date = Date.strptime(params[:joining_date], "%d/%m/%Y") if params[:joining_date].present?
          last_working_date = Date.strptime(params[:last_working_date], "%d/%m/%Y") if params[:last_working_date].present?
    
          # Attempt to update the certificate attributes
          unless @emp_exp_certfct.update(
            mg_school_id: session[:current_user_school_id],
            mg_employee_id: params[:employee_id],
            title: params[:title],
            employee_name: params[:employee_name],
            guardian_title: params[:guardian_title],
            guardian_name: params[:guardian_name],
            cnic_number: params[:cnic_number],  # Ensure it's nullable in DB
            subjects: params[:subjects],
            designation: params[:designation],
            joining_date: joining_date,
            last_working_date: last_working_date,
            title_sub: params[:title_sub],
            title_sub1: params[:title_sub1],
            title_sub2: params[:title_sub2],
            updated_by: session[:user_id]
          )
            raise ActiveRecord::Rollback, "Failed to update employee experience certificate."
          end
    
          # If update is successful, render a success message
          render json: { message: "Employee experience certificate updated successfully.", certificate: @emp_exp_certfct }, status: :ok
        else
          # If the certificate is not found, return an error message
          render json: { error: "Employee experience certificate not found." }, status: :not_found
        end
      end
    rescue ActiveRecord::Rollback => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
    
    def track_and_generate_certificate
      certificate_type = "EXPERIENCE"
      mg_employee_id = params[:id]
    
      if mg_employee_id.present?
        @certificate = MgCertificateTracking.find_or_initialize_by(
          mg_employee_id: mg_employee_id,
          certificate_type: certificate_type,
          is_deleted: 0
        )
    
        if @certificate.new_record?
          @certificate.assign_attributes(
            mg_school_id: session[:current_user_school_id],
            issued_times: 1,
            date_of_issue: Date.current.strftime("%d/%m/%Y"),
            created_by: session[:user_id],
            updated_by: session[:user_id]
          )
    
          if @certificate.save
            render json: { success: true, message: "Certificate generated successfully", certificate: @certificate }, status: :created
          else
            render json: { success: false, message: "Failed to generate certificate", errors: @certificate.errors.full_messages }, status: :unprocessable_entity
          end
        else
          @certificate.increment!(:issued_times)
          render json: { success: true, message: "Certificate issuance count updated", certificate: @certificate }, status: :ok
        end
      else
        render json: { success: false, message: "Employee ID is required to generate the certificate" }, status: :bad_request
      end
    rescue => e
      render json: { success: false, message: e.message }, status: :internal_server_error
    end
    
    
    
    
    




    end
