class MgAssignSetToStudent < ApplicationRecord
  belongs_to(:mg_question_set)
  belongs_to(:mg_student)
  belongs_to(:mg_school)

  def self.get_assign_data(assign_set_id, school_id)
    assign_data = self.joins({ mg_question_set: { mg_question_set_details: :mg_question_bank } }).find_by({ id: assign_set_id, is_deleted: 0, mg_school_id: school_id })
    assign_data
  end

  def self.cached_assign_set_to_student(assign_set_id, school_id)
    Rails.cache.fetch(["cached_assign_set_to_student", assign_set_id, school_id], { expires_in: 180.minutes }) {
      self.find_by({ id: assign_set_id, mg_school_id: school_id })
    }
  end

  def self.cached_question_ids(question_set)
    puts("#{question_set.mg_question_set_id}")
    Rails.cache.fetch(["question_set_id_for_students", question_set.mg_question_set_id], { expires_in: 180.minutes }) {
      question_set.mg_question_set.mg_question_set_details.pluck(:mg_question_bank_id).to_a
    }
  end
end
