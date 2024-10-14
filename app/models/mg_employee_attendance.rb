class MgEmployeeAttendance < ApplicationRecord
  attr_accessor(:upload)
  belongs_to(:mg_employee_leave_application)
  belongs_to(:mg_school)
  belongs_to(:mg_employee)
  belongs_to(:mg_employee_department)
  belongs_to(:mg_leave_type)
  has_many :mg_employees,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_employees)

  def self.demo(upload)
    name = upload.[]("datafile").original_filename
    directory = "upload/public/data"
    path = File.join(directory, name)
    File.open(path, "wb") { |f,|
      f.write(upload.[]("datafile").read)
    }
  end

  def self.save(upload, content_type)
    name = upload.[]("datafile").original_filename
    directory = "upload/public/data"
    path = File.join(directory, name)
    File.extname(name)
  end

  def self.uploadfile(upload)
    name = upload.[]("datafile").original_filename
    directory = "upload/public/data"
    path = File.join(directory, name)
    File.read(path)
  end

  def self.import(file, schoolId, userId)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each { |i,|
      row = Hash.[]([header, spreadsheet.row(i)].transpose)
      puts("row")
      puts(row.inspect)
      employee_obj = MgEmployee.find_by({ employee_number: row.[]("Employee_Id"), is_deleted: 0 })
      if employee_obj.present?
        row.[]=("Employee_Id", employee_obj.id)
        mg_employee_department_id = employee_obj.mg_employee_department_id
      else
        row.[]=("Employee_Id", "")
        mg_employee_department_id = ""
      end
      employee_leave_type_obj = MgEmployeeLeaveType.find_by({ leave_name: row.[]("Leave_Type"), is_deleted: 0 })
      if employee_leave_type_obj.present?
        row.[]=("Leave_Type", employee_leave_type_obj.id)
      else
        row.[]=("Leave_Type", "")
      end
      employee_leave_application_obj = MgEmployeeLeaveApplication.find_by({ mg_employee_id: row.[]("Employee_Id"), is_deleted: 0 })
      if employee_leave_application_obj.present?
        mg_employee_leave_application_id = employee_leave_application_obj.id
      else
        mg_employee_leave_application_id = ""
      end
      if row.[]("Approved") == "Y"
        row.[]=("Approved", 1)
      else
        row.[]=("Approved", 0)
      end
      if row.[]("Late_Come") == "Y"
        row.[]=("Late_Come", 1)
      else
        row.[]=("Late_Come", 0)
      end
      if row.[]("Afternoon") == "Y"
        row.[]=("Afternoon", 1)
      else
        row.[]=("Afternoon", 0)
      end
      if row.[]("Halfday") == "Y"
        row.[]=("Halfday", 1)
      else
        row.[]=("Halfday", 0)
      end
      if row.[]("Absent_Without_Notice") == "Y"
        row.[]=("Absent_Without_Notice", 1)
      else
        row.[]=("Absent_Without_Notice", 0)
      end
      if row.[]("Lock") == "Y"
        row.[]=("Lock", 1)
      else
        row.[]=("Lock", 0)
      end
      employee_attandances = find_by({ mg_employee_id: row.[]("Employee_Id"), absent_date: row.[]("Absent_Date"), mg_leave_type_id: row.[]("Leave_Type"), mg_employee_department_id:, mg_school_id: schoolId })
      if employee_attandances.present?
        puts("employee_attandances")
        puts(employee_attandances.inspect)
        employee_attandances.absent_date=row.[]("Absent_Date")
        employee_attandances.mg_employee_id=row.[]("Employee_Id")
        employee_attandances.mg_leave_type_id=row.[]("Leave_Type")
        employee_attandances.is_approved=row.[]("Approved")
        employee_attandances.is_lock=row.[]("Lock")
        employee_attandances.reason=row.[]("Reason")
        employee_attandances.time=row.[]("Time")
        employee_attandances.is_halfday=row.[]("Halfday")
        employee_attandances.is_late_come=row.[]("Late_Come")
        employee_attandances.is_afternoon=row.[]("Afternoon")
        employee_attandances.abcent_without_notice=row.[]("Absent_Without_Notice")
        employee_attandances.mg_employee_department_id=mg_employee_department_id
        employee_attandances.is_deleted=0
        employee_attandances.mg_school_id=schoolId
        employee_attandances.created_by=userId
        employee_attandances.updated_by=userId
        employee_attandances.mg_employee_leave_application_id=mg_employee_leave_application_id
        employee_attandances.save!
      else
        employee_attandances = MgEmployeeAttendance.new
        employee_attandances.absent_date=row.[]("Absent_Date")
        employee_attandances.mg_employee_id=row.[]("Employee_Id")
        employee_attandances.mg_leave_type_id=row.[]("Leave_Type")
        employee_attandances.is_approved=row.[]("Approved")
        employee_attandances.is_lock=row.[]("Lock")
        employee_attandances.reason=row.[]("Reason")
        employee_attandances.time=row.[]("Time")
        employee_attandances.is_halfday=row.[]("Halfday")
        employee_attandances.is_late_come=row.[]("Late_Come")
        employee_attandances.is_afternoon=row.[]("Afternoon")
        employee_attandances.abcent_without_notice=row.[]("Absent_Without_Notice")
        employee_attandances.mg_employee_department_id=mg_employee_department_id
        employee_attandances.is_deleted=0
        employee_attandances.mg_school_id=schoolId
        employee_attandances.created_by=userId
        employee_attandances.updated_by=userId
        employee_attandances.mg_employee_leave_application_id=mg_employee_leave_application_id
        employee_attandances.save!
        @count_leave = MgEmployeeLeaves.where({ mg_employee_id: row.[]("Employee_Id"), mg_leave_type_id: row.[]("Leave_Type"), mg_school_id: schoolId })
        if @count_leave.present?
          @updateEmployeeLeves = MgEmployeeLeaves.find(@count_leave.[](0).id)
          @updateEmployeeLeves.leave_taken += 1
          @updateEmployeeLeves.updated_by=userId
          @updateEmployeeLeves.mg_school_id=schoolId
          @updateEmployeeLeves.save
        else
          @updateEmployeeLeves = MgEmployeeLeaves.new({ mg_employee_id: row.[]("Employee_Id"), mg_leave_type_id: row.[]("Leave_Type"), leave_taken: 1, is_deleted: 0, mg_school_id: schoolId, created_by: userId, updated_by: userId })
          @updateEmployeeLeves.save
        end
      end
    }
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv"
      Roo::Csv.new(file.path, nil, :ignore)
    when ".xls"
      Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx"
      Roo::Excelx.new(file.path, nil, :ignore)
    else
      raise("Unknown file type: #{file.original_filename}")
    end
  end
end
