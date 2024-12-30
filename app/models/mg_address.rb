class MgAddress < ApplicationRecord
  # belongs_to(:mg_users)
  # belongs_to(:mg_school)

  # def full_address
  #   if address_line1.present? && address_line2.present?
  #     "#{address_line1.strip} #{address_line2.strip}"
  #   else
  #     if ["-", "", nil].include?(address_line2)
  #       "#{address_line1.strip}"
  #     else
  #       if ["-", "", nil].include?(address_line1)
  #         "#{address_line2.strip}"
  #       end
  #     end
  #   end
  # end

  # def self.permanentaddress(student_admission_obj, mg_users_obj, mg_school_id, session_user)
  #   @mg_user_id = mg_users_obj.id
  #   @mg_batch_id = student_admission_obj.mg_batch_id
  #   @student_name = student_admission_obj
  #   @mg_school_id = mg_school_id
  #   @session_user = session_user
  #   @student_category_id = student_admission_obj.mg_student_category_id
  #   MgAddress.new({ address_line1: @student_name.try(:mg_p_address_line1), address_line2: @student_name.try(:mg_p_address_line2), address_type: "Permanent", street: @student_name.try(:mg_p_street), landmark: @student_name.try(:mg_p_landmark), city: @student_name.try(:mg_p_city), state: @student_name.try(:mg_p_state), country: @student_name.try(:mg_p_country), pin_code: @student_name.try(:mg_p_pin_code), mg_user_id: @mg_user_id, mg_school_id: @mg_school_id, is_deleted: 0, created_by: @session_user, updated_by: @session_user })
  # end

  # def self.temporaryaddress(student_admission_obj, mg_users_obj, mg_school_id, session_user)
  #   @mg_user_id = mg_users_obj.id
  #   @mg_batch_id = student_admission_obj.mg_batch_id
  #   @student_name = student_admission_obj
  #   @mg_school_id = mg_school_id
  #   @session_user = session_user
  #   @student_category_id = student_admission_obj.mg_student_category_id
  #   MgAddress.new({ address_line1: @student_name.try(:tmg_c_address_line1), address_line2: @student_name.try(:mg_c_address_line2), address_type: "Correspondance", street: @student_name.try(:mg_c_street), landmark: @student_name.try(:mg_c_landmark), city: @student_name.try(:mg_c_city), state: @student_name.try(:mg_c_state), country: @student_name.try(:mg_c_country), pin_code: @student_name.try(:mg_c_pin_code), mg_user_id: @mg_user_id, mg_school_id: @mg_batch_id, is_deleted: 0, created_by: @session_user, updated_by: @session_user })
  # end

  # def self.permanentaddress_upcase(student_admission_obj, mg_users_obj, mg_school_id, session_user)
  #   @mg_user_id = mg_users_obj.id
  #   @mg_batch_id = student_admission_obj.mg_batch_id
  #   @student_name = student_admission_obj
  #   @mg_school_id = mg_school_id
  #   @session_user = session_user
  #   if @student_name.try(:mg_p_street).nil?
  #     @student_name.update({ mg_p_street: "" })
  #   end
  #   if @student_name.try(:mg_p_landmark).nil?
  #     @student_name.update({ mg_p_landmark: "" })
  #   end
  #   if @student_name.try(:mg_p_address_line2).nil?
  #     @student_name.update({ mg_p_address_line2: "" })
  #   end
  #   if @student_name.try(:mg_p_landmark).nil?
  #     @student_name.update({ mg_p_landmark: "" })
  #   end
  #   if @student_name.try(:mg_p_state).nil?
  #     @student_name.update({ mg_p_state: "" })
  #   end
  #   if @student_name.try(:mg_p_city).nil?
  #     @student_name.update({ mg_p_city: "" })
  #   end
  #   if @student_name.try(:mg_p_country).nil?
  #     @student_name.update({ mg_p_country: "" })
  #   end
  #   @student_category_id = student_admission_obj.mg_student_category_id
  #   MgAddress.new({ address_line1: @student_name.try(:mg_p_address_line1).upcase, address_line2: @student_name.try(:mg_p_address_line2).upcase, address_type: "Permanent", street: @student_name.try(:mg_p_street).upcase, landmark: @student_name.try(:mg_p_landmark).upcase, city: @student_name.try(:mg_p_city).upcase, state: @student_name.try(:mg_p_state).upcase, country: @student_name.try(:mg_p_country).upcase, pin_code: @student_name.try(:mg_p_pin_code), mg_user_id: @mg_user_id, mg_school_id: @mg_school_id, is_deleted: 0, created_by: @session_user, updated_by: @session_user })
  # end

  # def self.temporaryaddress_upcase(student_admission_obj, mg_users_obj, mg_school_id, session_user)
  #   @mg_user_id = mg_users_obj.id
  #   @mg_batch_id = student_admission_obj.mg_batch_id
  #   @student_name = student_admission_obj
  #   if @student_name.try(:mg_c_street).nil?
  #     @student_name.update({ mg_c_street: "" })
  #   end
  #   if @student_name.try(:mg_c_landmark).nil?
  #     @student_name.update({ mg_c_landmark: "" })
  #   end
  #   if @student_name.try(:mg_c_address_line2).nil?
  #     @student_name.update({ mg_c_address_line2: "" })
  #   end
  #   if @student_name.try(:mg_c_state).nil?
  #     @student_name.update({ mg_c_state: "" })
  #   end
  #   if @student_name.try(:mg_c_city).nil?
  #     @student_name.update({ mg_c_city: "" })
  #   end
  #   if @student_name.try(:mg_c_country).nil?
  #     @student_name.update({ mg_c_country: "" })
  #   end
  #   if @student_name.try(:mg_c_street).nil?
  #     @student_name.update({ mg_c_street: "" })
  #   end
  #   @mg_school_id = mg_school_id
  #   @session_user = session_user
  #   @student_category_id = student_admission_obj.mg_student_category_id
  #   MgAddress.new({ address_line1: @student_name.try(:mg_c_address_line1).upcase, address_line2: @student_name.try(:mg_c_address_line2).upcase, address_type: "Correspondance", street: @student_name.try(:mg_c_street).upcase, landmark: @student_name.try(:mg_c_landmark).upcase, city: @student_name.try(:mg_c_city).upcase, state: @student_name.try(:mg_c_state).upcase, country: @student_name.try(:mg_c_country).upcase, pin_code: @student_name.try(:mg_c_pin_code), mg_user_id: @mg_user_id, mg_school_id: @mg_batch_id, is_deleted: 0, created_by: @session_user, updated_by: @session_user })
  # end

  # def self.guardian_paddress(student_id, guardian_user_id, guardian_name, mg_school_id, session_user)
  #   @student_id = student_id
  #   @guardian_user_id = guardian_user_id
  #   @guardian_name = guardian_name
  #   @mg_school_id = mg_school_id
  #   @session_user = session_user
  #   MgAddress.new({ address_line1: @guardian_name.address_line1, address_line2: @guardian_name.address_line2, address_type: "Permanent", street: @guardian_name.street, landmark: @guardian_name.try(:landmark), city: @guardian_name.try(:city), state: @guardian_name.try(:state), country: @guardian_name.try(:country), pin_code: @guardian_name.pin_code, mg_user_id: @guardian_user_id, mg_school_id: @mg_school_id, is_deleted: 0, created_by: @session_user, updated_by: @session_user })
  # end
end
