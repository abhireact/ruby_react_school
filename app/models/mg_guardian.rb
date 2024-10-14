class MgGuardian < ApplicationRecord
  belongs_to(:mg_user)
  belongs_to(:mg_school)
  has_attached_file(:photo, { styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "adminImage.png" })
  validates_attachment_content_type(:photo, { content_type: /\Aimage\/.*\Z/ })
  has_many :mg_student_guardians,  foreign_key: "mg_guardians_id", primary_key: "id", dependent: :destroy 
  has_many :mg_student,  through: :mg_student_guardians, dependent: :destroy 

  def self.search_guardian(search)
    arr = []
    arr.push(search)
    puts("Search+++++++++++++++++++++++++++")
    puts(search)
    puts("Search+++++++++++++++++++++++++++")
    search_value = ""
    if search
      if arr.size > 0
        for i in 0..arr.size - 1 do
          search_value += " first_name LIKE '%#{arr.[](i)}%' or CONCAT(first_name,' ',last_name) LIKE '%#{arr.[](i)}%' or mg_user_id IN (select id from mg_users where  user_name LIKE '%#{arr.[](i)}%') "
          if i < arr.size.-(1)
            search_value += " or "
          end
        end
      end
      where(search_value)
    else
      all
    end
  end

  def self.search(search)
    arr = Array.new
    arr.push(search)
    puts(arr.inspect)
    search_value = ""
    if search
      if arr.size > 0
        for i in 0..arr.size - 1 do
          search_value += "first_name LIKE '%#{arr.[](i)}%' or CONCAT(first_name,' ',last_name) LIKE '%#{arr.[](i)}%' or relation LIKE '%#{arr.[](i)}%'  or occupation LIKE '%#{arr.[](i)}%' "
          search_value += " or mg_user_id IN (SELECT mg_users.id FROM mg_guardians INNER JOIN mg_users ON mg_users.id = mg_guardians.mg_user_id where mg_users.user_name LIKE '%#{arr.[](i)}%') "
          search_value += " or mg_student_id IN (SELECT mg_guardians.mg_student_id FROM mg_guardians INNER JOIN mg_students ON mg_students.id = mg_guardians.mg_student_id where CONCAT(mg_students.first_name,' ',mg_students.last_name) LIKE '%#{arr.[](i)}%') "
          if i < arr.size.-(1)
            search_value += " or "
          end
        end
      end
      where(search_value)
    else
      all
    end
  end

  def guardian_name
    if middle_name == "null"
      "#{first_name} #{last_name}"
    else
      "#{first_name} #{middle_name} #{last_name}"
    end
  end

  def self.guardian(users_name, mg_user_id, mg_student, mg_school_id, session_user, student_id)
    first_name = mg_student.guardian_first_name
    middle_name = mg_student.guardian_middle_name
    last_name = mg_student.guardian_last_name
    relation = mg_student.relation
    MgGuardian.create({ first_name:, middle_name:, last_name:, relation:, mg_user_id: mg_user_id.id, mg_student_id: student_id, is_deleted: 0, mg_school_id:, created_by: session_user, updated_by: session_user, is_archive: 0 })
  end

  def self.guardian_father(users_name, mg_user_id, mg_student, mg_school_id, session_user, student_id)
    first_name = mg_student.guardian_first_name
    middle_name = mg_student.guardian_middle_name
    last_name = mg_student.guardian_last_name
    if !mg_student.f_occupation.present?
      occupation = ""
    else
      occupation = mg_student.f_occupation
    end
    relation = "FATHER"
    MgGuardian.create({ first_name: first_name.upcase, middle_name: middle_name.upcase, last_name: last_name.upcase, occupation: occupation.upcase, relation:, mg_user_id: mg_user_id.id, mg_student_id: student_id, is_deleted: 0, mg_school_id:, created_by: session_user, updated_by: session_user, is_archive: 0 })
  end

  def self.guardian_mother(users_name, mg_user_id, mg_student, mg_school_id, session_user, student_id)
    first_name = mg_student.mother_first_name
    middle_name = mg_student.mother_middle_name
    last_name = mg_student.mother_last_name
    if !mg_student.m_occupation.present?
      occupation = ""
    else
      occupation = mg_student.m_occupation
    end
    relation = "MOTHER"
    MgGuardian.create({ first_name: first_name.upcase, middle_name: middle_name.upcase, last_name: last_name.upcase, occupation: occupation.upcase, relation:, mg_user_id: mg_user_id.id, mg_student_id: student_id, is_deleted: 0, mg_school_id:, created_by: session_user, updated_by: session_user, is_archive: 0 })
  end
end
