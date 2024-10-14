class MgStudentGuardian < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_student)
  belongs_to :mg_guardian,  foreign_key: "mg_guardians_id", primary_key: "id" 

  def self.student_guardian(guardian_id, student_id, guardian_relation, mg_school_id, session_user)
    MgStudentGuardian.create({ mg_student_id: student_id, mg_guardians_id: guardian_id, relation: guardian_relation, is_deleted: 0, has_login_access: true, primary_contact: true, mg_school_id:, created_by: session_user, updated_by: session_user })
  end
end
