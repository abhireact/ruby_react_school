class UploadExcelSetOneController < ApplicationController
  layout "mindcom"
  include JsonResponseHelper
  def template1_exists
    school_id = session[:current_user_school_id]
    
    # Perform checks for all the entities
    timetable_exists = MgTimeTable.exists?(is_deleted: 0, mg_school_id: school_id)
    wings_exists = MgWing.exists?(is_deleted: 0, mg_school_id: school_id)
    class_exists = MgCourse.exists?(mg_school_id: school_id, is_deleted: false)
    section_exists = MgBatch.exists?(is_deleted: 0, mg_school_id: school_id)
    accounts_exists = MgAccount.exists?(is_deleted: 0, mg_school_id: school_id)
    # Render the results as a JSON object
    render json: {
      timetable_exists: timetable_exists,
      wings_exists: wings_exists,
      class_exists: class_exists,
      section_exists: section_exists,
      accounts_exists: accounts_exists
    }
  end


# Accounts 
  def upload_accounts
    accounts = params[:data]
    current_time = Time.now
    school_id = session[:current_user_school_id]
    user_id = session[:user_id]

    # Step 1: Validate parameters
    unless accounts.is_a?(Array)
      render_json_response({
        status: 'error',
        message: 'Invalid data format. Expected an array of accounts.',
        data: {}
      }, :unprocessable_entity) and return
    end

    # Step 2: Initialize arrays to track results
    created_accounts = []
    duplicate_in_excel = []
    duplicate_accounts = []
    errors = []

    seen_accounts = Set.new # To track accounts already processed in this batch

    accounts.each_with_index do |account, index|
      mg_account_name = account[:mg_account_name]
      user_name = account[:user_name]

      # Step 3: Check for duplicate accounts within the incoming data (Excel file)
      if seen_accounts.include?(mg_account_name)
        duplicate_in_excel << {
          row: account[:row_number] || (index + 1),
          name: mg_account_name,  # Changed from 'mg_account_name' to 'name'
          error: "Duplicate Account '#{mg_account_name}' found in the uploaded data"
        }
      else
        seen_accounts.add(mg_account_name) # Mark this account as processed
      end

      # Step 4: Fetch MgUser based on school_id and user_name
      user_result = MgUser.find_by(mg_school_id: school_id, user_name: user_name, is_deleted: false)

      if user_result.blank?
        # Track invalid rows if no valid user is found
        errors << {
          row: account[:row_number] || (index + 1),
          name: mg_account_name,  # Changed from 'mg_account_name' to 'name'
          error: "Invalid User Name"
        }
      else
        # Step 5: Check for duplicate accounts in the database (same account_name and user_id)
        if MgAccount.exists?(mg_account_name: mg_account_name, mg_user_id: user_result.id, mg_school_id: school_id, is_deleted: false)
          # Push duplicate account data into a duplicate array with row number
          duplicate_accounts << {
            row: account[:row_number] || (index + 1),
            name: mg_account_name,  # Changed from 'mg_account_name' to 'name'
            error: "Account '#{mg_account_name}' already exists for this User"
          }
        else
          # Step 6: Create new account if no duplicate found
          begin
            MgAccount.create!(
              mg_account_name: mg_account_name,
              description: account[:description],
              mg_user_id: user_result.id,
              is_deleted: false,
              mg_school_id: school_id,
              created_by: user_id,
              updated_by: user_id,
              created_at: current_time,
              updated_at: current_time
            )
            created_accounts << { row: account[:row_number] || (index + 1), mg_account_name: mg_account_name }
          rescue ActiveRecord::RecordInvalid => e
            # Handle validation errors for invalid rows
            errors << {
              row: account[:row_number] || (index + 1),
              name: mg_account_name,  # Changed from 'mg_account_name' to 'name'
              error: e.message
            }
          end
        end
      end
    end

    # Step 7: Final response with updated format
    if errors.empty? && duplicate_in_excel.empty? && duplicate_accounts.empty?
      response = {
        status: 'success',
        message: 'All accounts processed successfully',
        data: {
          created: created_accounts,
          duplicate: [], # No duplicates found
          errors: []
        }
      }
    else
      response = {
        status: 'error',
        message: 'Some accounts could not be processed',
        data: {
          created: created_accounts,
          duplicate: errors
        }
      }
    end

    render_json_response(response, errors.empty? && duplicate_in_excel.empty? && duplicate_accounts.empty? ? :ok : :unprocessable_entity)
  rescue StandardError => e
    handle_error(e)
  end


#Academic Year 
  def upload_academics
    current_time = Time.now
    school_id = session[:current_user_school_id]
    user_id = session[:user_id]

    # Step 1: Validate parameters
    unless params[:data].is_a?(Array)
      render_json_response({
        status: 'error',
        message: 'Invalid data format. Expected an array of academics.',
        data: {}
      }, :unprocessable_entity) and return
    end

    # Step 2: Initialize academics
    @academics = params.require(:data).map do |academic|
      academic.permit(:name, :start_date, :end_date, :row_number).to_h
    end
    Rails.logger.info "Sanitized academics: #{@academics.inspect}"

    # Step 3: Check for duplicates
    duplicate_academics = []
    existing_academics = MgTimeTable.where(
      name: @academics.map { |academic| academic[:name] },
      mg_school_id: school_id,
      is_deleted: false
    ).pluck(:name).to_set

    seen_academics = Set.new # Track academics already processed in this batch

    @academics.each_with_index do |academic, index|
      academic_name = academic[:name]

      # Check if this academic has already been processed in the current batch
      if seen_academics.include?(academic_name)
        duplicate_academics << {
          row: academic[:row_number] || (index + 1),
          name: academic_name,
          error: "Duplicate academic year '#{academic_name}' found in row #{academic[:row_number] || (index + 1)}"
        }
        next # Skip processing for this academic year since it's a duplicate
      else
        seen_academics.add(academic_name) # Mark this academic as processed
      end

      if existing_academics.include?(academic_name)
        duplicate_academics << {
          row: academic[:row_number] || (index + 1),
          name: academic_name,
          error: "Academic year '#{academic_name}' already exists in the database"
        }
      end
    end

    # If duplicates found, respond with duplicates list
    if duplicate_academics.any?
      response = {
        status: 'error',
        message: 'Duplicate academic records found. No records were processed.',
        data: {
          created: [], # Ensuring the `created` key is always present
          duplicate: duplicate_academics
        }
      }
      render_json_response(response, :unprocessable_entity) and return
    end

    # Step 4: Process academics
    created_academics = []
    errors = []

    @academics.each_with_index do |academic, index|
      academic_params = filtered_params(academic)

      begin
        MgTimeTable.create!(
          name: academic_params[:name],
          start_date: Date.strptime(academic_params[:start_date], '%d/%m/%Y'),
          end_date: Date.strptime(academic_params[:end_date], '%d/%m/%Y'),
          is_deleted: false,
          mg_school_id: school_id,
          created_by: user_id,
          updated_by: user_id,
          created_at: current_time,
          updated_at: current_time
        )

        created_academics << { row: academic[:row_number] || (index + 1), name: academic_params[:name] }
      rescue ActiveRecord::RecordInvalid => e
        errors << {
          row: academic[:row_number] || (index + 1),
          name: academic_params[:name],
          error: e.message
        }
      end
    end

    # Step 5: Final response
    response = {
      status: errors.empty? ? 'success' : 'error',
      message: errors.empty? ? 'All academics processed successfully' : 'Some academics could not be processed',
      data: {
        created: created_academics,
        duplicate: errors
      }
    }
    render_json_response(response, errors.empty? ? :ok : :unprocessable_entity)
  rescue StandardError => e
    handle_error(e)
  end

# Wings 
  def upload_wings
    current_time = Time.now
    school_id = session[:current_user_school_id]
    user_id = session[:user_id]

    # Step 1: Validate parameters
    unless params[:data].is_a?(Array)
      render_json_response({
        status: 'error',
        message: 'Invalid data format. Expected an array of wings.',
        data: {}
      }, :unprocessable_entity) and return
    end

    # Step 2: Initialize wings
    @wings = params.require(:data).map do |wing|
      wing.permit(:wing_name, :row_number).to_h
    end
    Rails.logger.info "Sanitized wings: #{@wings.inspect}"

    # Step 3: Check for duplicates
    duplicate_wings = []
    existing_wings = MgWing.where(
      wing_name: @wings.map { |wing| wing[:wing_name] },
      mg_school_id: school_id,
      is_deleted: false
    ).pluck(:wing_name).to_set

    seen_wings = Set.new # Track wings already processed in this batch

    @wings.each_with_index do |wing, index|
      wing_name = wing[:wing_name]

      # Check if this wing has already been processed in the current batch
      if seen_wings.include?(wing_name)
        duplicate_wings << {
          row: wing[:row_number] || (index + 1),
          name: wing_name,
          error: "Duplicate wing '#{wing_name}' found in row #{wing[:row_number] || (index + 1)}"
        }
        next # Skip processing for this wing since it's a duplicate in the batch
      else
        seen_wings.add(wing_name) # Mark this wing as processed
      end

      # Check if the wing already exists in the database
      if existing_wings.include?(wing_name)
        duplicate_wings << {
          row: wing[:row_number] || (index + 1),
          name: wing_name,
          error: "Wing '#{wing_name}' already exists in the database"
        }
      end
    end

    # If duplicates found, respond with duplicates list
    if duplicate_wings.any?
      response = {
        status: 'error',
        message: 'Duplicate wing records found. No records were processed.',
        data: {
          created: [], # Ensuring the `created` key is always present
          duplicate: duplicate_wings
        }
      }
      render_json_response(response, :unprocessable_entity) and return
    end

    # Step 4: Process wings
    created_wings = []
    errors = []

    @wings.each_with_index do |wing, index|
      wing_params = filtered_wing_params(wing)

      begin
        MgWing.create!(
          wing_name: wing_params[:wing_name],
          is_deleted: false,
          mg_school_id: school_id,
          created_by: user_id,
          updated_by: user_id,
          created_at: current_time,
          updated_at: current_time
        )

        created_wings << { row: wing[:row_number] || (index + 1), name: wing_params[:wing_name] }
      rescue ActiveRecord::RecordInvalid => e
        errors << {
          row: wing[:row_number] || (index + 1),
          name: wing_params[:wing_name],
          error: e.message
        }
      end
    end

    # Step 5: Final response
    response = {
      status: errors.empty? ? 'success' : 'error',
      message: errors.empty? ? 'All wings processed successfully' : 'Some wings could not be processed',
      data: {
        created: created_wings,
        duplicate: errors
      }
    }
    render_json_response(response, errors.empty? ? :ok : :unprocessable_entity)
  rescue StandardError => e
    handle_error(e)
  end




# Class 
  def upload_class
    current_time = Time.now
    school_id = session[:current_user_school_id]
    user_id = session[:user_id]

    # Step 1: Validate parameters
    unless params[:data].is_a?(Array)
      render_json_response({
        status: 'error',
        message: 'Invalid data format. Expected an array of classes.',
        data: {}
      }, :unprocessable_entity) and return
    end

    # Step 2: Initialize classes
    @classes = params.require(:data).map do |cls|
      cls.permit(:course_name, :code, :time_table_name, :wing_name, :row_number).to_h
    end
    Rails.logger.info "Sanitized classes: #{@classes.inspect}"

    # Step 3: Check for duplicates
    duplicate_classes = []
    
    # Step 3a: Pre-fetch existing course details to avoid multiple DB calls in the loop
    existing_classes = MgCourse.where(
      mg_school_id: school_id,
      is_deleted: false,
      course_name: @classes.map { |cls| cls[:course_name] },
      mg_time_table_id: MgTimeTable.where(mg_school_id: school_id, name: @classes.map { |cls| cls[:time_table_name] }).pluck(:id),
      mg_wing_id: MgWing.where(mg_school_id: school_id, wing_name: @classes.map { |cls| cls[:wing_name] }).pluck(:id)
    ).pluck(:course_name, :mg_time_table_id, :mg_wing_id).to_set

    @classes.each_with_index do |cls, index|
      course_name = cls[:course_name]
      time_table_name = cls[:time_table_name]
      wing_name = cls[:wing_name]

      # Find the corresponding time_table_id and wing_id for checking duplicates
      time_table = MgTimeTable.find_by(mg_school_id: school_id, name: time_table_name, is_deleted: false)
      wing = MgWing.find_by(mg_school_id: school_id, wing_name: wing_name, is_deleted: false)

      # If time_table is not found, we should handle it as an error (e.g., time_table_name is invalid)
      if time_table.nil?
        duplicate_classes << {
          row: cls[:row_number] || (index + 1),
          course_name: course_name,
          time_table_name: time_table_name,  # Ensure this is passed in the error
          wing_name: wing_name,
          error: "Time Table '#{time_table_name}' not found for class '#{course_name}' in row #{cls[:row_number] || (index + 1)}"
        }
        next # Skip further checks for this class
      end

      # If wing is not found, we should handle it as an error (e.g., wing_name is invalid)
      if wing.nil?
        duplicate_classes << {
          row: cls[:row_number] || (index + 1),
          course_name: course_name,
          time_table_name: time_table_name,  # Ensure this is passed in the error
          wing_name: wing_name,
          error: "Wing '#{wing_name}' not found for class '#{course_name}' in row #{cls[:row_number] || (index + 1)}"
        }
        next # Skip further checks for this class
      end

      time_table_id = time_table.id
      wing_id = wing.id

      # Check if the combination of course_name, time_table_id, and wing_id already exists
      if existing_classes.include?([course_name, time_table_id, wing_id])
        duplicate_classes << {
          row: cls[:row_number] || (index + 1),
          course_name: course_name,
          time_table_name: time_table_name,  # Ensure this is passed in the error
          wing_name: wing_name,
          error: "Class '#{course_name}' with  Wing '#{wing_name}' already exists in row #{cls[:row_number] || (index + 1)}"
        }
      end
    end

    # If there are any duplicate classes
    if duplicate_classes.any?
      response = {
        status: 'error',
        message: 'Duplicate class records found. No records were processed.',
        data: {
          created: [], # Ensuring the `created` key is always present
          duplicate: duplicate_classes
        }
      }
      render_json_response(response, :unprocessable_entity) and return
    end

    # Step 4: Process classes and save them
    created_classes = []
    errors = []

    @classes.each_with_index do |cls, index|
      time_table = MgTimeTable.find_by(mg_school_id: school_id, name: cls[:time_table_name], is_deleted: false)
      wing = MgWing.find_by(mg_school_id: school_id, wing_name: cls[:wing_name], is_deleted: false)

      begin
        MgCourse.create!(
          course_name: cls[:course_name],
          code: cls[:code],
          is_deleted: false,
          mg_school_id: school_id,
          mg_time_table_id: time_table.id,
          mg_wing_id: wing.id,
          created_by: user_id,
          updated_by: user_id,
          created_at: current_time,
          updated_at: current_time
        )

        created_classes << { row: cls[:row_number] || (index + 1), course_name: cls[:course_name] }
      rescue ActiveRecord::RecordInvalid => e
        errors << {
          row: cls[:row_number] || (index + 1),
          course_name: cls[:course_name],
          error: e.message
        }
      end
    end

    # Step 5: Final response
    response = {
      status: errors.empty? ? 'success' : 'error',
      message: errors.empty? ? 'All classes processed successfully' : 'Some classes could not be processed',
      data: {
        created: created_classes,
        duplicate: errors
      }
    }
    render_json_response(response, errors.empty? ? :ok : :unprocessable_entity)
  rescue StandardError => e
    handle_error(e)
  end

  private

  def filtered_wing_params(wing)
    allowed_keys = %i[wing_name row_number]
    wing = wing.deep_symbolize_keys
    filtered = wing.slice(*allowed_keys)

    unexpected_keys = wing.keys - allowed_keys
    if unexpected_keys.any?
      raise ArgumentError, "Unexpected parameters found: #{unexpected_keys.join(', ')}"
    end

    filtered
  end


  private
  
  def filtered_params(academic)
    allowed_keys = %i[name start_date end_date row_number]
    academic = academic.deep_symbolize_keys
    filtered = academic.slice(*allowed_keys)
  
    unexpected_keys = academic.keys - allowed_keys
    if unexpected_keys.any?
      raise ArgumentError, "Unexpected parameters found: #{unexpected_keys.join(', ')}"
    end
  
    filtered
  end
  


private

def filtered_params(cls)
  allowed_keys = %i[course_name code time_table_name wing_name row_number]
  cls = cls.deep_symbolize_keys
  filtered = cls.slice(*allowed_keys)

  unexpected_keys = cls.keys - allowed_keys
  if unexpected_keys.any?
    raise ArgumentError, "Unexpected parameters found: #{unexpected_keys.join(', ')}"
  end

  filtered
end

end



