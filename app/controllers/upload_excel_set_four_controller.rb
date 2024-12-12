class UploadExcelSetFourController < ApplicationController

def fee_data_exists
    school_id = session[:current_user_school_id]
        # Perform checks for all the entities
        fee_category_exists = MgFeeCategory.exists?(is_deleted: 0, mg_school_id: school_id)
        fee_particular_exists = MgFeeParticular.exists?(is_deleted: 0, mg_school_id: school_id)
        fee_discount_exists = MgFeeDiscount.exists?(mg_school_id: school_id, is_deleted: 0)
        late_fine_exists = MgFeeFine.exists?(is_deleted: 0, mg_school_id: school_id)

        # Render the results as a JSON object
        render json: {
          fee_category_exists: fee_category_exists,
          fee_particular_exists: fee_particular_exists,
          fee_discount_exists: fee_discount_exists,
          late_fine_exists: late_fine_exists,
 
        }
end

def upload_fee_category
  current_time = Time.now
  school_id = session[:current_user_school_id]
  user_id = session[:user_id]

  # Arrays to track results
  created_categories = []
  duplicate_categories = []

  # Validate input
  unless params[:data].is_a?(Array)
    return render_json_response({
      status: 'error',
      message: 'Invalid data format. Expected an array of fee categories.',
      data: {}
    }, :unprocessable_entity)
  end

  # Sanitize and prepare fee categories
  @fee_categories = params.require(:data).map do |category|
    category.permit(:name, :description, :particulars, :row_number).to_h
  end

  # Check for duplicates first
  existing_categories = MgFeeCategory.where(
    name: @fee_categories.map { |cat| cat[:name] },
    mg_school_id: school_id,
    is_deleted: false
  ).pluck(:name).to_set

  ActiveRecord::Base.transaction do
    @fee_categories.each_with_index do |category, index|
      name = category[:name]
      particulars = category[:particulars]
      description = category[:description]

      if existing_categories.include?(name)
        duplicate_categories << {
          row: category[:row_number] || (index + 1),
          name: name,
          error: "Fee Category '#{name}' already exists"
        }
      else
        begin
          # Create the fee category
          fee_category = MgFeeCategory.create!(
            name: name,
            description: description,
            is_deleted: false,
            mg_school_id: school_id,
            created_by: user_id,
            updated_by: user_id,
            created_at: current_time,
            updated_at: current_time
          )
          
          # Create the particular if it doesn't already exist
          unless MgParticularType.exists?(
            particular_name: particulars,
            mg_fee_category_id: fee_category.id,
            mg_school_id: school_id,
            is_deleted: false
          )
            MgParticularType.create!(
              particular_name: particulars,
              mg_fee_category_id: fee_category.id,
              is_deleted: false,
              mg_school_id: school_id,
              created_by: user_id,
              updated_by: user_id,
              created_at: current_time,
              updated_at: current_time
            )
          else
            duplicate_categories << {
              row: category[:row_number] || (index + 1),
              name: "#{name}(#{particulars})",
              error: "Particular '#{particulars}' already exists for Fee Category '#{name}'"
            }
          end

          created_categories << { 
            row: category[:row_number] || (index + 1), 
            name: name 
          }
          
        rescue ActiveRecord::RecordInvalid => e
          duplicate_categories << {
            row: category[:row_number] || (index + 1),
            name: name,
            error: e.message
          }
          raise ActiveRecord::Rollback
        end
      end
    end

    # If there are duplicates or errors, raise a rollback to undo any created records
    if duplicate_categories.any?
      raise ActiveRecord::Rollback
    end
  end

  # Prepare the response
  if duplicate_categories.any?
    render_json_response({
      status: 'error',
      message: 'Some Fee Categories could not be processed. No categories were created.',
      data: {
        created: created_categories,
        duplicate: duplicate_categories
      }
    }, :unprocessable_entity)
  else
    render_json_response({
      status: 'success',
      message: 'All Fee Categories processed successfully',
      data: {
        created: created_categories
      }
    }, :ok)
  end
rescue StandardError => e
  handle_error(e)
end






def save_audit_fields(object,mg_school_id)
  object.mg_school_id=mg_school_id
  object.created_by=session[:user_id]
  object.updated_by=session[:user_id]
  object.created_at=DateTime.now
  object.updated_at=DateTime.now
  object.is_deleted=false
 end
def upload_fee_particular
  current_time = Time.now
  school_id = session[:current_user_school_id]
  user_id = session[:user_id]

  created_particulars = []
  duplicate_particulars = []

  # Validate input
  unless params[:data].is_a?(Array)
    return render_json_response({
      status: 'error',
      message: 'Invalid data format. Expected an array of fee particulars.',
      data: {}
    }, :unprocessable_entity)
  end

  ActiveRecord::Base.transaction do
    params[:data].each_with_index do |entry, index|
      fee_category_name = entry["fee_category"]
      fee_particular_name = entry["fee_particular"]
      account = entry["account"]
      amount = entry["amount"]
      academic_year_name = entry["academic_year_name"]
      class_data = entry["class_data"]
      section_data = entry["section_data"]
      student_f_name = entry["student_f_name"]
      student_l_name = entry["student_l_name"]
      date_of_birth = entry["date_of_birth"]
      student_category = entry["student_category"]
      description = entry["description"]

      category = MgFeeCategory.where(
        is_deleted: 0,
        mg_school_id: school_id
      ).where(MgFeeCategory.arel_table[:name].matches(fee_category_name.rstrip)).first

      if category.present?
        particular_type = MgParticularType.where(
          is_deleted: 0,
          mg_school_id: school_id,
          mg_fee_category_id: category.id
        ).where(MgParticularType.arel_table[:particular_name].matches(fee_particular_name.rstrip)).first

        time_table_id = MgTimeTable.find_by(
          is_deleted: 0,
          mg_school_id: school_id,
          name: academic_year_name
        )

        course_data = MgCourse.where(
          is_deleted: 0,
          mg_school_id: school_id,
          mg_time_table_id: time_table_id&.id
        ).where(MgCourse.arel_table[:code].matches(class_data.rstrip)).first

        batch_data = MgBatch.find_by(
          mg_course_id: course_data&.id,
          is_deleted: 0,
          mg_school_id: school_id,
          name: section_data.rstrip
        )

        account_data = MgAccount.where(
          is_deleted: 0,
          mg_school_id: school_id
        ).where(MgAccount.arel_table[:mg_account_name].matches(account.rstrip)).first

        student = nil
        if student_f_name.present? && batch_data.present?
          dob_condition = date_of_birth.present? && date_of_birth != "30/12/1899" ? 
                            { date_of_birth: Date.parse(date_of_birth).to_s(:db) } : {}
          student = MgStudent.find_by({
            is_deleted: 0,
            mg_school_id: school_id,
            is_archive: 0,
            first_name: student_f_name,
            last_name: student_l_name,
            mg_batch_id: batch_data.id
          }.merge(dob_condition))
        end

        student_cat = MgStudentCategory.where(
          is_deleted: 0,
          mg_school_id: school_id
        ).where("trim(name) = ?", student_category.rstrip).first if student_category.present?

        duplicate_data = MgFeeParticular.where(
          fee_category: category.id,
          mg_batch_id: batch_data&.id,
          mg_particular_type_id: particular_type&.id,
          is_deleted: 0,
          admission_no: student&.admission_number,
          mg_student_category_id: student_cat&.id
        ).exists?

        unless duplicate_data
          fee_particular = MgFeeParticular.new(
            fee_category: category.id,
            amount: amount,
            mg_batch_id: batch_data&.id,
            mg_particular_type_id: particular_type&.id,
            mg_account_id: account_data&.id,
            description: description.presence,
            admission_no: student&.admission_number,
            mg_student_category_id: student_cat&.id,
            is_to_central: account.casecmp("Central") == 0
          )

          save_audit_fields(fee_particular, school_id)
          if fee_particular.save
            created_particulars << { row: index + 1, name: fee_particular_name }
          else
            duplicate_particulars << {
              row: index + 1,
              name: fee_particular_name,
              error: fee_particular.errors.full_messages.join(", ")
            }
          end
        else
          duplicate_particulars << {
            row: index + 1,
            name: fee_particular_name,
            error: "Duplicate Fee Particular '#{fee_particular_name}'"
          }
        end
      else
        duplicate_particulars << {
          row: index + 1,
          name: fee_category_name,
          error: "Fee Category '#{fee_category_name}' not found"
        }
      end
    end

    # If there are duplicates or errors, raise a rollback to undo any created records
    raise ActiveRecord::Rollback if duplicate_particulars.any?
  end

  # Prepare the response
  if duplicate_particulars.any?
    render_json_response({
      status: 'error',
      message: 'Some Fee Particulars could not be processed. No particulars were created.',
      data: {
        created: created_particulars,
        duplicate: duplicate_particulars
      }
    }, :unprocessable_entity)
  else
    render_json_response({
      status: 'success',
      message: 'All Fee Particulars processed successfully',
      data: {
        created: created_particulars
      }
    }, :ok)
  end
rescue StandardError => e
  handle_error(e)
end



def upload_fee_discount
  current_time = Time.now
  school_id = session[:current_user_school_id]
  user_id = session[:user_id]

  created_discounts = []
  duplicate_discounts = []

  # Validate input: Ensure data is an array
  unless params[:data].is_a?(Array)
    return render_json_response({
      status: 'error',
      message: 'Invalid data format. Expected an array of fee discounts.',
      data: {}
    }, :unprocessable_entity)
  end

  ActiveRecord::Base.transaction do
    params[:data].each_with_index do |entry, index|
      discount_type = entry["discount_type"]
      discount_name = entry["discount_name"]
      class_data = entry["class_code"]
      section = entry["section"]
      student_f_name = entry["student_first_name"]
      student_last_name = entry["student_last_name"]
      dob = entry["date_of_birth"]
      student_category = entry["student_category"]
      category_name = entry["fee_category"]
      discount_amount = entry["discount"]

      # Find the fee category
      category = MgFeeCategory.where(is_deleted: 0, mg_school_id: school_id)
                               .where(MgFeeCategory.arel_table[:name].matches(category_name.rstrip)).first

      # Find the student category if needed
      student_category_data = MgStudentCategory.where(is_deleted: 0, mg_school_id: school_id)
                                               .where(MgStudentCategory.arel_table[:name].matches(student_category.rstrip))

      # Find the course and batch data
      course_data = MgCourse.where(is_deleted: 0, mg_school_id: school_id)
                            .where(MgCourse.arel_table[:code].matches(class_data.rstrip)).first

      batch_data = MgBatch.find_by(mg_course_id: course_data&.id, is_deleted: 0, mg_school_id: school_id)

      # Find the student
      student_data = MgStudent.find_by(first_name: student_f_name, last_name: student_last_name, 
                                        date_of_birth: dob, is_deleted: 0, mg_school_id: school_id, 
                                        mg_batch_id: batch_data&.id, is_archive: 0)

      # Create a new FeeDiscount
      fee_discount = MgFeeDiscount.new
      fee_discount.name = discount_name
      fee_discount.discount_type = discount_type
      fee_discount.discount = discount_amount
      fee_discount.is_percent = 0 # Assuming it's not a percentage
      fee_discount.mg_fee_category_id = category&.id
      fee_discount.discount = discount_amount

      # Set receiver based on discount type
      if discount_type == "Student"
        fee_discount.mg_receiver_id = student_data&.id
        fee_discount.mg_batch_id = batch_data&.id
      elsif discount_type == "Section"
        fee_discount.mg_receiver_id = batch_data&.id
        fee_discount.mg_batch_id = batch_data&.id
      elsif discount_type == "Student Category"
        fee_discount.mg_receiver_id = student_category_data&.first&.id
        fee_discount.mg_batch_id = batch_data&.id
      end

      # Check for duplicates
      duplicate_data = MgFeeDiscount.where(
        mg_receiver_id: fee_discount.mg_receiver_id,
        mg_batch_id: fee_discount.mg_batch_id,
        mg_fee_category_id: fee_discount.mg_fee_category_id,
        is_deleted: 0
      ).exists?

      unless duplicate_data
        save_audit_fields(fee_discount, school_id)
        if fee_discount.save
          created_discounts << { row: index + 1, name: discount_name }
        else
          duplicate_discounts << {
            row: index + 1,
            name: discount_name,
            error: fee_discount.errors.full_messages.join(", ")
          }
        end
      else
        duplicate_discounts << {
          row: index + 1,
          name: discount_name,
          error: "Duplicate Discount '#{discount_name}'"
        }
      end
    end

    # Raise rollback if there are duplicates or errors
    raise ActiveRecord::Rollback if duplicate_discounts.any?
  end

  # Prepare the response
  if duplicate_discounts.any?
    render_json_response({
      status: 'error',
      message: 'Some Fee Discounts could not be processed.',
      data: {
        created: created_discounts,
        duplicate: duplicate_discounts
      }
    }, :unprocessable_entity)
  else
    render_json_response({
      status: 'success',
      message: 'All Fee Discounts processed successfully',
      data: {
        created: created_discounts
      }
    }, :ok)
  end
rescue StandardError => e
  handle_error(e)
end


def upload_late_fee_fine
  current_time = Time.now
  school_id = session[:current_user_school_id]
  user_id = session[:user_id]

  # Arrays to track results
  created_fines = []
  duplicate_fines = []
  errors = []

  # Validate input
  unless params[:data].is_a?(Array)
    return render_json_response({
      status: 'error',
      message: 'Invalid data format. Expected an array of fines.',
      data: {}
    }, :unprocessable_entity)
  end

  # Sanitize and prepare fines
  fines = params.require(:data).map do |fine|
    fine.permit(:fine_name, :description, :days_after_due_date, :amount, :row_number).to_h
  end

  # Check for duplicates
  existing_fines = MgFeeFine.where(
    fine_name: fines.map { |fine| fine[:fine_name] },
    mg_school_id: school_id,
    is_deleted: false
  ).pluck(:fine_name).to_set

  ActiveRecord::Base.transaction do
    fines.each_with_index do |fine, index|
      fine_name = fine[:fine_name]

      if existing_fines.include?(fine_name)
        duplicate_fines << {
          row: fine[:row_number] || (index + 1),
          name: fine_name,
          error: "Fee Fine '#{fine_name}' already exists"
        }
      else
        begin
          # Create and save MgFeeFine
          fee_fine = MgFeeFine.new(
            fine_name: fine_name,
            fine_description: fine[:description],
            is_deleted: false,
            mg_school_id: school_id,
            created_by: user_id,
            updated_by: user_id,
            created_at: current_time,
            updated_at: current_time
          )
          fee_fine.save!

          # Create and save MgFeeFineDue
          MgFeeFineDue.create!(
            mg_fee_fine_id: fee_fine.id,
            days_after_due_date: fine[:days_after_due_date],
            amount: fine[:amount],
            is_deleted: false,
            mg_school_id: school_id,
            created_by: user_id,
            updated_by: user_id,
            created_at: current_time,
            updated_at: current_time
          )

          created_fines << {
            row: fine[:row_number] || (index + 1),
            name: fine_name
          }
        rescue ActiveRecord::RecordInvalid => e
          errors << {
            row: fine[:row_number] || (index + 1),
            name: fine_name,
            error: e.message
          }
          raise ActiveRecord::Rollback # Ensure rollback of all changes if any error occurs
        end
      end
    end

    # If there are duplicates or errors, raise a rollback to undo any created records
    if duplicate_fines.any? || errors.any?
      raise ActiveRecord::Rollback
    end
  end

  # Prepare the response
  if duplicate_fines.any? || errors.any?
    render_json_response({
      status: 'error',
      message: 'Some fines could not be processed. No fines were created.',
      data: {
        created: created_fines,
        duplicate: duplicate_fines,
        errors: errors
      }
    }, :unprocessable_entity)
  else
    render_json_response({
      status: 'success',
      message: 'All fines processed successfully',
      data: {
        created: created_fines
      }
    }, :ok)
  end
rescue StandardError => e
  handle_error(e)
end

    
end
