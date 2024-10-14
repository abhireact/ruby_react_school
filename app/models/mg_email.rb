class MgEmail < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_user)

  def self.email_address(student_admission_obj, mg_users_obj, mg_school_id, session_user)
    @mg_user_id = mg_users_obj.id
    @mg_batch_id = student_admission_obj.mg_batch_id
    @student_name = student_admission_obj
    @mg_school_id = mg_school_id
    @session_user = session_user
    @student_category_id = student_admission_obj.mg_student_category_id
    MgEmail.new({ mg_email_id: @student_name.try(:mg_email_id), mg_user_id: @mg_user_id, mg_school_id: @mg_school_id, email_type: "home", is_deleted: 0, created_by: @session_user, updated_by: @session_user })
  end

  def self.guardians_email(student_id, guardian_user_id, guardian_name, mg_school_id, session_user)
    @student_id = student_id
    @guardian_user_id = guardian_user_id
    @guardian_name = guardian_name
    @mg_school_id = mg_school_id
    @session_user = session_user
    MgEmail.new({ mg_email_id: @guardian_name.email_id, mg_user_id: @guardian_user_id, mg_school_id: @mg_school_id, email_type: "home", is_deleted: 0, created_by: @session_user, updated_by: @session_user })
  end

  def self.guardian_email(student_id, guardian_user_id, mg_email_id, mg_school_id, session_user)
    @student_id = student_id
    @guardian_user_id = guardian_user_id
    @mg_email_id = mg_email_id
    @mg_school_id = mg_school_id
    @session_user = session_user
    MgEmail.create({ mg_email_id: @mg_email_id, mg_user_id: @guardian_user_id, mg_school_id: @mg_school_id, email_type: "home", is_deleted: 0, created_by: @session_user, updated_by: @session_user })
  end
end
