class UploadExcelSetThreeController < ApplicationController
    layout "mindcom"
    include JsonResponseHelper

    def template3_exists
      school_id = session[:current_user_school_id]
      
      # Perform checks for all the entities
      caste_exists = MgCaste.exists?(is_deleted: 0, mg_school_id: school_id)
      caste_category_exist = MgCasteCategory.exists?(is_deleted: 0, mg_school_id: school_id)
      student_category_exist = MgStudentCategory.exists?(mg_school_id: school_id, is_deleted: false)
      house_details_exist = MgHouseDetails.exists?(is_deleted: 0, mg_school_id: school_id)
      subject_exist = MgSubject.exists?(is_deleted: 0, mg_school_id: school_id)
      section_exist  = MgBatchSubject.exists?(is_deleted:0,mg_school_id:school_id)
      student_exist = MgStudent.exists?(is_deleted:0,mg_school_id:school_id)
      # Render the results as a JSON object
      render json: {
        caste_exists: caste_exists,
        caste_category_exist: caste_category_exist,
        student_category_exist: student_category_exist,
        house_details_exist:house_details_exist,
        subject_exist: subject_exist,
        section_exist: section_exist,
        student_exist:student_exist
      }
    end

    def upload_castes
        current_time = Time.now
        school_id = session[:current_user_school_id]
        user_id = session[:user_id]
        
        # Step 1: Validate parameters
        unless params[:data].is_a?(Array)
            render_json_response({
            status: 'error',
            message: 'Invalid data format. Expected an array of castes.',
            data: {}
            }, :unprocessable_entity) and return
        end
        
        # Step 2: Initialize castes
        @castes = params.require(:data).map do |caste|
            caste.permit(:name, :description, :row_number).to_h
        end
        Rails.logger.info "Sanitized castes: #{@castes.inspect}"
        
        # Step 3: Check for duplicates
        duplicate_castes = []
        existing_castes = MgCaste.where(
            name: @castes.map { |caste| caste[:name] },
            mg_school_id: school_id,
            is_deleted: false
        ).pluck(:name).to_set
        
        seen_castes = Set.new # Track castes already processed in this batch
        
        @castes.each_with_index do |caste, index|
            caste_name = caste[:name]
        
            # Check if this caste has already been processed in the current batch
            if seen_castes.include?(caste_name)
            duplicate_castes << {
                row: caste[:row_number] || (index + 1),
                name: caste_name,
                error: "Duplicate caste '#{caste_name}' found in row #{caste[:row_number] || (index + 1)}"
            }
            next # Skip processing for this caste since it's a duplicate
            else
            seen_castes.add(caste_name) # Mark this caste as processed
            end
        
            if existing_castes.include?(caste_name)
            duplicate_castes << {
                row: caste[:row_number] || (index + 1),
                name: caste_name,
                error: "Caste '#{caste_name}' already exists in the System"
            }
            end
        end
        
        # If duplicates found, respond with duplicates list
        if duplicate_castes.any?
            response = {
            status: 'error',
            message: 'Duplicate caste records found. No records were processed.',
            data: {
                created: [],
                duplicate: duplicate_castes
            }
            }
            render_json_response(response, :unprocessable_entity) and return
        end
        
        # Step 4: Process castes
        created_castes = []
        errors = []
        
        @castes.each_with_index do |caste, index|
            caste_params = filtered_params(caste)
        
            begin
            MgCaste.create!(
                name: caste_params[:name],
                description: caste_params[:description],
                is_deleted: false,
                mg_school_id: school_id,
                created_by: user_id,
                updated_by: user_id,
                created_at: current_time,
                updated_at: current_time
            )
        
            created_castes << { row: caste[:row_number] || (index + 1), name: caste_params[:name] }
            rescue ActiveRecord::RecordInvalid => e
            errors << {
                row: caste[:row_number] || (index + 1),
                name: caste_params[:name],
                error: e.message
            }
            end
        end
        
        # Step 5: Final response
        response = {
            status: errors.empty? ? 'success' : 'error',
            message: errors.empty? ? 'All castes processed successfully' : 'Some castes could not be processed',
            data: {
            created: created_castes,
            duplicate: errors
            }
        }
        render_json_response(response, errors.empty? ? :ok : :unprocessable_entity)
        rescue StandardError => e
        handle_error(e)
        end
# Caste Categories
    def upload_caste_categories
        current_time = Time.now
        school_id = session[:current_user_school_id]
        user_id = session[:user_id]
      
        # Step 1: Validate parameters
        unless params[:data].is_a?(Array)
          render_json_response({
            status: 'error',
            message: 'Invalid data format. Expected an array of caste categories.',
            data: {}
          }, :unprocessable_entity) and return
        end
      
        # Step 2: Initialize caste categories
        @caste_categories = params.require(:data).map do |caste_category|
          caste_category.permit(:name, :description, :row_number).to_h
        end
        Rails.logger.info "Sanitized caste categories: #{@caste_categories.inspect}"
      
        # Step 3: Check for duplicates
        duplicate_categories = []
        existing_categories = MgCasteCategory.where(
          name: @caste_categories.map { |category| category[:name] },
          mg_school_id: school_id,
          is_deleted: false
        ).pluck(:name).to_set
      
        seen_categories = Set.new # Track categories already processed in this batch
      
        @caste_categories.each_with_index do |category, index|
          category_name = category[:name]
      
          # Check if this category has already been processed in the current batch
          if seen_categories.include?(category_name)
            duplicate_categories << {
              row: category[:row_number] || (index + 1),
              name: category_name,
              error: "Duplicate caste category '#{category_name}' found in row #{category[:row_number] || (index + 1)}"
            }
            next # Skip processing for this category since it's a duplicate
          else
            seen_categories.add(category_name) # Mark this category as processed
          end
      
          if existing_categories.include?(category_name)
            duplicate_categories << {
              row: category[:row_number] || (index + 1),
              name: category_name,
              error: "Caste category '#{category_name}' already exists in the system"
            }
          end
        end
      
        # If duplicates found, respond with duplicates list
        if duplicate_categories.any?
          response = {
            status: 'error',
            message: 'Duplicate caste category records found. No records were processed.',
            data: {
              created: [],
              duplicate: duplicate_categories
            }
          }
          render_json_response(response, :unprocessable_entity) and return
        end
      
        # Step 4: Process caste categories
        created_categories = []
        errors = []
      
        @caste_categories.each_with_index do |category, index|
          category_params = filtered_params(category)
      
          begin
            MgCasteCategory.create!(
              name: category_params[:name],
              description: category_params[:description],
              is_deleted: false,
              mg_school_id: school_id,
              created_by: user_id,
              updated_by: user_id,
              created_at: current_time,
              updated_at: current_time
            )
      
            created_categories << { row: category[:row_number] || (index + 1), name: category_params[:name] }
          rescue ActiveRecord::RecordInvalid => e
            errors << {
              row: category[:row_number] || (index + 1),
              name: category_params[:name],
              error: e.message
            }
          end
        end
      
        # Step 5: Final response
        response = {
          status: errors.empty? ? 'success' : 'error',
          message: errors.empty? ? 'All caste categories processed successfully' : 'Some caste categories could not be processed',
          data: {
            created: created_categories,
            duplicate: errors
          }
        }
        render_json_response(response, errors.empty? ? :ok : :unprocessable_entity)
      rescue StandardError => e
        handle_error(e)
      end
    

    
    def upload_student_categories
      current_time = Time.now
      school_id = session[:current_user_school_id]
      user_id = session[:user_id]
      
      # Step 1: Validate parameters
      unless params[:data].is_a?(Array)
          render_json_response({
          status: 'error',
          message: 'Invalid data format. Expected an array of student categories.',
          data: {}
          }, :unprocessable_entity) and return
      end
      
      # Step 2: Initialize student categories
      @student_categories = params.require(:data).map do |student_category|
          student_category.permit(:name, :row_number).to_h
      end
      Rails.logger.info "Sanitized student categories: #{@student_categories.inspect}"
      
      # Step 3: Check for duplicates
      duplicate_categories = []
      existing_categories = MgStudentCategory.where(
          name: @student_categories.map { |category| category[:name] },
          mg_school_id: school_id,
          is_deleted: false
      ).pluck(:name).to_set
      
      seen_categories = Set.new # Track categories already processed in this batch
      
      @student_categories.each_with_index do |category, index|
          category_name = category[:name]
      
          # Check if this category has already been processed in the current batch
          if seen_categories.include?(category_name)
          duplicate_categories << {
              row: category[:row_number] || (index + 1),
              name: category_name,
              error: "Duplicate student category '#{category_name}' found in row #{category[:row_number] || (index + 1)}"
          }
          next # Skip processing for this category since it's a duplicate
          else
          seen_categories.add(category_name) # Mark this category as processed
          end
      
          if existing_categories.include?(category_name)
          duplicate_categories << {
              row: category[:row_number] || (index + 1),
              name: category_name,
              error: "Student category '#{category_name}' already exists in the system"
          }
          end
      end
      
      # If duplicates found, respond with duplicates list
      if duplicate_categories.any?
          response = {
          status: 'error',
          message: 'Duplicate student category records found. No records were processed.',
          data: {
              created: [],
              duplicate: duplicate_categories
          }
          }
          render_json_response(response, :unprocessable_entity) and return
      end
      
      # Step 4: Process student categories
      created_categories = []
      errors = []
      
      @student_categories.each_with_index do |category, index|
          category_params = filtered_params(category)
    
        begin
        MgStudentCategory.create!(
            name: category_params[:name],
            is_deleted: false,
            mg_school_id: school_id,
            created_by: user_id,
            updated_by: user_id,
            created_at: current_time,
            updated_at: current_time
        )
    
        created_categories << { row: category[:row_number] || (index + 1), name: category_params[:name] }
        rescue ActiveRecord::RecordInvalid => e
        errors << {
            row: category[:row_number] || (index + 1),
            name: category_params[:name],
            error: e.message
        }
        end
    end
    # Step 5: Final response
    response = {
        status: errors.empty? ? 'success' : 'error',
        message: errors.empty? ? 'All student categories processed successfully' : 'Some student categories could not be processed',
        data: {
        created: created_categories,
        duplicate: errors
        }
    }
    render_json_response(response, errors.empty? ? :ok : :unprocessable_entity)
    rescue StandardError => e
    handle_error(e)
    end

    def upload_house_details
        current_time = Time.now
        school_id = session[:current_user_school_id]
        user_id = session[:user_id]
    
        # Step 1: Validate parameters
        unless params[:data].is_a?(Array)
          render_json_response({
            status: 'error',
            message: 'Invalid data format. Expected an array of house details.',
            data: {}
          }, :unprocessable_entity) and return
        end
    
        # Step 2: Initialize house details
        @house_details = params.require(:data).map do |house_detail|
          house_detail.permit(:name, :description, :row_number).to_h
        end
        Rails.logger.info "Sanitized house details: #{@house_details.inspect}"
    
        # Step 3: Check for duplicates
        duplicate_houses = []
        existing_houses = MgHouseDetails.where(
          Name: @house_details.map { |house| house[:name] },
          mg_school_id: school_id,
          is_deleted: false
        ).pluck(:Name).to_set
    
        seen_houses = Set.new # Track houses already processed in this batch
    
        @house_details.each_with_index do |house, index|
          house_name = house[:name]
    
          # Check if this house has already been processed in the current batch
          if seen_houses.include?(house_name)
            duplicate_houses << {
              row: house[:row_number] || (index + 1),
              name: house_name,
              error: "Duplicate house detail '#{house_name}' found in row #{house[:row_number] || (index + 1)}"
            }
            next # Skip processing for this house since it's a duplicate
          else
            seen_houses.add(house_name) # Mark this house as processed
          end
    
          if existing_houses.include?(house_name)
            duplicate_houses << {
              row: house[:row_number] || (index + 1),
              name: house_name,
              error: "House detail '#{house_name}' already exists in the system"
            }
          end
        end
    
        # If duplicates found, respond with duplicates list
        if duplicate_houses.any?
          response = {
            status: 'error',
            message: 'Duplicate house detail records found. No records were processed.',
            data: {
              created: [],
              duplicate: duplicate_houses
            }
          }
          render_json_response(response, :unprocessable_entity) and return
        end
    
        # Step 4: Process house details
        created_houses = []
        errors = []
    
        @house_details.each_with_index do |house, index|
          house_params = filtered_house_params(house)
    
          begin
            MgHouseDetails.create!(
              Name: house_params[:name],
              Description: house_params[:description],
              is_deleted: false,
              mg_school_id: school_id,
              created_by: user_id,
              updated_by: user_id,
              created_at: current_time,
              updated_at: current_time
            )
    
            created_houses << { row: house[:row_number] || (index + 1), name: house_params[:name] }
          rescue ActiveRecord::RecordInvalid => e
            errors << {
              row: house[:row_number] || (index + 1),
              name: house_params[:name],
              error: e.message
            }
          end
        end
    
        # Step 5: Final response
        response = {
          status: errors.empty? ? 'success' : 'error',
          message: errors.empty? ? 'All house details processed successfully' : 'Some house details could not be processed',
          data: {
            created: created_houses,
            duplicate: errors
          }
        }
        render_json_response(response, errors.empty? ? :ok : :unprocessable_entity)
      rescue StandardError => e
        handle_error(e)
      end
    

    def upload_subject_details
      current_time = Time.now
      school_id = session[:current_user_school_id]
      user_id = session[:user_id]
    
      # Step 1: Validate parameters
      unless params[:data].is_a?(Array)
        render_json_response({
          status: 'error',
          message: 'Invalid data format. Expected an array of subject details.',
          data: {}
        }, :unprocessable_entity) and return
      end
    
      # Step 2: Initialize subject details
      @subject_details = params.require(:data).map do |subject_detail|
        subject_detail.permit(
          :subject_name, :subject_code, :mg_course_code, :max_weekly_class,
          :is_core, :is_lab, :no_of_classes, :is_extra_curricular,
          :scoring_type, :row_number, :mg_time_table_name
        ).to_h
      end
      Rails.logger.info "Sanitized subject details: #{@subject_details.inspect}"
    
      # Step 3: Check for duplicates
      duplicate_subjects = []
      seen_subjects = Set.new
    
      # Fetch existing subjects from the database for the given school
      existing_subjects = MgSubject.joins(:mg_course)
                                    .where(
                                      subject_name: @subject_details.map { |detail| detail[:subject_name] },
                                      mg_school_id: school_id,
                                      is_deleted: false
                                    )
                                    .pluck('mg_courses.code', :subject_name)
                                    .to_set
    
      @subject_details.each_with_index do |subject, index|
        subject_name = subject[:subject_name]
        mg_course_code = subject[:mg_course_code]
        row_number = subject[:row_number] || (index + 1)
    
        # Check for duplicate subjects in the provided data (Excel file)
        if seen_subjects.include?([mg_course_code, subject_name])
          duplicate_subjects << {
            row: row_number,
            subject_name: subject_name,
            error: "Duplicate subject '#{subject_name}' found in row #{row_number} for course '#{mg_course_code}'"
          }
          next
        else
          seen_subjects.add([mg_course_code, subject_name])
        end
    
        # Check for duplicate subjects in the database
        if existing_subjects.include?([mg_course_code, subject_name])
          duplicate_subjects << {
            row: row_number,
            subject_name: subject_name,
            error: "Subject '#{subject_name}' already exists for course '#{mg_course_code}' in the system "
          }
        end
      end
    
      # If duplicates found, respond with duplicates list
      if duplicate_subjects.any?
        render_json_response({
          status: 'error',
          message: 'Duplicate subject records found. No records were processed.',
          data: { created: [], duplicate: duplicate_subjects }
        }, :unprocessable_entity) and return
      end
    
      # Step 4: Create subjects
      created_subjects = []
      errors = []
    
      @subject_details.each_with_index do |subject, index|
        begin
          course = MgCourse.find_by(
            code: subject[:mg_course_code],
            mg_school_id: school_id,
            is_deleted: false
          )
          MgSubject.create!(
            subject_name: subject[:subject_name],
            subject_code: subject[:subject_code],
            mg_course_id: course.id,
            max_weekly_class: subject[:max_weekly_class],
            is_core: subject[:is_core],
            is_lab: subject[:is_lab],
            no_of_classes: subject[:no_of_classes],
            is_extra_curricular: subject[:is_extra_curricular],
            scoring_type: subject[:scoring_type],
            is_deleted: false,
            mg_school_id: school_id,
            created_by: user_id,
            updated_by: user_id,
            created_at: current_time,
            updated_at: current_time
          )
          created_subjects << { row: subject[:row_number] || (index + 1), subject_name: subject[:subject_name] }
        rescue ActiveRecord::RecordInvalid => e
          errors << {
            row: subject[:row_number] || (index + 1),
            subject_name: subject[:subject_name],
            error: e.message
          }
        end
      end
      
        # Step 5: Final response
        render_json_response({
          status: errors.empty? ? 'success' : 'error',
          message: errors.empty? ? 'All records processed successfully' : 'Some records could not be processed.',
          data: { created: created_subjects, duplicate: errors }
        }, errors.empty? ? :ok : :unprocessable_entity)
      rescue StandardError => e
        handle_error(e)
      end

    
    
    
    
    
      def upload_batch_subjects
      current_time = Time.now
      school_id = session[:current_user_school_id]
      user_id = session[:user_id]
    
      # Step 1: Validate parameters
      unless params[:data].is_a?(Array)
        render_json_response({
          status: 'error',
          message: 'Invalid data format. Expected an array of batch subjects.',
          data: {}
        }, :unprocessable_entity) and return
      end
    
      # Step 2: Initialize batch subjects
      @batch_subjects = params.require(:data).map do |batch_subject|
        batch_subject.permit(:subject_code, :subject_name, :is_extra_curricular, :scoring_type, :mg_employee_id, :row_number, :batch_name, :class_name, :time_table_name).to_h
      end
      Rails.logger.info "Sanitized batch subjects: #{@batch_subjects.inspect}"
    
      # Step 3: Check for duplicates
      duplicate_subjects = []
      existing_subjects = MgBatchSubject.where(
        mg_batch_name: @batch_subjects.map { |subject| subject[:batch_name] },
        subject_name: @batch_subjects.map { |subject| subject[:subject_name] },
        subject_code: @batch_subjects.map { |subject| subject[:subject_code] },
        mg_school_id: school_id,
        is_deleted: false
      ).pluck(:mg_batch_id, :mg_subject_id).to_set
    
      seen_subjects = Set.new # Track subjects already processed in this batch
    
      @batch_subjects.each_with_index do |subject, index|
        batch_name = subject[:batch_name]
        subject_name = subject[:subject_name]
        subject_code = subject[:subject_code]
        class_name = subject[:class_name]
        time_table_name = subject[:time_table_name]
    
        # Step 3.1: Check if class_name is present and validate class with batch and subject
        if class_name.present?
          # Validate time_table_name first
          time_table_exists = MgTimetable.where(time_table_name: time_table_name, mg_school_id: school_id).first
    
          unless time_table_exists
            duplicate_subjects << {
              row: subject[:row_number] || (index + 1),
              error: "Time table '#{time_table_name}' does not exist for the given school."
            }
            next # Skip processing for this subject since the time_table_name doesn't exist
          end
    
          # Validate if class_name exists in MgCourse for the given time_table_id
          course_exists = MgCourse.where(code: class_name, mg_school_id: school_id, mg_time_table_id: time_table_exists.id).first
    
          unless course_exists
            duplicate_subjects << {
              row: subject[:row_number] || (index + 1),
              error: "Class name '#{class_name}' does not exist in the courses for the given time table."
            }
            next # Skip processing for this subject since the class_name doesn't exist
          end
    
          # Validate if batch_name exists in MgBatch for the given course_id and school_id
          batch_exists = MgBatch.where(name: batch_name, mg_school_id: school_id, mg_course_id: course_exists.id).exists?
    
          unless batch_exists
            duplicate_subjects << {
              row: subject[:row_number] || (index + 1),
              error: "Batch name '#{batch_name}' does not exist for the course '#{class_name}' in the given school."
            }
            next # Skip processing for this subject since the batch_name doesn't exist
          end
    
          # Step 3.2: Check if the subject is valid for the given course
          subject_exists_for_course = MgSubject.where(subject_name: subject_name, mg_course_id: course_exists.id, mg_school_id: school_id, is_deleted: false).exists?
    
          unless subject_exists_for_course
            duplicate_subjects << {
              row: subject[:row_number] || (index + 1),
              error: "Subject with name '#{subject_name}' is not associated with the course '#{class_name}'"
            }
            next # Skip processing for this subject since the subject is not valid for the given course
          end
        end
    
        # Check if this subject has already been processed in the current batch
        if seen_subjects.include?([batch_name, subject_name, subject_code])
          duplicate_subjects << {
            row: subject[:row_number] || (index + 1),
            error: "Duplicate batch-subject combination (Batch: #{batch_name}, Subject: #{subject_name}) found in row #{subject[:row_number] || (index + 1)}"
          }
          next # Skip processing for this subject since it's a duplicate
        else
          seen_subjects.add([batch_name, subject_name, subject_code]) # Mark this subject as processed
        end
    
        if existing_subjects.include?([batch_name, subject_name, subject_code])
          duplicate_subjects << {
            row: subject[:row_number] || (index + 1),
            error: "Batch-subject combination (Batch: #{batch_name}, Subject: #{subject_name}) already exists in the system"
          }
        end
      end
    
      # If duplicates found, respond with duplicates list
      if duplicate_subjects.any?
        response = {
          status: 'error',
          message: 'Duplicate batch subject records found. No records were processed.',
          data: {
            created: [],
            duplicate: duplicate_subjects
          }
        }
        render_json_response(response, :unprocessable_entity) and return
      end
    
      # Step 4: Process batch subjects
      created_subjects = []
      errors = []
    
      @batch_subjects.each_with_index do |subject, index|
        subject_params = filtered_params(subject)
    
        begin
          MgBatchSubject.create!(
            mg_batch_id: batch_exists.id,
            mg_subject_id: subject_exists_for_course.id,
            mg_school_id: school_id,
            is_deleted: false,
            created_by: user_id,
            updated_by: user_id,
            created_at: current_time,
            updated_at: current_time
          )
    
          created_subjects << { row: subject[:row_number] || (index + 1), batch_name: subject[:batch_name], subject_name: subject[:subject_name] }
        rescue ActiveRecord::RecordInvalid => e
          errors << {
            row: subject[:row_number] || (index + 1),
            error: e.message
          }
        end
      end
    
      # Step 5: Final response
      response = {
        status: errors.empty? ? 'success' : 'error',
        message: errors.empty? ? 'All batch subjects processed successfully' : 'Some batch subjects could not be processed',
        data: {
          created: created_subjects,
          duplicate: errors
        }
      }
      render_json_response(response, errors.empty? ? :ok : :unprocessable_entity)
    rescue StandardError => e
      handle_error(e)
    end


    # def upload_students
    #   current_time = Time.now
    #   school_id = session[:current_user_school_id]
    #   user_id = session[:user_id]
    
    #   # Arrays to track results
    #   created_students = []
    #   failed_students = []
    
    #   # Validate input
    #   unless params[:data].is_a?(Array)
    #     return render_json_response({
    #       status: 'error',
    #       message: 'Invalid data format. Expected an array of students.',
    #       data: {}
    #     }, :unprocessable_entity)
    #   end
    
    #   # Process student data
    #   student_data = params[:data]
    #   student_data.each_with_index do |data, index|
    #     row_number = index + 1
    
    #     begin
    #       # Check for existing student by admission number
    #       existing_students = MgStudent.find_by(
    #         admission_number: data[:admission_number],
    #         mg_school_id: school_id,
    #         is_deleted: false
    #       )
    
    #       if existing_students
    #         failed_students << {
    #           row: row_number,
    #           name: "#{data[:first_name]} #{data[:last_name]}",
    #           error: "Duplicate Admission Number: #{data[:admission_number]}"
    #         }
    #         next
    #       end
    
    #       # Find or create related entities
    #       timetable_result = MgTimeTable.find_or_create_by!(
    #         name: data[:academic_year],
    #         mg_school_id: school_id,
    #         is_deleted: false
    #       )
    
    #       course_exist = MgCourse.find_or_create_by!(
    #         course_name: data[:class_name],
    #         mg_school_id: school_id,
    #         mg_time_table_id: timetable_result.id,
    #         is_deleted: false
    #       )
    
    #       batch_exist = MgBatch.find_or_create_by!(
    #         name: data[:section_name],
    #         mg_course_id: course_exist.id,
    #         mg_school_id: school_id,
    #         is_deleted: false
    #       )
    
    #       caste_exist = MgCaste.find_or_create_by!(
    #         name: data[:caste_name],
    #         mg_school_id: school_id,
    #         is_deleted: false
    #       )
    
    #       student_category_exist = MgStudentCategory.find_or_create_by!(
    #         name: data[:student_category_name],
    #         mg_school_id: school_id,
    #         is_deleted: false
    #       )
    
    #       caste_category_exist = MgCasteCategory.find_or_create_by!(
    #         name: data[:caste_category_name],
    #         mg_school_id: school_id,
    #         is_deleted: false
    #       )
    
    #       # Generate username
    #       school_subdomain = MgSchool.find_by(id: school_id, is_deleted: false)&.subdomain
    
    #       highest_user = MgUser.where("user_name LIKE ?", "#{school_subdomain}S%")
    #                            .order(Arel.sql("CAST(SUBSTRING(user_name, LENGTH('#{school_subdomain}S') + 1) AS UNSIGNED) DESC"))
    #                            .pluck(:user_name)
    #                            .first
    
    #       username = if highest_user
    #                    highest_number = highest_user.gsub("#{school_subdomain}S", "").to_i
    #                    "#{school_subdomain}S#{highest_number + 1}"
    #                  else
    #                    "#{school_subdomain}S1"
    #                  end
    
    #       # Create User
    #       user = MgUser.create!(
    #         user_name: username,
    #         first_name: data[:first_name],
    #         middle_name: data[:middle_name],
    #         last_name: data[:last_name],
    #         email: data[:email_id],
    #         password: 'student123', # Default password
    #         user_type: "student",
    #         mg_school_id: school_id,
    #         created_by: user_id,
    #         updated_by: user_id,
    #         created_at: current_time,
    #         updated_at: current_time
    #       )
    
    #       # Create Student
    #       student = MgStudent.create!(
    #         mg_user_id: user.id,
    #         admission_number: user.user_name,
    #         first_name: data[:first_name],
    #         middle_name: data[:middle_name],
    #         last_name: data[:last_name],
    #         gender: data[:gender],
    #         date_of_birth: data[:date_of_birth],
    #         nationality: data[:nationality],
    #         language: data[:language],
    #         blood_group: data[:blood_group],
    #         class_roll_number: data[:class_roll_number],
    #         admission_date: data[:admission_date],
    #         hobby: data[:hobby],
    #         extra_curricular: data[:extra_curricular],
    #         sport_activity: data[:sport_activity],
    #         health_record: data[:health_record],
    #         class_record: data[:class_record],
    #         mg_batch_id: batch_exist.id,
    #         mg_course_id: course_exist.id,
    #         mg_caste_id: caste_exist.id,
    #         mg_student_catagory_id: student_category_exist.id,
    #         mg_caste_category_id: caste_category_exist.id,
    #         mg_school_id: school_id,
    #         created_by: user_id,
    #         updated_by: user_id,
    #         created_at: current_time,
    #         updated_at: current_time
    #       )

    #       MgEmail.create!(
    #     mg_email_id: student_data[:email],
    #     email_type: "home",
    #     mg_user_id: user.id,
    #     mg_school_id: school_id,
    #     created_by: user_id,
    #     created_at: current_time
    #   )
    
    #   # Sibling info
    #   if student_data[:sibling] && student_data[:sibling_class].present?
    #     sibling_class_id = MgCourse.find_by!(
    #       academic_year: student_data[:academic_year],
    #       class_name: student_data[:sibling_class],
    #       mg_school_id: school_id
    #     ).id
    
    #     sibling_section_id = student_data[:sibling_section].present? ?
    #       MgBatch.find_by!(
    #         academic_year: student_data[:academic_year],
    #         section_name: student_data[:sibling_section],
    #         mg_school_id: school_id
    #       ).id : nil
    
    #     begin
    #       sibling_admission_date = student_data[:sibling_date_of_admission].present? ?
    #         Date.parse(student_data[:sibling_date_of_admission]) : nil
    #     rescue Date::Error
    #       raise StandardError, "Sibling admission date should be in YYYY-MM-DD format"
    #     end
    
    #     MgSibling.create!(
    #       mg_user_id: user.id,
    #       name: student_data[:sibling_name],
    #       relation: student_data[:sibling_relationship],
    #       mg_course_id: sibling_class_id,
    #       mg_batch_id: sibling_section_id,
    #       roll_no: student_data[:sibling_roll_number],
    #       admission_date: sibling_admission_date,
    #       admission_no: student_data[:sibling_admision_number],
    #       is_sibling: true,
    #       mg_school_id: school_id,
    #       created_by: user_id
    #     )
    #   end

    #     MgAddress.create!(
    #       address_line1: student_data[:address_line1],
    #       address_line2: student_data[:address_line2],
    #       address_type: "Temporary",
    #       landmark: student_data[:landmark],
    #       city: student_data[:city],
    #       state: student_data[:state],
    #       country: student_data[:country],
    #       pin_code: student_data[:pin_code],
    #       mg_user_id: user.id,
    #       mg_school_id: school_id,
    #       created_by: user_id
    #     )

    #     MgAddress.create!(
    #       address_line1: student_data[:pr_address_line1],
    #       address_line2: student_data[:pr_address_line2],
    #       address_type: "Permanent",
    #       landmark: student_data[:pr_landmark],
    #       city: student_data[:pr_city],
    #       state: student_data[:pr_state],
    #       country: student_data[:pr_country],
    #       pin_code: student_data[:pr_pin_code],
    #       mg_user_id: user.id,
    #       mg_school_id: school_id,
    #       created_by: user_id
    #     )

    #     # Create phone numbers
    #     MgPhone.create!(
    #       phone_number: student_data[:mobile_number],
    #       phone_type: "mobile",
    #       notification: student_data[:student_notification],
    #       subscription: student_data[:student_subscription],
    #       mg_user_id: user.id,
    #       mg_school_id: school_id,
    #       created_by: user_id
    #     )

    #     if params[:alt_phone_number].present?
    #       MgPhone.create!(
    #         phone_number: student_data[:alt_phone_number],
    #         phone_type: "phone",
    #         notification: false,
    #         subscription: false,
    #         mg_user_id: user.id,
    #         mg_school_id: school_id,
    #         created_by: user_id
    #       )
    #     end

    #     # Create previous education
    #     if params[:prev_school_name].present?
    #       MgPreviousEducation.create!(
    #         school_name: student_data[:prev_school_name],
    #         course: student_data[:prev_class_name],
    #         grade: student_data[:grade_percentage],
    #         year: student_data[:year],
    #         mg_student_id: student.id,
    #         marks_obtained: student_data[:marks_obtained],
    #         total_marks: student_data[:total_marks],
    #         is_transfer_certificate_produced: params[:transfer_certificate].present?,
    #         mg_school_id: school_id,
    #         created_by: user_id
    #       )
    #     end
    
    #       # Add to successful creation list
    #       created_students << {
    #         row: row_number,
    #         name: "#{data[:first_name]} #{data[:last_name]}",
    #         username: username
    #       }
    #     rescue StandardError => e
    #       # Add to failed students list
    #       failed_students << {
    #         row: row_number,
    #         name: "#{data[:first_name]} #{data[:last_name]}",
    #         error: e.message
    #       }
    #     end
    #   end
    
    #   # Prepare the response
    #   response = {
    #     status: failed_students.any? ? 'error' : 'success',
    #     message: failed_students.any? ? 'Some students could not be processed' : 'All students processed successfully',
    #     data: {
    #       created: created_students,
    #       duplicate: failed_students
    #     }
    #   }
    
    #   # Render the response
    #   render_json_response(response, failed_students.any? ? :unprocessable_entity : :ok)
    # rescue StandardError => e
    #   handle_error(e)
    # end
    
    def upload_students
      current_time = Time.now
      school_id = session[:current_user_school_id]
      user_id = session[:user_id]
      
      # Arrays to track results
      created_students = []
      failed_students = []
    
      # Validate input
      unless params[:data].is_a?(Array)
        return render_json_response({
          status: 'error',
          message: 'Invalid data format. Expected an array of students.',
          data: {}
        }, :unprocessable_entity)
      end
    
      # Process student data
      student_data = params[:data]
      student_data.each_with_index do |data, index|
        row_number = index + 1
    
        begin
          # Check for existing student by admission number
          existing_students = MgStudent.find_by(
            admission_number: data[:admission_number],
            mg_school_id: school_id,
            is_deleted: false
          )
    
          if existing_students
            failed_students << {
              row: row_number,
              name: "#{data[:first_name]} #{data[:last_name]}",
              error: "Duplicate Admission Number: #{data[:admission_number]}"
            }
            next
          end
    
          # Find or create related entities
          timetable_result = MgTimeTable.find_or_create_by!(
            name: data[:academic_year],
            mg_school_id: school_id,
            is_deleted: false
          )
    
          course_exist = MgCourse.find_or_create_by!(
            course_name: data[:class_name],
            mg_school_id: school_id,
            mg_time_table_id: timetable_result.id,
            is_deleted: false
          )
    
          batch_exist = MgBatch.find_or_create_by!(
            name: data[:section_name],
            mg_course_id: course_exist.id,
            mg_school_id: school_id,
            is_deleted: false
          )
    
          caste_exist = MgCaste.find_or_create_by!(
            name: data[:caste_name],
            mg_school_id: school_id,
            is_deleted: false
          )
    
          student_category_exist = MgStudentCategory.find_or_create_by!(
            name: data[:student_category_name],
            mg_school_id: school_id,
            is_deleted: false
          )
    
          caste_category_exist = MgCasteCategory.find_or_create_by!(
            name: data[:caste_category_name],
            mg_school_id: school_id,
            is_deleted: false
          )

          begin
            dob = data[:date_of_birth].present? ?
              Date.parse(data[:date_of_birth]) : nil
          rescue Date::Error
            raise StandardError, "Date Of Birth should be in YYYY-MM-DD format"
          end

          begin
            admission_date = data[:admission_date].present? ?
              Date.parse(data[:admission_date]) : nil
          rescue Date::Error
            raise StandardError, "Admission Date should be in YYYY-MM-DD format"
          end
    
          # Generate username
          school_subdomain = MgSchool.find_by(id: school_id, is_deleted: false)&.subdomain
    
          highest_user = MgUser.where("user_name LIKE ?", "#{school_subdomain}S%")
                               .order(Arel.sql("CAST(SUBSTRING(user_name, LENGTH('#{school_subdomain}S') + 1) AS UNSIGNED) DESC"))
                               .pluck(:user_name)
                               .first
    
          username = if highest_user
                       highest_number = highest_user.gsub("#{school_subdomain}S", "").to_i
                       "#{school_subdomain}S#{highest_number + 1}"
                     else
                       "#{school_subdomain}S1"
                     end
    
          # Create User
          user = MgUser.create!(
            user_name: username,
            first_name: data[:first_name],
            middle_name: data[:middle_name],
            last_name: data[:last_name],
            email: data[:email_id],
            password: 'student123', # Default password
            user_type: "student",
            mg_school_id: school_id,
            created_by: user_id,
            updated_by: user_id,
            created_at: current_time,
            updated_at: current_time
          )
    
          # Create Student
          student = MgStudent.create!(
            mg_user_id: user.id,
            admission_number: user.user_name,
            first_name: data[:first_name],
            middle_name: data[:middle_name],
            last_name: data[:last_name],
            gender: data[:gender],
            date_of_birth: dob,
            nationality: data[:nationality],
            blood_group: data[:blood_group],
            class_roll_number: data[:class_roll_number],
            admission_date: admission_date,
            hobby: data[:hobby],
            extra_curricular: data[:extra_curricular],
            sport_activity: data[:sport_activity],
            health_record: data[:health_record],
            class_record: data[:class_record],
            adharnumber: data[:adharnumber],
            language: data[:mother_tongue],
            religion:data[:religion],
            mg_batch_id: batch_exist.id,
            mg_course_id: course_exist.id,
            mg_caste_id: caste_exist.id,
            mg_student_catagory_id: student_category_exist.id,
            mg_caste_category_id: caste_category_exist.id,
            mg_school_id: school_id,
            created_by: user_id,
            updated_by: user_id,
            created_at: current_time,
            updated_at: current_time
          )
  
    
          # Create Email
          MgEmail.create!(
            mg_email_id: data[:email_id],
            email_type: "home",
            mg_user_id: user.id,
            mg_school_id: school_id,
            created_by: user_id,
            created_at: current_time
          )

          # Create Guardian User
          guardian_highest_user = MgUser.where("user_name LIKE ?", "#{school_subdomain}G%")
          .order(Arel.sql("CAST(SUBSTRING(user_name, LENGTH('#{school_subdomain}G') + 1) AS UNSIGNED) DESC"))
          .pluck(:user_name)
          .first

          guardian_username = if guardian_highest_user
          highest_number = guardian_highest_user.gsub("#{school_subdomain}G", "").to_i
          "#{school_subdomain}G#{highest_number + 1}"
          else
          "#{school_subdomain}G1"
          end

          directory = "IMAGES/DATA/Default"
          path = File.join(directory, "default.JPG")
          m_file = File.open(path)

          guardian_user = MgUser.create!(
          user_name: guardian_username,
          first_name: data[:g1_f_name],
          middle_name: data[:g1_m_name],
          last_name: data[:g1_l_name],
          email: data[:g1_email],
          password: 'guardian123', # Default password
          user_type: "guardian",
          mg_school_id: school_id,
          created_by: user_id,
          updated_by: user_id,
          created_at: current_time,
          updated_at: current_time
          )

          guardian_1 = MgGuardian.create!(
          first_name: data[:g1_f_name],
          middle_name: data[:g1_m_name],
          last_name: data[:g1_l_name],
          relation: data[:g1_relation],
          dob: data[:g1_dob],
          occupation: data[:occupation],
          income: data[:income],
          education: data[:g1_education],
          mg_user_id: guardian_user.id,
          mg_student_id: student.id,
          is_deleted: false,
          mg_school_id: school_id,
          created_by: user_id,
          is_archive: false
          )

          if guardian_1.save
          student_guardian1 = MgStudentGuardian.create!(
          mg_student_id: student.id,
          mg_guardians_id: guardian_1.id,
          relation: data[:g1_relation],
          has_login_access: true,
          is_deleted: false,
          mg_school_id: school_id,
          created_by: user_id
          )

          if data[:g1_primary_contact].present? && data[:g1_primary_contact].downcase == "yes"
          student_guardian1.primary_contact = 1
          else
          student_guardian1.primary_contact = 0
          end

          student_guardian1.save!
          end
    
          # Sibling info
          if data[:sibling_name].present? && data[:sibling_class].present?
            sibling_class_id = MgCourse.find_by!(
              mg_time_table_id: timetable_result.id,
              code: data[:sibling_class],
              mg_school_id: school_id
            ).id
    
            sibling_section_id = data[:sibling_section].present? ?
              MgBatch.find_by!(
                mg_course_id: sibling_class_id,
                section_name: data[:sibling_section],
                mg_school_id: school_id
              ).id : nil
    
            begin
              sibling_admission_date = data[:sibling_date_of_admission].present? ?
                Date.parse(data[:sibling_date_of_admission]) : nil
            rescue Date::Error
              raise StandardError, "Sibling admission date should be in YYYY-MM-DD format"
            end
    
            # Create Sibling Record
            MgSibling.create!(
              mg_user_id: user.id,
              name: data[:sibling_name],
              relation: data[:sibling_relationship],
              mg_course_id: sibling_class_id,
              mg_batch_id: sibling_section_id,
              roll_no: data[:sibling_roll_number],
              admission_date: sibling_admission_date,
              admission_no: data[:sibling_admision_number],
              is_sibling: data[:is_sibling],
              mg_school_id: school_id,
              created_by: user_id
            )
          end

    
          # Create Addresses
          # MgAddress.create!(
          #   address_line1: data[:address_line1],
          #   address_line2: data[:address_line2],
          #   address_type: "Temporary",
          #   landmark: data[:landmark],
          #   city: data[:city],
          #   state: data[:state],
          #   country: data[:country],
          #   pin_code: data[:pin_code],
          #   mg_user_id: user.id,
          #   mg_school_id: school_id,
          #   created_by: user_id
          # )
    
          # MgAddress.create!(
          #   address_line1: data[:pr_address_line1],
          #   address_line2: data[:pr_address_line2],
          #   address_type: "Permanent",
          #   landmark: data[:pr_landmark],
          #   city: data[:pr_city],
          #   state: data[:pr_state],
          #   country: data[:pr_country],
          #   pin_code: data[:pr_pin_code],
          #   mg_user_id: user.id,
          #   mg_school_id: school_id,
          #   created_by: user_id
          # )
    
          # Create Phone Numbers
          MgPhone.create!(
            phone_number: data[:mobile_number],
            phone_type: "mobile",
            notification: data[:student_notification],
            subscription: data[:student_subscription],
            mg_user_id: user.id,
            mg_school_id: school_id,
            created_by: user_id
          )
    
          if data[:alt_phone_number].present?
            MgPhone.create!(
              phone_number: data[:alt_phone_number],
              phone_type: "phone",
              notification: false,
              subscription: false,
              mg_user_id: user.id,
              mg_school_id: school_id,
              created_by: user_id
            )
          end
    
          # Create Previous Education
          if data[:prev_school_name].present?
            MgPreviousEducation.create!(
              school_name: data[:prev_school_name],
              course: data[:prev_class_name],
              grade: data[:grade_percentage],
              year: data[:year],
              mg_student_id: student.id,
              marks_obtained: data[:marks_obtained],
              total_marks: data[:total_marks],
              is_transfer_certificate_produced: data[:transfer_certificate].present?,
              mg_school_id: school_id,
              created_by: user_id
            )
          end
    
          # Add to successful creation list
          created_students << {
            row: row_number,
            name: "#{data[:first_name]} #{data[:last_name]}",
            username: username
          }
        rescue StandardError => e
          # Add to failed students list
          failed_students << {
            row: row_number,
            name: "#{data[:first_name]} #{data[:last_name]}",
            error: e.message
          }
        end
      end
    
      # Prepare the response
      response = {
        status: failed_students.any? ? 'error' : 'success',
        message: failed_students.any? ? 'Some students could not be processed' : 'All students processed successfully',
        data: {
          created: created_students,
          duplicate: failed_students
        }
      }
    
      # Render the response
      render_json_response(response, failed_students.any? ? :unprocessable_entity : :ok)
    rescue StandardError => e
      render_json_response({
        status: 'error',
        message: "An error occurred: #{e.message}",
        data: {}
      }, :internal_server_error)
    end
    
    
    
    # Helper method to create related student data like sibling, address, etc.
    def create_student_related_data(student, student_data, user, school_id, user_id, current_time)
      # Create email record, sibling info, addresses, phones, previous education etc.
      MgEmail.create!(
        mg_email_id: student_data[:email],
        email_type: "home",
        mg_user_id: user.id,
        mg_school_id: school_id,
        created_by: user_id,
        created_at: current_time
      )
    
      # Sibling info
      if student_data[:sibling] && student_data[:sibling_class].present?
        sibling_class_id = MgCourse.find_by!(
          academic_year: student_data[:academic_year],
          class_name: student_data[:sibling_class],
          mg_school_id: school_id
        ).id
    
        sibling_section_id = student_data[:sibling_section].present? ?
          MgBatch.find_by!(
            academic_year: student_data[:academic_year],
            section_name: student_data[:sibling_section],
            mg_school_id: school_id
          ).id : nil
    
        begin
          sibling_admission_date = student_data[:sibling_date_of_admission].present? ?
            Date.parse(student_data[:sibling_date_of_admission]) : nil
        rescue Date::Error
          raise StandardError, "Sibling admission date should be in YYYY-MM-DD format"
        end
    
        MgSibling.create!(
          mg_user_id: user.id,
          name: student_data[:sibling_name],
          relation: student_data[:sibling_relationship],
          mg_course_id: sibling_class_id,
          mg_batch_id: sibling_section_id,
          roll_no: student_data[:sibling_roll_number],
          admission_date: sibling_admission_date,
          admission_no: student_data[:sibling_admision_number],
          is_sibling: true,
          mg_school_id: school_id,
          created_by: user_id
        )
      end

      MgAddress.create!(
        address_line1: student_data[:address_line1],
        address_line2: student_data[:address_line2],
        address_type: "Temporary",
        landmark: student_data[:landmark],
        city: student_data[:city],
        state: student_data[:state],
        country: student_data[:country],
        pin_code: student_data[:pin_code],
        mg_user_id: user.id,
        mg_school_id: school_id,
        created_by: user_id
      )

      MgAddress.create!(
        address_line1: student_data[:pr_address_line1],
        address_line2: student_data[:pr_address_line2],
        address_type: "Permanent",
        landmark: student_data[:pr_landmark],
        city: student_data[:pr_city],
        state: student_data[:pr_state],
        country: student_data[:pr_country],
        pin_code: student_data[:pr_pin_code],
        mg_user_id: user.id,
        mg_school_id: school_id,
        created_by: user_id
      )

      # Create phone numbers
      MgPhone.create!(
        phone_number: student_data[:mobile_number],
        phone_type: "mobile",
        notification: student_data[:student_notification],
        subscription: student_data[:student_subscription],
        mg_user_id: user.id,
        mg_school_id: school_id,
        created_by: user_id
      )

      if params[:alt_phone_number].present?
        MgPhone.create!(
          phone_number: student_data[:alt_phone_number],
          phone_type: "phone",
          notification: false,
          subscription: false,
          mg_user_id: user.id,
          mg_school_id: school_id,
          created_by: user_id
        )
      end

      # Create previous education
      if params[:prev_school_name].present?
        MgPreviousEducation.create!(
          school_name: student_data[:prev_school_name],
          course: student_data[:prev_class_name],
          grade: student_data[:grade_percentage],
          year: student_data[:year],
          mg_student_id: student.id,
          marks_obtained: student_data[:marks_obtained],
          total_marks: student_data[:total_marks],
          is_transfer_certificate_produced: params[:transfer_certificate].present?,
          mg_school_id: school_id,
          created_by: user_id
        )
      end
      
    end
    
    
   
          
          
    private
    
    def filtered_params(subject)
      allowed_keys = %i[batch_name mg_subject_id is_extra_curricular scoring_type mg_employee_id row_number class_name time_table_name]
      
      raise ArgumentError, 'Subject must be a hash' unless subject.is_a?(Hash)
      
      subject = subject.deep_symbolize_keys
      filtered = subject.slice(*allowed_keys)
    
      # Check for any unexpected keys
      unexpected_keys = subject.keys - allowed_keys
      if unexpected_keys.any?
        raise ArgumentError, "Unexpected parameters found: #{unexpected_keys.join(', ')}"
      end
    
      # If batch_name is provided, find the corresponding mg_batch_id
      if subject[:batch_name].present?
        batch = MgBatch.find_by(batch_name: subject[:batch_name], mg_school_id: school_id)
        if batch
          filtered[:mg_batch_id] = batch.id  # Add mg_batch_id after finding it
        else
          raise ArgumentError, "Batch name '#{subject[:batch_name]}' does not exist in the database."
        end
      end
    
      filtered
    end
      
           
        
    private
    
    def filtered_params(caste)
    allowed_keys = %i[name description row_number]
    caste = caste.deep_symbolize_keys
    filtered = caste.slice(*allowed_keys)
    
    unexpected_keys = caste.keys - allowed_keys
    if unexpected_keys.any?
        raise ArgumentError, "Unexpected parameters found: #{unexpected_keys.join(', ')}"
    end
    
    filtered
    end

    private

    def filtered_params(category)
    allowed_keys = %i[name description row_number]
    category = category.deep_symbolize_keys
    filtered = category.slice(*allowed_keys)

    unexpected_keys = category.keys - allowed_keys
    if unexpected_keys.any?
        raise ArgumentError, "Unexpected parameters found: #{unexpected_keys.join(', ')}"
    end

    filtered
    end
    

    private

    def filtered_params(student_category)
    allowed_keys = %i[name row_number]
    category = student_category.deep_symbolize_keys
    filtered = student_category.slice(*allowed_keys)

    unexpected_keys = student_category.keys - allowed_keys
    if unexpected_keys.any?
        raise ArgumentError, "Unexpected parameters found: #{unexpected_keys.join(', ')}"
    end

    filtered
    end

    private

    def filtered_house_params(house)
    allowed_keys = %i[name description row_number]
    house = house.deep_symbolize_keys
    filtered = house.slice(*allowed_keys)

    unexpected_keys = house.keys - allowed_keys
    if unexpected_keys.any?
        raise ArgumentError, "Unexpected parameters found: #{unexpected_keys.join(', ')}"
    end

    filtered
    end


    

end
