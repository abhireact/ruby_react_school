class UploadExcelSetFiveController < ApplicationController
    layout "mindcom"
    include JsonResponseHelper

    def upload_library_resource_category
        library_resource_categories = params[:data]
        current_time = Time.now
        school_id = session[:current_user_school_id]
        user_id = session[:user_id]
      
        # Step 1: Validate parameters
        unless library_resource_categories.is_a?(Array)
          render_json_response({
            status: 'error',
            message: 'Invalid data format. Expected an array of Library Resource Category.',
            data: {}
          }, :unprocessable_entity) and return
        end
      
        # Step 2: Initialize arrays to track results
        created_library_resource_categories = []
        duplicate_in_excel = []
        duplicate_library_resource_categories = []
        errors = []
      
        seen_library_resource_categories = Set.new # To track accounts already processed in this batch
      
        library_resource_categories.each_with_index do |library_resource, index|
          name = library_resource[:name]
          wing_name = library_resource[:wing_name]
      
          # Step 3: Check for duplicate accounts within the incoming data (Excel file)
          if seen_library_resource_categories.include?(name)
            duplicate_in_excel << {
              row: library_resource[:row_number] || (index + 1),
              name: name,
              error: "Duplicate Library Resource Category '#{name}' found in the uploaded data"
            }
          else
            seen_library_resource_categories.add(name) # Mark this account as processed
          end
      
          # Step 4: Fetch MgUser based on school_id and wing_name
          wing_result = MgWing.find_by(mg_school_id: school_id, wing_name: wing_name, is_deleted: false)
      
          if wing_result.blank?
            # Track invalid rows if no valid wing is found
            errors << {
              row: library_resource[:row_number] || (index + 1),
              name: name,
              error: "Wing Name '#{wing_name}' not found for the current school"
            }
          else
            # Step 5: Check for duplicate accounts in the database (same name and wing_id)
            if MgResourceCategory.exists?(name: name, mg_wing_id: wing_result.id, mg_school_id: school_id, is_deleted: false)
              # Push duplicate account data into a duplicate array with row number
              duplicate_library_resource_categories << {
                row: library_resource[:row_number] || (index + 1),
                name: name,
                error: "Library Resource Category '#{name}' already exists for Wing '#{wing_name}'"
              }
            else
              # Step 6: Create new resource category if no duplicate found
              begin
                MgResourceCategory.create!(
                  name: name,
                  description: library_resource[:description],
                  mg_wing_id: wing_result.id,
                  is_deleted: false,
                  mg_school_id: school_id,
                  created_by: user_id,
                  updated_by: user_id,
                  created_at: current_time,
                  updated_at: current_time
                )
                created_library_resource_categories << { row: library_resource[:row_number] || (index + 1), name: name }
              rescue ActiveRecord::RecordInvalid => e
                # Handle validation errors for invalid rows
                errors << {
                  row: library_resource[:row_number] || (index + 1),
                  name: name,
                  error: e.message
                }
              end
            end
          end
        end
      
        # Step 7: Final response with updated format
        if errors.empty? && duplicate_in_excel.empty? && duplicate_library_resource_categories.empty?
          response = {
            status: 'success',
            message: 'All Library Resource Categories processed successfully',
            data: {
              created: created_library_resource_categories,
              duplicate: [],
              errors: []
            }
          }
        else
          response = {
            status: 'error',
            message: 'Some Library Resource Categories could not be processed',
            data: {
              created: created_library_resource_categories,
              duplicate: errors
              
            }
          }
        end
      
        render_json_response(response, errors.empty? && duplicate_in_excel.empty? && duplicate_library_resource_categories.empty? ? :ok : :unprocessable_entity)
        rescue StandardError => e
        handle_error(e)
    end

    def upload_resource_type
        resource_types = params[:data]
        current_time = Time.now
        school_id = session[:current_user_school_id]
        user_id = session[:user_id]
      
        # Step 1: Validate parameters
        unless resource_types.is_a?(Array)
          render_json_response({
            status: 'error',
            message: 'Invalid data format. Expected an array of Resource Types.',
            data: {
              created: [],
              duplicate: [],
              errors: ['Invalid data format']
            }
          }, :unprocessable_entity) and return
        end
      
        # Step 2: Initialize arrays to track results
        created_resource_types = []
        duplicate_in_excel = []
        duplicate_in_db = []
        errors = []
      
        seen_resource_types = Set.new # To track duplicates within the incoming data
      
        resource_types.each_with_index do |resource, index|
          wing_name = resource[:wing_name]
          resource_category_name = resource[:resource_category]
          name = resource[:name]
          description = resource[:description]
          is_non_issuable = resource[:is_non_issuable].to_s.casecmp("YES").zero?
          max_issuable_count = resource[:max_issuable_count]
          max_borrow_day = resource[:max_borrow_day]
          renewal_period = resource[:renewal_period]
          max_renewals_allowed = resource[:max_renewals_allowed]
          fine_per_day = resource[:fine_per_day]
          prefix = resource[:prefix]
          user_type = resource[:user_type]&.downcase
      
          # Step 3: Check for duplicates within the incoming data
          if seen_resource_types.include?(name)
            duplicate_in_excel << {
              row: resource[:row_number] || (index + 1),
              name: name,
              error: "Duplicate Resource Type '#{name}' found in the uploaded data"
            }
            next
          else
            seen_resource_types.add(name)
          end
      
          # Step 4: Validate wing and resource category
          wing = MgWing.find_by(mg_school_id: school_id, wing_name: wing_name, is_deleted: false)
          unless wing
            errors << {
              row: resource[:row_number] || (index + 1),
              name: name,
              error: "Invalid Wing Name: '#{wing_name}'"
            }
            next
          end
      
          resource_category = MgResourceCategory.find_by(
            mg_school_id: school_id,
            mg_wing_id: wing.id,
            name: resource_category_name,
            is_deleted: false
          )
          unless resource_category
            errors << {
              row: resource[:row_number] || (index + 1),
              name: name,
              error: "Invalid Resource Category Name: '#{resource_category_name}' for Wing: '#{wing_name}'"
            }
            next
          end
      
          # Step 5: Check for duplicates in the database
          if MgResourceType.exists?(
               name: name,
               mg_resource_category_id: resource_category.id,
               mg_school_id: school_id,
               is_deleted: false
             )
            duplicate_in_db << {
              row: resource[:row_number] || (index + 1),
              name: name,
              error: "Resource Type '#{name}' already exists for the category '#{resource_category_name}'"
            }
            next
          end
      
          # Step 6: Create new resource type
          begin
            resource_type = MgResourceType.create!(
              name: name,
              description: description,
              prefix: prefix,
              is_non_issuable: is_non_issuable,
              max_issuable_count: max_issuable_count,
              max_borrow_day: max_borrow_day,
              renewal_period: renewal_period,
              max_renewals_allowed: max_renewals_allowed,
              fine_per_day: fine_per_day,
              mg_resource_category_id: resource_category.id,
              mg_school_id: school_id,
              created_by: user_id,
              updated_by: user_id,
              created_at: current_time,
              updated_at: current_time
            )
            created_resource_types << {
              row: resource[:row_number] || (index + 1),
              name: name
            }
      
            # Save the association with user type
            MgResourceTypeAssociation.create!(
              mg_resource_type_id: resource_type.id,
              user_type: user_type,
              is_deleted: false,
              mg_school_id: school_id,
              created_by: user_id,
              updated_by: user_id,
              created_at: current_time,
              updated_at: current_time
            )
          rescue ActiveRecord::RecordInvalid => e
            errors << {
              row: resource[:row_number] || (index + 1),
              name: name,
              error: e.message
            }
          end
        end
      
        # Step 7: Prepare the final response
        if errors.empty? && duplicate_in_excel.empty? && duplicate_in_db.empty?
          response = {
            status: 'success',
            message: 'All Resource Types processed successfully',
            data: {
              created: created_resource_types,
              duplicate: [],
              errors: []
            }
          }
        else
          response = {
            status: 'error',
            message: 'Some Resource Types could not be processed',
            data: {
              created: created_resource_types,
              duplicate: duplicate_in_excel + duplicate_in_db + errors
            }
          }
        end
      
        render_json_response(response, errors.empty? && duplicate_in_excel.empty? && duplicate_in_db.empty? ? :ok : :unprocessable_entity)
      rescue StandardError => e
        handle_error(e)
    end

    def upload_library_subjects
        library_subjects = params[:data]  # Assuming the file data is passed as an array of hashes
        current_time = Time.now
        school_id = session[:current_user_school_id]
        user_id = session[:user_id]
        
        # Step 1: Validate parameters
        unless library_subjects.is_a?(Array)
          render_json_response({
            status: 'error',
            message: 'Invalid data format. Expected an array of Library Subjects.',
            data: {}
          }, :unprocessable_entity) and return
        end
        
        # Step 2: Initialize arrays to track results
        created_library_subjects = []
        duplicate_in_excel = []
        duplicate_library_subjects = []
        errors = []
        
        seen_library_subjects = Set.new # To track subjects already processed in this batch
        
        library_subjects.each_with_index do |subject_data, index|
          name = subject_data[:name]
          description = subject_data[:description]
        
          # Step 3: Check for duplicate subjects within the incoming data (Excel file)
          if seen_library_subjects.include?(name)
            duplicate_in_excel << {
              row: subject_data[:row_number] || (index + 1),
              name: name,
              error: "Duplicate Library Subject '#{name}' found in the uploaded data"
            }
          else
            seen_library_subjects.add(name) # Mark this subject as processed
          end
        
          # Step 4: Check if subject already exists in the database
          existing_subject = MgManageSubject.find_by(is_deleted: false, mg_school_id: school_id, name: name)
          
          if existing_subject.present?
            # Track duplicate subjects from the database
            duplicate_library_subjects << {
              row: subject_data[:row_number] || (index + 1),
              name: name,
              error: "Library Subject  already exists"
            }
          else
            # Step 5: Create new subject if no duplicate found
            begin
              new_subject = MgManageSubject.create!(
                name: name,
                description: description,
                mg_school_id: school_id,
                is_deleted: false,
                created_by: user_id,
                updated_by: user_id,
                created_at: current_time,
                updated_at: current_time
              )
              created_library_subjects << { row: subject_data[:row_number] || (index + 1), name: name }
            rescue ActiveRecord::RecordInvalid => e
              # Handle validation errors for invalid rows
              errors << {
                row: subject_data[:row_number] || (index + 1),
                name: name,
                error: e.message
              }
            end
          end
        end
        
        # Step 6: Final response with updated format
        if errors.empty? && duplicate_in_excel.empty? && duplicate_library_subjects.empty?
          response = {
            status: 'success',
            message: 'All Library Subjects processed successfully',
            data: {
              created: created_library_subjects,
              duplicate: [],
              errors: []
            }
          }
        else
          response = {
            status: 'error',
            message: 'Some Library Subjects could not be processed',
            data: {
              created: created_library_subjects,
              duplicate: duplicate_in_excel + duplicate_library_subjects + errors
            }
          }
        end
        
        render_json_response(response, errors.empty? && duplicate_in_excel.empty? && duplicate_library_subjects.empty? ? :ok : :unprocessable_entity)
      rescue StandardError => e
        handle_error(e)
    end

    def upload_library_stack
        library_stack_data = params[:data]  # Assuming the file data is passed as an array of hashes
        current_time = Time.now
        school_id = session[:current_user_school_id]
        user_id = session[:user_id]
      
        # Step 1: Validate parameters
        unless library_stack_data.is_a?(Array)
          render_json_response({
            status: 'error',
            message: 'Invalid data format. Expected an array of Library Stack data.',
            data: {}
          }, :unprocessable_entity) and return
        end
      
        # Step 2: Initialize arrays to track results
        created_library_stack = []
        duplicate_in_excel = []
        duplicate_library_stack = []
        errors = []
      
        seen_library_stack = Set.new # To track stacks already processed in this batch
      
        library_stack_data.each_with_index do |stack_data, index|
          room = stack_data[:room_no]
          rack = stack_data[:rack_no]
          title = stack_data[:first_letter_of_title]
      
          # Step 3: Check for duplicate stacks within the incoming data (Excel file)
          if seen_library_stack.include?([room, rack, title])
            duplicate_in_excel << {
              row: stack_data[:row_number] || (index + 1),
              room: room,
              rack: rack,
              title: title,
              error: "Duplicate Library Stack found in the uploaded data"
            }
          else
            seen_library_stack.add([room, rack, title]) # Mark this stack as processed
          end
      
          # Step 4: Check if the stack already exists in the database
          existing_stack = MgLibraryStackManagement.find_by(
            is_deleted: false,
            mg_school_id: school_id,
            room_no: room,
            rack_no: rack,
            first_letter_of_title: title
          )
      
          if existing_stack.present?
            # Track duplicate stacks from the database
            duplicate_library_stack << {
              row: stack_data[:row_number] || (index + 1),
            #   room: room,
            #   rack: rack,
            #   title: title,
              error: "Library Stack already exists  #{room} - #{rack} - #{title}"
            }
          else
            # Step 5: Create a new library stack if no duplicate found
            begin
              new_stack = MgLibraryStackManagement.create!(
                room_no: room,
                rack_no: rack,
                first_letter_of_title: title,
                mg_school_id: school_id,
                is_deleted: false,
                created_by: user_id,
                updated_by: user_id,
                created_at: current_time,
                updated_at: current_time
              )
              created_library_stack << { 
                row: stack_data[:row_number] || (index + 1), 
                room: room, 
                rack: rack, 
                title: title  # Include the title in the success response
              }
            rescue ActiveRecord::RecordInvalid => e
              # Handle validation errors for invalid rows
              errors << {
                row: stack_data[:row_number] || (index + 1),
                room: room,
                rack: rack,
                title: title,
                error: e.message
              }
            end
          end
        end
      
        # Step 6: Final response with updated format
        if errors.empty? && duplicate_in_excel.empty? && duplicate_library_stack.empty?
          response = {
            status: 'success',
            message: 'All Library Stacks processed successfully',
            data: {
              created: created_library_stack,
              duplicate: [],
              errors: []
            }
          }
        else
          response = {
            status: 'error',
            message: 'Some Library Stacks could not be processed',
            data: {
              created: created_library_stack,
              duplicate: duplicate_in_excel + duplicate_library_stack + errors
            }
          }
        end
      
        render_json_response(response, errors.empty? && duplicate_in_excel.empty? && duplicate_library_stack.empty? ? :ok : :unprocessable_entity)
      rescue StandardError => e
        handle_error(e)
    end

    def upload_library_resources_inventory
        library_resources = params[:data]  # Assuming the file data is passed as an array of hashes
        current_time = Time.now
        school_id = session[:current_user_school_id]
        user_id = session[:user_id]
        
        # Step 1: Validate parameters
        unless library_resources.is_a?(Array)
          render_json_response({
            status: 'error',
            message: 'Invalid data format. Expected an array of Library Resources.',
            data: {}
          }, :unprocessable_entity) and return
        end
        
        # Step 2: Initialize arrays to track results
        created_library_resources = []
        duplicate_in_excel = []
        duplicate_library_resources = []
        errors = []
        
        seen_resources = Set.new # To track resources already processed in this batch
        
        library_resources.each_with_index do |resource_data, index|
          wing_name = resource_data[:wing_name]
          resource_category = resource_data[:resource_category]
          resource_type = resource_data[:resource_type]
          resource_no = resource_data[:resource_no]
          name = resource_data[:name]
          author = resource_data[:author]
          edition = resource_data[:edition]
          year = resource_data[:year]
          publications = resource_data[:publications]
          isbn = resource_data[:isbn]
          subject = resource_data[:subject]
          classes = resource_data[:classes]
          room = resource_data[:room]
          rack = resource_data[:rack]
          title = resource_data[:title]
          cost = resource_data[:cost]
          non_issuable = resource_data[:non_issuable]
          is_lost = resource_data[:is_lost]
          damaged = resource_data[:damaged]
          
          # Step 3: Check for duplicate resources within the incoming data (Excel file)
          if seen_resources.include?(resource_no)
            duplicate_in_excel << {
              row: resource_data[:row_number] || (index + 1),
              resource_no: resource_no,
              error: "Duplicate Resource Number '#{resource_no}' found in the uploaded data"
            }
          else
            seen_resources.add(resource_no) # Mark this resource as processed
          end
      
          # Step 4: Check if resource already exists in the database
          existing_resource = MgResourceInventory.find_by(is_deleted: false, mg_school_id: school_id, resource_number: resource_no)
          
          if existing_resource.present?
            # Track duplicate resources from the database
            duplicate_library_resources << {
              row: resource_data[:row_number] || (index + 1),
              resource_no: resource_no,
              error: "Resource Number '#{resource_no}' already exists"
            }
          else
            # Step 5: Create new resource if no duplicate found
            begin
              wing_id = MgWing.find_by(mg_school_id: school_id, is_deleted: false, wing_name: wing_name.strip)
              if wing_id.present?
                resource_category_id = MgResourceCategory.where(is_deleted: false, mg_school_id: school_id, mg_wing_id: wing_id.id)
                resource_type_id = MgResourceType.where(is_deleted: false, mg_school_id: school_id, mg_resource_category_id: resource_category_id.first.id)
                subject_type = MgManageSubject.where(is_deleted: false, mg_school_id: school_id).where(MgManageSubject.arel_table[:name].matches(subject))
                stack_ref = MgLibraryStackManagement.find_by(is_deleted: false, mg_school_id: school_id, room_no: room, rack_no: rack, first_letter_of_title: title)
                
                # Handle resource number assignment
                resource_inventory = MgResourceInventory.where(mg_school_id: school_id, mg_resource_type_id: resource_type_id.first.id).count
                resource_number = if resource_no.present?
                                    resource_no
                                  else
                                    last_record = MgResourceInventory.where("resource_number like ?", "%#{resource_type_id.first.prefix}%")
                                                                      .where(mg_school_id: school_id, mg_resource_type_id: resource_type_id.first.id)
                                                                      .last
                                    last_resource_number = last_record ? last_record.resource_number.slice(resource_type_id.first.prefix.length..-1).to_i : 0
                                    next_resource_number = last_resource_number + 1
                                    resource_type_id.first.prefix + next_resource_number.to_s
                                  end
                
                # Create new resource inventory entry
                new_resource_inventory = MgResourceInventory.create!(
                  mg_resource_category_id: resource_category_id.first.id,
                  resource_number: resource_number,
                  mg_resource_type_id: resource_type_id.first.id,
                  name: name,
                  author: author,
                  volume: edition,
                  year: year,
                  publication: publications,
                  isbn: isbn,
                  mg_course_id: classes,
                  mg_subject_id: subject_type.first.id,
                  stack_reference: stack_ref.id,
                  cost: cost,
                  non_issuable: non_issuable == "YES",
                  is_damaged: damaged == "YES",
                  is_lost: is_lost == "YES",
                  status: "On-shelf",
                  mg_school_id: school_id,
                  created_by: user_id,
                  updated_by: user_id,
                  created_at: current_time,
                  updated_at: current_time
                )
      
                created_library_resources << { row: resource_data[:row_number] || (index + 1), resource_no: resource_number }
              else
                errors << { row: resource_data[:row_number] || (index + 1), error: "Wing Name '#{wing_name}' not found" }
              end
            rescue => e
              errors << { row: resource_data[:row_number] || (index + 1), error: "Error creating resource: #{e.message}" }
            end
          end
        end
        
        # Step 6: Build the response based on the conditions
        if errors.empty? && duplicate_in_excel.empty? && duplicate_library_resources.empty?
          response = {
            status: 'success',
            message: 'Library resources uploaded successfully',
            data: {
              created: created_library_resources,
              duplicate: [],
              errors: []
            }
          }
        else
          response = {
            status: 'error',
            message: 'Some Library Resources could not be processed',
            data: {
              created: created_library_resources,
              duplicate: duplicate_in_excel + duplicate_library_resources + errors
            }
          }
        end
      
        # Return the response as JSON
        render_json_response(response, errors.empty? && duplicate_in_excel.empty? && duplicate_library_resources.empty? ? :ok : :unprocessable_entity)
    end

    def upload_library_incharge
        # Step 1: Retrieve the incoming data
        library_incharge_data = params[:data]
        current_time = Time.now
        school_id = session[:current_user_school_id]
        user_id = session[:user_id]
        
        # Step 2: Validate the data format
        unless library_incharge_data.is_a?(Array)
          render_json_response({
            status: 'error',
            message: 'Invalid data format. Expected an array of Library Incharge data.',
            data: {
              created: [],
              duplicate: [],
              errors: ['Invalid data format']
            }
          }, :unprocessable_entity) and return
        end
        
        # Step 3: Initialize arrays to track results
        created_library_incharges = []
        duplicate_in_excel = []
        duplicate_in_db = []
        errors = []
        
        seen_user_names = Set.new # To track duplicates within the incoming data
        
        # Step 4: Iterate through each record in the data
        library_incharge_data.each_with_index do |incharge, index|
          user_name = incharge[:user_name]
          password = incharge[:password]
          
          # Step 5: Check for blank user_name
          if user_name.blank?
            errors << {
              row: incharge[:row_number] || (index + 1),
              user_name: user_name,
              error: "User Name can't be blank"
            }
            next
          end
      
          # Step 6: Check for duplicates within the incoming data
          if seen_user_names.include?(user_name)
            duplicate_in_excel << {
              row: incharge[:row_number] || (index + 1),
              user_name: user_name,
              error: "Duplicate User Name '#{user_name}' found in the uploaded data"
            }
            next
          else
            seen_user_names.add(user_name)
          end
      
          # Step 7: Validate user and school data
          school = MgSchool.find_by(id: school_id)
          unless school
            errors << {
              row: incharge[:row_number] || (index + 1),
              user_name: user_name,
              error: "Invalid School ID: '#{school_id}'"
            }
            next
          end
      
          # Step 8: Check for duplicates in the database
          if MgUser.exists?(user_name: user_name, mg_school_id: school_id, is_deleted: false)
            duplicate_in_db << {
              row: incharge[:row_number] || (index + 1),
              user_name: user_name,
              error: "User Name '#{user_name}' already exists in the database"
            }
            next
          end
      
          # Step 9: Create new Library Incharge user
          begin
            user_name_with_subdomain = school.subdomain.to_s + user_name
            user = MgUser.create!(
              user_name: user_name_with_subdomain,
              user_type: "library_incharge",
              password: password,
              is_deleted: 0,
              mg_school_id: school_id,
              created_by: user_id,
              updated_by: user_id,
              first_name: user_name
            )
            # Create role if it doesn't exist
            role = MgRole.find_or_create_by(role_name: "library_incharge", description: "library_incharge", created_at: current_time, updated_at: current_time, mg_school_id: school_id)
      
            # Step 10: Assign role to user
            user_role = user.mg_user_roles.create!(
              mg_role_id: role.id,
              mg_user_id: user.id
            )
      
            created_library_incharges << {
              row: incharge[:row_number] || (index + 1),
              user_name: user_name
            }
          rescue ActiveRecord::RecordInvalid => e
            errors << {
              row: incharge[:row_number] || (index + 1),
              user_name: user_name,
              error: e.message
            }
          end
        end
        
        # Step 11: Prepare the final response
        if errors.empty? && duplicate_in_excel.empty? && duplicate_in_db.empty?
          response = {
            status: 'success',
            message: 'All Library Incharge records processed successfully',
            data: {
              created: created_library_incharges,
              duplicate: [],
              errors: []
            }
          }
        else
          response = {
            status: 'error',
            message: 'Some Library Incharge records could not be processed',
            data: {
              created: created_library_incharges,
              duplicate: duplicate_in_excel + duplicate_in_db + errors
            }
          }
        end
        
        render_json_response(response, errors.empty? && duplicate_in_excel.empty? && duplicate_in_db.empty? ? :ok : :unprocessable_entity)
      rescue StandardError => e
        handle_error(e)
    end

    def upload_library_assistant_incharge
        # Step 1: Retrieve the incoming data
        library_assistant_data = params[:data]
        current_time = Time.now
        school_id = session[:current_user_school_id]
        user_id = session[:user_id]
      
        # Step 2: Validate the data format
        unless library_assistant_data.is_a?(Array)
          render_json_response({
            status: 'error',
            message: 'Invalid data format. Expected an array of Library Assistant Incharge data.',
            data: {
              created: [],
              duplicate: [],
              errors: ['Invalid data format']
            }
          }, :unprocessable_entity) and return
        end
      
        # Step 3: Initialize arrays to track results
        created_library_assistants = []
        duplicate_in_excel = []
        duplicate_in_db = []
        errors = []
      
        seen_user_names = Set.new # To track duplicates within the incoming data
      
        # Step 4: Iterate through each record in the data
        library_assistant_data.each_with_index do |assistant, index|
          user_name = assistant[:user_name]
          password = assistant[:password]
      
          # Step 5: Check for blank user_name
          if user_name.blank?
            errors << {
              row: assistant[:row_number] || (index + 1),
              user_name: user_name,
              error: "User Name can't be blank"
            }
            next
          end
      
          # Step 6: Check for duplicates within the incoming data
          if seen_user_names.include?(user_name)
            duplicate_in_excel << {
              row: assistant[:row_number] || (index + 1),
              user_name: user_name,
              error: "Duplicate User Name '#{user_name}' found in the uploaded data"
            }
            next
          else
            seen_user_names.add(user_name)
          end
      
          # Step 7: Validate user and school data
          school = MgSchool.find_by(id: school_id)
          unless school
            errors << {
              row: assistant[:row_number] || (index + 1),
              user_name: user_name,
              error: "Invalid School ID: '#{school_id}'"
            }
            next
          end
      
          # Step 8: Check for duplicates in the database
          if MgUser.exists?(user_name: user_name, mg_school_id: school_id, is_deleted: false)
            duplicate_in_db << {
              row: assistant[:row_number] || (index + 1),
              user_name: user_name,
              error: "User Name '#{user_name}' already exists in the database"
            }
            next
          end
      
          # Step 9: Create new Library Assistant Incharge user
          begin
            user_name_with_subdomain = school.subdomain.to_s + user_name
            user = MgUser.create!(
              user_name: user_name_with_subdomain,
              user_type: "library_assistant_incharge",
              password: password,
              is_deleted: 0,
              mg_school_id: school_id,
              created_by: user_id,
              updated_by: user_id,
              first_name: user_name
            )
      
            # Step 10: Create role if it doesn't exist
            role = MgRole.find_or_create_by(role_name: "library_assistant_incharge", description: "library_assistant_incharge", created_at: current_time, updated_at: current_time, mg_school_id: school_id)
      
            # Step 11: Assign role to user
            user_role = user.mg_user_roles.create!(
              mg_role_id: role.id,
              mg_user_id: user.id
            )
      
            created_library_assistants << {
              row: assistant[:row_number] || (index + 1),
              user_name: user_name
            }
          rescue ActiveRecord::RecordInvalid => e
            errors << {
              row: assistant[:row_number] || (index + 1),
              user_name: user_name,
              error: e.message
            }
          end
        end
      
        # Step 12: Prepare the final response
        if errors.empty? && duplicate_in_excel.empty? && duplicate_in_db.empty?
          response = {
            status: 'success',
            message: 'All Library Assistant Incharge records processed successfully',
            data: {
              created: created_library_assistants,
              duplicate: [],
              errors: []
            }
          }
        else
          response = {
            status: 'error',
            message: 'Some Library Assistant Incharge records could not be processed',
            data: {
              created: created_library_assistants,
              duplicate: duplicate_in_excel + duplicate_in_db + errors
            }
          }
        end
      
        render_json_response(response, errors.empty? && duplicate_in_excel.empty? && duplicate_in_db.empty? ? :ok : :unprocessable_entity)
      rescue StandardError => e
        handle_error(e)
    end

    def kiosk_cloudadmin_upload
        # Step 1: Get the data from the request (assuming it's an array of user data)
        kiosk_data = params[:data] 
        current_time = Time.now
        school_id = session[:current_user_school_id]
        user_id = session[:user_id]
      
        # Step 2: Validate parameters
        unless kiosk_data.is_a?(Array)
          render_json_response({
            status: 'error',
            message: 'Invalid data format. Expected an array of kiosk details.',
            data: {}
          }, :unprocessable_entity) and return
        end
      
        # Step 3: Initialize arrays to track results
        created_users = []
        duplicate_in_data = []
        duplicate_users = []
        errors = []
        
        seen_usernames = Set.new # To track accounts already processed in this batch
      
        # Step 4: Loop through each kiosk data entry
        kiosk_data.each_with_index do |user_data, index|
          user_name = user_data[:user_name]
          password = user_data[:password]
      
          # Step 5: Check for duplicate usernames within the incoming data
          if seen_usernames.include?(user_name)
            duplicate_in_data << {
              row: user_data[:row_number] || (index + 1),
              user_name: user_name,
              error: "Duplicate User Name '#{user_name}' found in the uploaded data"
            }
          else
            seen_usernames.add(user_name) # Mark this user as processed
          end
      
          # Step 6: Check for an existing user in the database
          existing_user = MgUser.find_by(user_name: user_name, mg_school_id: school_id, is_deleted: false)
          
          if existing_user
            duplicate_users << {
              row: user_data[:row_number] || (index + 1),
              user_name: user_name,
              error: "User '#{user_name}' already exists for the current school"
            }
          else
            # Step 7: Create new user if no duplicate found
            begin
              school = MgSchool.find_by(id: school_id)
              raise "School not found" if school.nil?
      
              user = MgUser.new(
                user_type: "kiosk",
                password: password,
                is_deleted: 0,
                mg_school_id: school_id,
                created_by: user_id,
                updated_by: user_id,
                first_name: user_name
              )
              
              user_name_with_subdomain = school.subdomain.to_s + user_name
              user.user_name = user_name_with_subdomain
      
              if user.save
                # Step 8: Assign role to user if role exists
                role = MgRole.find_or_create_by(role_name: "kiosk", description: "kiosk")
                user_role = user.mg_user_roles.build(mg_role_id: role.id, mg_user_id: user.id)
                
                if user_role.save
                  created_users << { row: user_data[:row_number] || (index + 1), user_name: user_name }
                else
                  errors << {
                    row: user_data[:row_number] || (index + 1),
                    user_name: user_name,
                    error: "Failed to assign role to user '#{user_name}'"
                  }
                end
              else
                errors << {
                  row: user_data[:row_number] || (index + 1),
                  user_name: user_name,
                  error: "Failed to create user '#{user_name}'. Validation error or missing field."
                }
              end
            rescue ActiveRecord::RecordInvalid => e
              errors << {
                row: user_data[:row_number] || (index + 1),
                user_name: user_name,
                error: "User Already Exist '#{user_name}': #{e.message}"
              }
            rescue StandardError => e
              errors << {
                row: user_data[:row_number] || (index + 1),
                user_name: user_name,
                error: "An unexpected error occurred for user '#{user_name}': #{e.message}"
              }
            end
          end
        end
      
        # Step 9: Final response with updated format
        if errors.empty? && duplicate_in_data.empty? && duplicate_users.empty?
          response = {
            status: 'success',
            message: 'All kiosk users processed successfully',
            data: {
              created: created_users,
              duplicate: [],
              errors: []
            }
          }
        else
          response = {
            status: 'error',
            message: 'Some kiosk users could not be processed',
            data: {
              created: created_users,
              duplicate: duplicate_users + errors
            }
          }
        end
      
        render_json_response(response, errors.empty? && duplicate_in_data.empty? && duplicate_users.empty? ? :ok : :unprocessable_entity)
      rescue StandardError => e
        handle_error(e)
    end
      
      
      
      
      
      
    
      
      
      

end
