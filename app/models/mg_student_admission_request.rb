class MgStudentAdmissionRequest < ApplicationRecord
  has_many :mg_student_admission_payment_details,  dependent: :destroy 

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
    if father_middle_name != nil
      middle_name_striped = father_middle_name.strip
    end
    if father_last_name != nil
      last_name_striped = father_last_name.strip
    end
    if ["-", "", nil].include?(middle_name_striped)
      "#{father_first_name.strip} #{last_name_striped}"
    else
      if ["-", "", nil].include?(last_name_striped)
        "#{father_first_name.strip}"
      else
        "#{father_first_name.strip} #{middle_name_striped} #{last_name_striped}"
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
