class MgStudent < ApplicationRecord
  # belongs_to(:mg_caste)
  # belongs_to(:mg_caste_category)
  # has_attached_file(:avatar, { styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "adminImage.png" })
  # validates_attachment_content_type(:avatar, { content_type: /\Aimage\/.*\Z/ })
  # has_many :mg_student_appear_exams,  dependent: :destroy 
  # has_many :mg_cbsc_other_marks_entries,  dependent: :destroy 
  # has_many :mg_cbsc_scholastic_marks_entries,  dependent: :destroy 
  # has_many :mg_committee_members,  dependent: :destroy 
  # has_many :mg_finance_transaction_details,  dependent: :destroy 
  # has_many :mg_finance_transactions,  dependent: :destroy 
  # belongs_to :mg_student_category,  foreign_key: :mg_student_catagory_id, primary_key: "id" 
  # belongs_to(:mg_user)
  # belongs_to(:mg_batch)
  # belongs_to(:mg_school)
  # belongs_to(:mg_course)
  # has_many :mg_student_remarks_entries,  dependent: :destroy 
  # scope(:by_first_name, lambda {
  #   where({ is_deleted: 0 }).order(:first_name)
  # })

  # def can_destroy?
  #   table_list = Array.new
  #   self.class.reflect_on_all_associations.each { |assoc,|
  #     name = assoc.name
  #     if assoc.macro === (:has_many || :has_one) && self.send(name).present?
  #       table_list.push(name)
  #     end
  #   }
  #   table_list
  # end
  # scope(:active, lambda {
  #   where({ is_deleted: 0 }).joins(:mg_course).select("`mg_batches`.*,CONCAT(mg_courses.code,'-',mg_batches.name) as course_full_name", { order: "course_full_name" })
  # })
  # has_many :mg_student_guardians,  dependent: :destroy 
  # has_many :mg_guardians,  dependent: :destroy 

  # def student_name
  #   if middle_name != nil
  #     middle_name_striped = middle_name.strip
  #   end
  #   if last_name != nil
  #     last_name_striped = last_name.strip
  #   end
  #   if ["-", "", nil].include?(middle_name_striped)
  #     "#{first_name.strip} #{last_name_striped}"
  #   else
  #     if ["-", "", nil].include?(last_name_striped)
  #       "#{first_name.strip}"
  #     else
  #       "#{first_name.strip} #{middle_name_striped} #{last_name_striped}"
  #     end
  #   end
  # end

  # def student_full_name
  #   if middle_name != nil
  #     middle_name_striped = middle_name.strip
  #   end
  #   if last_name != nil
  #     last_name_striped = last_name.strip
  #   end
  #   if ["-", "", nil].include?(middle_name_striped)
  #     student_name = "#{first_name.strip} #{last_name_striped}"
  #   else
  #     if ["-", "", nil].include?(last_name_striped)
  #       student_name = "#{first_name.strip}"
  #     else
  #       student_name = "#{first_name.strip} #{middle_name_striped} #{last_name_striped}"
  #     end
  #   end
  #   "#{admission_number}#{" - "}#{student_name}"
  # end

  # def student_proper_name
  #   if middle_name != nil
  #     middle_name_striped = middle_name.strip
  #   end
  #   if last_name != nil
  #     last_name_striped = last_name.strip
  #   end
  #   if ["-", "", nil].include?(middle_name_striped)
  #     student_name = "#{first_name.strip} #{last_name_striped}"
  #   else
  #     if ["-", "", nil].include?(last_name_striped)
  #       student_name = "#{first_name.strip} #{middle_name.strip}"
  #     else
  #       student_name = "#{first_name.strip} #{middle_name_striped} #{last_name_striped}"
  #     end
  #   end
  # end

  # def course_batch_name_student
  #   "#{course_batch_name}"
  # end

  # def self.search(search)
  #   arr = []
  #   arr.push(search)
  #   search_value = ""
  #   if search
  #     if (arr.size) > 0
  #       for i in 0..arr.size - 1 do
  #         search_value += " first_name LIKE '%#{arr.[](i)}%' or CONCAT(first_name,' ',last_name) LIKE '%#{arr.[](i)}%' or CONCAT_WS(first_name,' ',middle_name,' ',last_name) LIKE '%#{arr.[](i)}%'  or admission_number LIKE '%#{arr.[](i)}%' or class_roll_number LIKE '%#{arr.[](i)}%' or gender LIKE '%#{arr.[](i)}%' or mg_batch_id IN (select id from mg_batches where  name LIKE '%#{arr.[](i)}%') "
  #         search_value += " or mg_batch_id IN (SELECT mg_batches.id FROM mg_courses INNER JOIN mg_batches ON mg_courses.id = mg_batches.mg_course_id where CONCAT(mg_courses.course_name,'-',mg_batches.name) LIKE '%#{arr.[](i)}%') "
  #         if i < (arr.size - 1)
  #           search_value += " or "
  #         end
  #       end
  #     end
  #     where(search_value)
  #   else
  #     all
  #   end
  # end

  # def self.students(users_name, mg_user_id, mg_student, mg_school_id, session_user, mg_batch_id, admission_date)
  #   @users_name = users_name
  #   @mg_user_id = mg_user_id.id
  #   @student_name = mg_student
  #   @mg_school_id = mg_school_id
  #   @session_user = session_user
  #   @mg_batch_id = mg_batch_id
  #   stu_admission_date = admission_date
  #   MgStudent.create({ admission_number: @users_name, mg_user_id: @mg_user_id, nationality: @student_name.try(:nationality), first_name: @student_name.try(:first_name), middle_name: @student_name.try(:middle_name), last_name: @student_name.try(:last_name), mg_course_id: @student_name.mg_course_id, date_of_birth: @student_name.try(:date_of_birth), gender: @student_name.try(:gender), blood_group: @student_name.try(:blood_group), birth_place: @student_name.try(:birth_place), mg_batch_id: @mg_batch_id, language: @student_name.try(:language), religion: @student_name.try(:religion), updated_by: @session_user, is_deleted: 0, is_archive: 0, mg_school_id: @mg_school_id, created_by: @session_user, mg_student_admission_id: @student_name.id, mg_student_catagory_id: @student_name.mg_student_category_id, class_roll_number: @student_name.admission_number, admission_date: stu_admission_date })
  # end

  # def self.students_uppercase(users_name, mg_user_id, mg_student, mg_school_id, session_user, mg_batch_id, admission_date)
  #   @users_name = users_name
  #   @mg_user_id = mg_user_id.id
  #   @student_name = mg_student
  #   @mg_school_id = mg_school_id
  #   @session_user = session_user
  #   @mg_batch_id = mg_batch_id
  #   stu_admission_date = admission_date
  #   MgStudent.create({ admission_number: @users_name, mg_user_id: @mg_user_id, nationality: @student_name.try(:nationality), first_name: @student_name.try(:first_name).upcase, middle_name: @student_name.try(:middle_name).upcase, last_name: @student_name.try(:last_name).upcase, mg_course_id: @student_name.mg_course_id, date_of_birth: @student_name.try(:date_of_birth), gender: @student_name.try(:gender).upcase, blood_group: @student_name.try(:blood_group).upcase, birth_place: @student_name.try(:birth_place), mg_batch_id: @mg_batch_id, language: @student_name.try(:language), religion: @student_name.try(:religion).upcase, updated_by: @session_user, is_deleted: 0, is_archive: 0, mg_school_id: @mg_school_id, created_by: @session_user, mg_student_admission_id: @student_name.id, mg_student_catagory_id: @student_name.mg_student_category_id, class_roll_number: @student_name.admission_number, admission_date: stu_admission_date })
  # end

  # def self.get_students_list(students, mg_school_id)
  #   students = MgStudent.where({ id: students, is_deleted: 0, mg_school_id:, is_archive: 0 }).order(:first_name)
  #   students_list = []
  #   students.collect { |stu,|
  #     student = Hash.new
  #     first_name = stu.first_name
  #     if stu.middle_name.to_s != ""
  #       middle_name = stu.middle_name
  #     end
  #     if stu.middle_name == "null"
  #       middle_name = stu.middle_name.gsub("null", " ")
  #     end
  #     last_name = stu.last_name
  #     student_name = first_name + " " + last_name
  #     if middle_name != nil
  #       student_name = first_name + " " + middle_name + " " + last_name
  #     end
  #     student.[]=("name", student_name)
  #     student.[]=("id", stu.id)
  #     students_list << student
  #   }
  #   students_list
  # end

  # def father_name
  #   student_father = self.mg_student_guardians.find_by({ relation: "FATHER", is_deleted: 0 })
  #   if !student_father.nil?
  #     father = student_father.mg_guardian
  #     if !father.nil?
  #       if !["-", "", nil].include?(father.last_name)
  #         f_last_name = father.last_name.strip
  #       else
  #         f_last_name = ""
  #       end
  #       if !father.middle_name.nil?
  #         f_middle_name = father.middle_name.strip
  #         if ["-", ""].include?(f_middle_name)
  #           "#{father.first_name.strip} #{f_last_name}"
  #         else
  #           "#{father.first_name.strip} #{f_middle_name} #{f_last_name}"
  #         end
  #       else
  #         "#{father.first_name.strip} #{f_last_name}"
  #       end
  #     else
  #       ""
  #     end
  #   end
  # end

  # def mother_name
  #   student_mother = self.mg_student_guardians.find_by({ relation: "Mother", is_deleted: 0 })
  #   if !student_mother.nil?
  #     mother = student_mother.mg_guardian
  #     if !mother.nil?
  #       if !["-", "", nil].include?(mother.last_name)
  #         m_last_name = mother.last_name.strip
  #       else
  #         m_last_name = ""
  #       end
  #       if !mother.middle_name.nil?
  #         m_middle_name = mother.middle_name.strip
  #         if ["-", ""].include?(m_middle_name)
  #           "#{mother.first_name.strip} #{m_last_name}"
  #         else
  #           "#{mother.first_name.strip} #{m_middle_name} #{m_last_name}"
  #         end
  #       else
  #         "#{mother.first_name.strip} #{m_last_name}"
  #       end
  #     else
  #       ""
  #     end
  #   end
  # end

  # def father_phone_number
  #   student_father = self.mg_student_guardians.find_by({ relation: "FATHER", is_deleted: 0 })
  #   if !student_father.nil?
  #     father = student_father.mg_guardian
  #     if !father.nil?
  #       phone = MgPhone.where({ mg_user_id: father.mg_user_id, phone_type: "mobile" })
  #       if phone.[](0).present?
  #         "#{phone.[](0).phone_number}"
  #       else
  #         "n/a"
  #       end
  #     else
  #       ""
  #     end
  #   end
  # end

  # def mother_phone_number
  #   student_mother = self.mg_student_guardians.find_by({ relation: "MOTHER", is_deleted: 0 })
  #   if !student_mother.nil?
  #     mother = student_mother.mg_guardian
  #     if !mother.nil?
  #       phone = MgPhone.where({ mg_user_id: mother.mg_user_id, phone_type: "mobile" })
  #       if phone.[](0).present?
  #         "#{phone.[](0).phone_number}"
  #       else
  #         "n/a"
  #       end
  #     else
  #       ""
  #     end
  #   end
  # end
end
