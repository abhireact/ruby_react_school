class MgSubject < ApplicationRecord
  validates(:index, { uniqueness: { scope: [:mg_school_id, :mg_course_id], conditions: lambda {
    where({ is_deleted: false })
  }, allow_nil: true, allow_blank: true } })
  belongs_to(:mg_wing)
  belongs_to(:mg_school)
  has_many :mg_online_educations,  dependent: :destroy 
  has_many :mg_create_question_papers,  dependent: :destroy 
  has_many :mg_batch_subjects,  dependent: :destroy 
  has_many :mg_employee_subjects,  dependent: :destroy 
  has_many :mg_time_table_entries,  dependent: :destroy 
  has_many :mg_subject_components,  dependent: :destroy 
  validates_presence_of(:subject_name)
  validates(:max_weekly_class, { numericality: { only_integer: true } })
  belongs_to(:mg_course)
  delegate :course_name, to: :mg_course
  delegate :course_batch_name, to: :mg_batch

  def can_destroy?
    table_list = Array.new
    self.class.reflect_on_all_associations.each { |assoc,|
      if (assoc.macro == :has_many && self.send(assoc.name).present?) || (assoc.macro == :has_one && self.send(assoc.name).present?)
        table_list.push(assoc.name)
      end
    }
    table_list
  end

  def self.search(search)
    arr = Array.new
    arr.push(search)
    search_value = ""
    if search
      if arr.size > 0
        for i in 0..arr.size - 1 do
          search_value += " subject_name LIKE '%#{arr.[](i)}%' or subject_code LIKE '%#{arr.[](i)}%' "
          search_value += " or mg_course_id IN (select id from mg_courses where              course_name LIKE '%#{arr.[](i)}%') "
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

  def subject_course_name
    "#{course_name}"
  end

  def student_name1
    "#{first_name}  #{last_name}"
  end

  def course_batch_name_student
    "#{course_batch_name}"
  end
end
