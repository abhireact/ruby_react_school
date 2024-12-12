class MgRemarksEntry < ApplicationRecord
  validates :index, uniqueness: { 
    scope: [:mg_school_id, :mg_time_table_id], 
    allow_blank: true, 
    allow_nil: true, 
    conditions: -> { where(is_deleted: false) },
    message: "should be unique within the school and timetable" 
  }, on: :create

  validate :index_is_unique_on_update, on: :update

  private

  def index_is_unique_on_update
    return if index.blank?  # Skip check if index is blank

    # Ensure uniqueness excluding the current record (i.e., ignore the record being updated)
    existing_entry = MgRemarksEntry.where(mg_school_id: mg_school_id, mg_time_table_id: mg_time_table_id, index: index, is_deleted: false)
                                   .where.not(id: id)  # Exclude the current record
    if existing_entry.exists?
      errors.add(:index, "should be unique within the school and timetable")
    end
  end
end

