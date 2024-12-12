module UploadValidator
    extend ActiveSupport::Concern
  
    # Department validation method
    def validate_department(department)
      errors = []
      
      # Validate department name
      if department[:departmentName].blank?
        errors << "Department name cannot be blank"
      elsif department[:departmentName].length < 2 || department[:departmentName].length > 100
        errors << "Department name must be between 2 and 100 characters"
      end
      
      # Validate department code
      if department[:departmentCode].blank?
        errors << "Department code cannot be blank"
      elsif department[:departmentCode].length < 2 || department[:departmentCode].length > 20
        errors << "Department code must be between 2 and 20 characters"
      elsif !department[:departmentCode].match?(/^[A-Za-z0-9\-_]+$/)
        errors << "Department code can only contain letters, numbers, hyphens, and underscores"
      end
      
      errors
    end
    
    # Position validation method
    def validate_position(position)
      errors = []
      
      # Validate profile name
      if position[:profileName].blank?
        errors << "Position name cannot be blank"
      elsif position[:profileName].length < 2 || position[:profileName].length > 100
        errors << "Position name must be between 2 and 100 characters"
      end
      
      # Validate category
      valid_categories = ["teaching staff", "non teaching staff"]
      unless valid_categories.include?(position[:category].strip.downcase)
        errors << "Invalid category. Must be 'Teaching Staff' or 'Non Teaching Staff'"
      end
      
      errors
    end
    
    # Employee type validation method
    def validate_employee_type(type)
      errors = []
      
      # Validate employee type
      if type[:employeeType].blank?
        errors << "Employee type cannot be blank"
      elsif type[:employeeType].length < 2 || type[:employeeType].length > 50
        errors << "Employee type must be between 2 and 50 characters"
      end
      
      errors
    end

 
  # Employee validation method


  # Leave type validation method
  def validate_leave_type(leave_type)
    errors = []

    # Validate leave name
    if leave_type[:leave_name].blank?
      errors << "Leave name cannot be blank"
    elsif leave_type[:leave_name].length < 2 || leave_type[:leave_name].length > 100
      errors << "Leave name must be between 2 and 100 characters"
    end

    # Validate leave code
    if leave_type[:leave_code].blank?
      errors << "Leave code cannot be blank"
    elsif leave_type[:leave_code].length < 2 || leave_type[:leave_code].length > 20
      errors << "Leave code must be between 2 and 20 characters"
    end

    # Validate max leave count
    if leave_type[:max_leave_count].to_f < 0
      errors << "Maximum leave count cannot be negative"
    end

    # Validate reset period
    if leave_type[:reset_period].to_i < 0
      errors << "Reset period cannot be negative"
    end

    # Validate accumulation details
    if leave_type[:is_accumilation] == true
      if leave_type[:accumilation_count].to_f <= 0
        errors << "Accumulation count must be positive when accumulation is enabled"
      end
    end

    errors
  end

  # Salary component validation method

  def validate_salary_component(salary_component)
    errors = []

    # Validate name
    if salary_component[:name].blank?
      errors << "Salary component name cannot be blank"
    elsif salary_component[:name].length > 100  # Assuming a reasonable max length
      errors << "Salary component name is too long (maximum 100 characters)"
    end

    # Validate isDeduction (boolean check)
    unless [true, false].include?(salary_component[:isDeduction])
      errors << "Invalid deduction status. Must be true or false"
    end

    # Validate account name
    if salary_component[:accountName].blank?
      errors << "Account name cannot be blank"
    elsif salary_component[:accountName].length > 200  # Assuming a reasonable max length
      errors << "Account name is too long (maximum 200 characters)"
    end

    errors
  end

 # Employee Grade Validaton method
  def validate_grade(grade_data)
    errors = []
    
    # Check required fields
    errors << "Grade name is required" if grade_data[:gradeName].blank?
    errors << "Components is required" if grade_data[:components].blank?
    errors << "Applicable status is required" if grade_data[:applicable].blank?
    
    # Validate applicable and amount
    if grade_data[:applicable].downcase == 'yes'
      if grade_data[:amount].blank?
        errors << "Amount is required when component is applicable"
      elsif !grade_data[:amount].to_s.match?(/\A\d+(?:\.\d{0,2})?\z/)
        errors << "Amount must be a valid number with up to 2 decimal places"
      end
    end
    
    errors
  end
  def validate_employee(employee)
    errors = []

    # Validate personal details
    if employee[:first_name].blank?
      errors << "First name cannot be blank"
    elsif employee[:first_name].length < 2 || employee[:first_name].length > 50
      errors << "First name must be between 2 and 50 characters"
    end

    # Last name validation
    if employee[:last_name].blank?
      errors << "Last name cannot be blank"
    elsif employee[:last_name].length < 2 || employee[:last_name].length > 50
      errors << "Last name must be between 2 and 50 characters"
    end

    # Employee number validation
    if employee[:employee_number].blank?
      errors << "Employee number cannot be blank"
    elsif !employee[:employee_number].match?(/^[A-Za-z0-9\-_]+$/)
      errors << "Employee number can only contain letters, numbers, hyphens, and underscores"
    end

    # Date of birth validation
    if employee[:date_of_birth].blank?
      errors << "Date of birth cannot be blank"
    else
      begin
        dob = Date.parse(employee[:date_of_birth])
        if dob >= Date.today
          errors << "Date of birth must be in the past"
        elsif dob < Date.today - 100.years
          errors << "Date of birth seems incorrect"
        end
      rescue ArgumentError
        errors << "Invalid date of birth format"
      end
    end

    # Joining date validation
    if employee[:joining_date].blank?
      errors << "Joining date cannot be blank"
    else
      begin
        joining_date = Date.parse(employee[:joining_date])
        if joining_date > Date.today
          errors << "Joining date must be today or in the past"
        elsif joining_date < Date.today - 70.years
          errors << "Joining date seems incorrect"
        end
      rescue ArgumentError
        errors << "Invalid joining date format"
      end
    end

    # Gender validation
    valid_genders = ["male", "female", "other"]
    unless valid_genders.include?(employee[:gender].strip.downcase)
      errors << "Invalid gender. Must be 'Male', 'Female', or 'Other'"
    end

    # Marital status validation
    valid_marital_statuses = ["single", "married", "divorced", "widowed"]
    unless valid_marital_statuses.include?(employee[:marital_status].strip.downcase)
      errors << "Invalid marital status. Must be 'Single', 'Married', 'Divorced', or 'Widowed'"
    end

    # Experience validation
    if employee[:experience_year].to_i < 0 || employee[:experience_year].to_i > 50
      errors << "Invalid years of experience"
    end

    if employee[:experience_month].to_i < 0 || employee[:experience_month].to_i > 11
      errors << "Invalid months of experience"
    end

    errors
  end

end