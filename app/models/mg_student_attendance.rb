class MgStudentAttendance < ApplicationRecord
  belongs_to(:mg_student)
  belongs_to(:mg_batch)
  belongs_to(:mg_school)

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

  def self.import_attendance(file, mg_school_id, user_id)
    MgStudentAttendance.transaction {
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each { |i,|
        row = Hash.[]([header, spreadsheet.row(i)].transpose)
        split_time = row.[]("Period_Time").split("-")
        student_obj = MgStudent.find_by({ admission_number: row.[]("Admission_Number"), mg_school_id: })
        batch = MgBatch.find(student_obj.mg_batch_id)
        course = MgCourse.find(batch.mg_course_id)
        weekday_obj = MgWeekday.find_by({ weekday: row.[]("Absent_Date").strftime("%w"), mg_wing_id: course.mg_wing_id })
        class_timeings_obj = MgClassTiming.find_by({ mg_weekday_id: weekday_obj.id, mg_wing_id: course.mg_wing_id, start_time: Time.parse(split_time.[](0)).strftime("%H:%M:%S"), end_time: Time.parse(split_time.[](1)).strftime("%H:%M:%S"), mg_school_id: })
        student_attendance = find_by({ mg_school_id:, mg_class_timing_id: class_timeings_obj.id, mg_student_id: student_obj.id, mg_batch_id: batch.id, absent_date: row.[]("Absent_Date"), is_deleted: 0 }) || new
        student_attendance.mg_school_id=mg_school_id
        student_attendance.mg_class_timing_id=class_timeings_obj.id
        student_attendance.mg_student_id=student_obj.id
        student_attendance.mg_batch_id=batch.id
        student_attendance.absent_date=row.[]("Absent_Date")
        student_attendance.is_deleted=0
        student_attendance.reason=row.[]("Reason")
        student_attendance.created_by=user_id
        student_attendance.updated_by=user_id
        student_attendance.save
      }
    }
  end

  def self.import_with_day_wise(file, mg_school_id, user_id)
    MgStudentAttendance.transaction {
      spreadsheet = open_spreadsheet(file)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each { |i,|
        row = Hash.[]([header, spreadsheet.row(i)].transpose)
        student_obj = MgStudent.find_by({ admission_number: row.[]("Admission_Number"), mg_school_id: })
        batch = MgBatch.find(student_obj.mg_batch_id)
        course = MgCourse.find(batch.mg_course_id)
        weekday_obj = MgWeekday.find_by({ weekday: row.[]("Absent_Date").strftime("%w"), mg_wing_id: course.mg_wing_id })
        class_timeings_obj = MgClassTiming.where({ mg_weekday_id: weekday_obj.id, mg_wing_id: course.mg_wing_id, mg_school_id: })
        class_timeings_obj.each { |day,|
          student_attendance = find_by({ mg_school_id:, mg_class_timing_id: day.id, mg_student_id: student_obj.id, mg_batch_id: batch.id, absent_date: row.[]("Absent_Date"), is_deleted: 0 }) || new
          student_attendance.mg_school_id=mg_school_id
          student_attendance.mg_class_timing_id=day.id
          student_attendance.mg_student_id=student_obj.id
          student_attendance.mg_batch_id=batch.id
          student_attendance.absent_date=row.[]("Absent_Date")
          student_attendance.is_deleted=0
          student_attendance.reason=row.[]("Reason")
          student_attendance.created_by=user_id
          student_attendance.updated_by=user_id
          student_attendance.save
        }
      }
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
