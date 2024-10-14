class MgTopic < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_employee)
  belongs_to(:mg_syllabus)
  belongs_to(:mg_wing)
  belongs_to(:mg_subject)
  belongs_to(:mg_course)
  belongs_to(:mg_unit)
  has_many :mg_curriculums,  dependent: :destroy 
  has_many :mg_syllabus_trackers,  dependent: :destroy 
  has_many :mg_online_educations,  dependent: :destroy 
  has_many :mg_online_educations,  dependent: :destroy 

  def self.search(search)
    arr = []
    arr.push(search)
    search_value = ""
    if search
      if arr.size > 0
        for i in 0..arr.size - 1 do
          search_value += " topic_name LIKE '%#{arr.[](i)}%' "
          search_value += " or mg_syllabus_id IN (SELECT id FROM mg_syllabuses where name LIKE '%#{arr.[](i)}%') "
          search_value += " or mg_unit_id IN (SELECT id FROM mg_units where unit_name LIKE '%#{arr.[](i)}%') "
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
end
