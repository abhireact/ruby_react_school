class MgSyllabus < ApplicationRecord
  belongs_to(:mg_subject)
  belongs_to(:mg_school)
  has_many :mg_batch_syllabuses,  dependent: :destroy 
  has_many :mg_batched,  through: :mg_batch_syllabuses, dependent: :destroy 
  has_many :mg_syllabus_trackers,  dependent: :destroy 
  has_many :mg_topics,  dependent: :destroy 
  has_many :mg_units,  dependent: :destroy 
  has_many :mg_question_banks,  dependent: :destroy 
  belongs_to(:mg_batch)

  def self.search(search)
    arr = []
    arr.push(search)
    puts("Search+++++++++++++++++++++++++++")
    puts(search)
    puts("Search+++++++++++++++++++++++++++")
    search_value = ""
    if search
      if arr.size > 0
        for i in 0..arr.size - 1 do
          search_value += " name LIKE '%#{arr.[](i)}%' "
          search_value += " or mg_subject_id IN (SELECT id FROM mg_subjects where subject_code LIKE '%#{arr.[](i)}%') "
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
