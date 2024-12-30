class MgPhone < ApplicationRecord
  # belongs_to(:mg_school)
  # belongs_to(:mg_user)

  # def self.phone_detail(student_admission_obj, mg_users_obj, mg_school_id, session_user)
  #   @mg_user_id = mg_users_obj.id
  #   @mg_batch_id = student_admission_obj.mg_batch_id
  #   @student_name = student_admission_obj
  #   @mg_school_id = mg_school_id
  #   @session_user = session_user
  #   @student_category_id = student_admission_obj.mg_student_category_id
  #   MgPhone.new({ phone_number: @student_name.try(:phone_number), phone_type: "phone", mg_user_id: @mg_user_id, mg_school_id: @mg_school_id, is_deleted: 0, created_by: @session_user, updated_by: @session_user })
  # end

  # def self.mobile_detail(student_admission_obj, mg_users_obj, mg_school_id, session_user)
  #   @mg_user_id = mg_users_obj.id
  #   @mg_batch_id = student_admission_obj.mg_batch_id
  #   @student_name = student_admission_obj
  #   @mg_school_id = mg_school_id
  #   @session_user = session_user
  #   @student_category_id = student_admission_obj.mg_student_category_id
  #   MgPhone.new({ phone_number: @student_name.try(:mobile_number), phone_type: "mobile", mg_user_id: @mg_user_id, mg_school_id: @mg_school_id, is_deleted: 0, created_by: @session_user, updated_by: @session_user })
  # end

  # def self.guardians_phone(student_id, guardian_user_id, guardian_name, mg_school_id, session_user)
  #   @student_id = student_id
  #   @guardian_user_id = guardian_user_id
  #   @guardian_name = guardian_name
  #   @mg_school_id = mg_school_id
  #   @session_user = session_user
  #   MgPhone.new({ phone_number: @guardian_name.phone_number, phone_type: "phone", mg_user_id: @guardian_user_id, mg_school_id: @mg_school_id, is_deleted: 0, created_by: @session_user, updated_by: @session_user })
  # end

  # def self.guardians_mobile(student_id, guardian_user_id, guardian_name, mg_school_id, session_user)
  #   @student_id = student_id
  #   @guardian_user_id = guardian_user_id
  #   @guardian_name = guardian_name
  #   @mg_school_id = mg_school_id
  #   @session_user = session_user
  #   MgPhone.new({ phone_number: @guardian_name.try(:mobile_number), phone_type: "mobile", mg_user_id: @guardian_user_id, mg_school_id: @mg_school_id, is_deleted: 0, created_by: @session_user, updated_by: @session_user })
  # end

  # def self.guardian_mobiles(contact_no, guardian_user_id, mg_school_id, session_user)
  #   @guardian_user_id = guardian_user_id
  #   @mg_school_id = mg_school_id
  #   @session_user = session_user
  #   contact_no = MgPhone.new({ phone_number: contact_no, phone_type: "mobile", mg_user_id: @guardian_user_id, mg_school_id: @mg_school_id, is_deleted: 0, created_by: @session_user, updated_by: @session_user })
  #   contact_no.save
  # end
end
