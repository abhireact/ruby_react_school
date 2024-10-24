# # app/validators/overlap_validator.rb
# class OverlapValidator < ActiveModel::Validator
#   def validate(record)
#     if record.start_time && record.end_time && record.start_time >= record.end_time
#       record.errors.add(:base, "Start time must be before end time")
#     end

#     # Additional logic to check for overlapping records can be added here
#     overlapping_records = record.class.where("mg_doctor_id = ? AND mg_school_id = ? AND ((start_time < ? AND end_time > ?) OR (start_time < ? AND end_time > ?))", 
#                                               record.mg_doctor_id, 
#                                               record.mg_school_id, 
#                                               record.end_time, 
#                                               record.start_time, 
#                                               record.start_time, 
#                                               record.end_time)

#     if overlapping_records.exists?
#       record.errors.add(:base, "Schedule overlaps with existing records")
#     end
#   end
# end

# app/validators/overlap_validator.rb
class OverlapValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    scope = record.class.where(mg_school_id: record.mg_school_id)
                        .where.not(id: record.id) # Exclude the current record
                        .where("start_date < ? AND end_date > ?", record.end_date, record.start_date)
    
    if scope.exists?
      record.errors.add(attribute, "dates overlap with another record")
    end
  end
end
