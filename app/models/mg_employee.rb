class MgEmployee < ApplicationRecord
  # has_attached_file(:photo, { styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "adminImage.png" })
  # validates_attachment_content_type(:photo, { content_type: /\Aimage\/.*\Z/ })
  # belongs_to(:mg_employee_category)
  # belongs_to(:mg_employee_department)
  # belongs_to(:mg_employee_grade)
  # belongs_to(:mg_employee_position)
  # belongs_to(:mg_user)
  # belongs_to(:mg_school)
  # belongs_to(:mg_employee_type)
  # has_many :mg_attendance_finalize_times,  dependent: :destroy 
  # has_many :mg_employee_grade_components,  dependent: :destroy 
  # has_many :mg_hostel_wardens,  dependent: :destroy 
  # has_many :mg_time_table_change_entries,  dependent: :destroy 
  # has_many :mg_time_table_entries,  dependent: :destroy 
  # has_one :mg_transport,  dependent: :destroy 
  # has_many :mg_syllabus_trackers,  dependent: :destroy 
  # delegate :department_name, to: :mg_employee_department
  # delegate :category_name, to: :mg_employee_category
  # delegate :user_name, to: :mg_user
  # belongs_to :mg_bank_detail, optional: true
  # has_many :mg_employee_grade_components,  dependent: :destroy 
  # has_one :mg_employee_bank,  dependent: :destroy 
  # has_many :mg_bank_account_details,  dependent: :destroy 
  # has_one :mg_bank_account_detail,  dependent: :destroy 

  # def can_destroy?
  #   table_list = Array.new
  #   self.class.reflect_on_all_associations.each { |assoc,|
  #     if (assoc.macro == :has_many && self.send(assoc.name).present?) || (assoc.macro == :has_one && self.send(assoc.name).present?)
  #       table_list.push(assoc.name)
  #     end
  #   }
  #   puts("==============")
  #   puts(table_list)
  #   puts("==============")
  #   table_list
  # end

  # def self.search(search)
  #   arr = Array.new
  #   joinDate = 0
  #   arr.push(search)
  #   if search.present?
  #     joinDate = search.split("/").reverse.join("-")
  #   end
  #   @date = Array.new
  #   search_value = ""
  #   if search
  #     if arr.size > 0
  #       for i in 0..arr.size - 1 do
  #         search_value += " CONCAT(first_name,' ',last_name) LIKE '%#{arr.[](i)}%' or employee_number LIKE '%#{arr.[](i)}%' or joining_date LIKE '%#{joinDate}%'"
  #         search_value += " or mg_employee_department_id IN (select id from mg_employee_departments where department_name LIKE '%#{arr.[](i)}%') "
  #         search_value += " or mg_employees.mg_employee_position_id  IN (select id from mg_employee_positions where position_name LIKE '%#{arr.[](i)}%') "
  #         if i < arr.size.-(1)
  #           search_value += " or "
  #         end
  #       end
  #     end
  #     where(search_value)
  #   else
  #     all
  #   end
  # end

  # def self.get_all_teaching_staff(school_id)
  #   MgEmployee.where({ is_archive: 0, is_deleted: 0, mg_school_id: school_id, mg_employee_category_id: MgEmployeeCategory.find_by({ category_name: "Teaching Staff" }).id })
  # end

  # def self.get_employee_by_id(id)
  #   MgEmployee.find(id)
  # end

  # def employee_name
  #   "#{first_name} #{middle_name} #{last_name}"
  # end

  # def employee_full_name
  #   if middle_name != nil
  #     middle_name_striped = middle_name.strip
  #   end
  #   if last_name != nil
  #     last_name_striped = last_name.strip
  #   end
  #   if ["-", "", nil].include?(middle_name_striped)
  #     "#{first_name} #{last_name_striped}"
  #   else
  #     if ["-", "", nil].include?(last_name_striped)
  #       "#{first_name}"
  #     else
  #       "#{first_name} #{middle_name_striped} #{last_name_striped}"
  #     end
  #   end
  # end

  # def dept_name
  #   "#{department_name}"
  # end

  # def category_names
  #   "#{category_name}"
  # end

  # def employee_user_name
  #   "#{user_name}"
  # end

  # def employee_full_name_with_number
  #   "#{employee_number}#{" - "}#{first_name} #{last_name}"
  # end

  # def self.get_employees_list(emp_ids, mg_school_id)
  #   employees = self.where({ id: emp_ids, is_deleted: 0, mg_school_id:, is_archive: 0 }).order(:first_name)
  #   employees_list = []
  #   employees.collect { |emp,|
  #     employee = Hash.new
  #     first_name = emp.first_name
  #     if emp.middle_name.to_s != ""
  #       middle_name = emp.middle_name
  #     end
  #     if emp.middle_name == "null"
  #       middle_name = emp.middle_name.gsub("null", "")
  #     end
  #     if emp.last_name.to_s != ""
  #       last_name = emp.last_name
  #     end
  #     if emp.last_name == "null"
  #       last_name = emp.last_name.gsub("null", "")
  #     end
  #     employee_name = first_name
  #     if last_name != nil
  #       employee_name = first_name + " " + last_name
  #     end
  #     if middle_name != nil && last_name != nil
  #       employee_name = first_name + " " + middle_name + " " + last_name
  #     end
  #     employee.[]=("name", employee_name)
  #     employee.[]=("id", emp.id)
  #     employees_list << employee
  #   }
  #   employees_list
  # end
end
