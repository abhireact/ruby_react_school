module SetFourValidator
    extend ActiveSupport::Concern
  
    # Validator to check if data is an array
    def validate_array_format!(data)
      unless data.is_a?(Array)
        raise ArgumentError.new("Invalid data format. Expected an array of fee data.")
      end
    end
  
    # Validator to check if fee categories already exist
    def validate_fee_category_exists!(school_id, fee_category_names)
      existing_categories = MgFeeCategory.where(
        name: fee_category_names,
        mg_school_id: school_id,
        is_deleted: false
      ).pluck(:name).to_set
  
      existing_categories
    end
  
    # Validator to check if fee particulars already exist
    def validate_fee_particular_exists!(school_id, fee_particular_names, fee_category_id)
      existing_particulars = MgParticularType.where(
        particular_name: fee_particular_names,
        mg_fee_category_id: fee_category_id,
        mg_school_id: school_id,
        is_deleted: false
      ).pluck(:particular_name).to_set
  
      existing_particulars
    end
  
    # Validator to check if fee discounts already exist
    def validate_fee_discount_exists!(school_id, discount_names)
      existing_discounts = MgFeeDiscount.where(
        name: discount_names,
        mg_school_id: school_id,
        is_deleted: false
      ).pluck(:name).to_set
  
      existing_discounts
    end
  
    # Validator to check if late fee fines already exist
    def validate_late_fee_fine_exists!(school_id, fine_names)
      existing_fines = MgFeeFine.where(
        fine_name: fine_names,
        mg_school_id: school_id,
        is_deleted: false
      ).pluck(:fine_name).to_set
  
      existing_fines
    end
  
    # Validator to ensure a particular fee category exists
    def validate_fee_category!(school_id, fee_category_name)
      category = MgFeeCategory.where(
        is_deleted: 0,
        mg_school_id: school_id
      ).where(MgFeeCategory.arel_table[:name].matches(fee_category_name.rstrip)).first
  
      raise ArgumentError.new("Fee Category '#{fee_category_name}' not found") unless category
      category
    end
  
    # Validator to ensure a particular fee particular exists for a given category
    def validate_fee_particular!(school_id, fee_category_id, fee_particular_name)
      particular_type = MgParticularType.where(
        is_deleted: 0,
        mg_school_id: school_id,
        mg_fee_category_id: fee_category_id
      ).where(MgParticularType.arel_table[:particular_name].matches(fee_particular_name.rstrip)).first
  
      raise ArgumentError.new("Fee Particular '#{fee_particular_name}' not found for Fee Category") unless particular_type
      particular_type
    end
  
    # Validator to ensure fee discounts are valid
    def validate_fee_discount!(school_id, fee_category_name, discount_name, discount_type)
      category = validate_fee_category!(school_id, fee_category_name)
  
      if discount_type == "Student"
        student_data = MgStudent.find_by(first_name: discount_name)
        raise ArgumentError.new("Student '#{discount_name}' not found for Discount") unless student_data
      elsif discount_type == "Section"
        batch_data = MgBatch.find_by(name: discount_name)
        raise ArgumentError.new("Section '#{discount_name}' not found for Discount") unless batch_data
      elsif discount_type == "Student Category"
        student_category_data = MgStudentCategory.find_by(name: discount_name)
        raise ArgumentError.new("Student Category '#{discount_name}' not found for Discount") unless student_category_data
      end
    end
  
    # Validator to ensure fine exists
    def validate_late_fee_fine!(school_id, fine_name)
      fine = MgFeeFine.where(
        fine_name: fine_name,
        mg_school_id: school_id,
        is_deleted: false
      ).first
  
      raise ArgumentError.new("Fee Fine '#{fine_name}' not found") unless fine
      fine
    end
  end
  