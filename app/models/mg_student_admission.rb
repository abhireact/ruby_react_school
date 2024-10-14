class MgStudentAdmission < ApplicationRecord
  belongs_to(:mg_batch)
  belongs_to(:mg_school)
  belongs_to(:mg_course)
  belongs_to(:mg_student)
  belongs_to(:mg_student_category)
  belongs_to(:mg_user)
  has_many :mg_parent_previous_educations,  dependent: :destroy 
  has_many :mg_student_siblings,  dependent: :destroy 

  def student_name
    if middle_name != nil
      middle_name_striped = middle_name.strip
    end
    if last_name != nil
      last_name_striped = last_name.strip
    end
    if ["-", "", nil].include?(middle_name_striped)
      "#{first_name.strip} #{last_name_striped}"
    else
      if ["-", "", nil].include?(last_name_striped)
        "#{first_name.strip}"
      else
        "#{first_name.strip} #{middle_name_striped} #{last_name_striped}"
      end
    end
  end

  def father_name
    if guardian_middle_name != nil
      middle_name_striped = guardian_middle_name.strip
    end
    if guardian_last_name != nil
      last_name_striped = guardian_last_name.strip
    end
    if ["-", "", nil].include?(middle_name_striped)
      "#{guardian_first_name.strip} #{last_name_striped}"
    else
      if ["-", "", nil].include?(last_name_striped)
        "#{guardian_first_name.strip}"
      else
        "#{guardian_first_name.strip} #{middle_name_striped} #{last_name_striped}"
      end
    end
  end

  def mother_name
    if mother_middle_name != nil
      middle_name_striped = mother_middle_name.strip
    end
    if mother_last_name != nil
      last_name_striped = mother_last_name.strip
    end
    if ["-", "", nil].include?(middle_name_striped)
      "#{mother_first_name.strip} #{last_name_striped}"
    else
      if ["-", "", nil].include?(last_name_striped)
        "#{mother_first_name.strip}"
      else
        "#{mother_first_name.strip} #{middle_name_striped} #{last_name_striped}"
      end
    end
  end
end
