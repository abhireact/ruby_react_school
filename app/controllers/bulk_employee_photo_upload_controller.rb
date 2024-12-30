class BulkEmployeePhotoUploadController < ApplicationController
    include JsonResponseHelper # Include the concern
    
    layout "mindcom"
    
    def bulk_photo_upload
      school = MgSchool.find(session[:current_user_school_id])
      
      if params[:employeeFiles].present?
        emp_photo_names = params[:employeeFiles]
        begin
          unavailable_employee = []
          available_employee = []
          error_details = []  # To store detailed error messages
          
          emp_photo_names.each do |emp_file|
            photo_name = emp_file.original_filename.to_s
            employee_number = photo_name.split(".")[0].upcase
            employee_check = MgEmployee.find_by(employee_number: employee_number, is_deleted: 0, is_archive: 0, mg_school_id: school.id)
            
            if employee_check.present?
              right_file = photo_name
              directory = "IMAGES/DATA/Employee/#{school.subdomain.to_s}" # Adjust directory as needed
              path = File.join(directory, photo_name)
              File.open(path, "wb") { |f| f.write(emp_file.read) }
              photo_file = File.open(path)
              employee_check.update(photo: photo_file)
              available_employee << right_file
            else
              unavailable_employee << photo_name
              error_details << {
                photo_name: photo_name,
                error: "Employee number #{employee_number} not found or inactive."
              }
            end
          end
          
          if error_details.any?
            # Using the render_json_response helper method for error handling
            render_json_response({
              status: "error",
              message: "Some employee photos were not uploaded due to errors.",
              available_photos: available_employee,
              unavailable_photos: unavailable_employee,
              errors: error_details
            }, :unprocessable_entity)
          else
            # Using the render_json_response helper method for success response
            render_json_response({
              status: "success",
              message: "Photos processed successfully.",
              available_photos: available_employee,
              unavailable_photos: unavailable_employee
            }, :ok)
          end
        rescue Exception => e
          # Using the render_json_response helper method for exception handling
          render_json_response({
            status: "error",
            message: "Something went wrong. Photos were not uploaded!",
            error: e.message
          }, :unprocessable_entity)
        end
      else
        # Using the render_json_response helper method when no files are provided
        render_json_response({
          status: "error",
          message: "No files were provided for upload."
        }, :bad_request)
      end
    end
  end
  