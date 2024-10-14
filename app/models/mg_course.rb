class MgCourse < ApplicationRecord
  validates(:index, { uniqueness: { scope: [:mg_time_table, :mg_school_id], conditions: lambda {
    where({ is_deleted: false })
  }, allow_nil: true } })
  belongs_to(:mg_wing)
  belongs_to(:mg_school)
  belongs_to(:mg_time_table)
  has_many :mg_students,  dependent: :destroy 
  has_many :mg_batches,  dependent: :destroy 
  has_many :mg_subjects,  dependent: :destroy 
  has_many :mg_cbsc_exam_type_associations,  dependent: :destroy 
  has_many :mg_student_admissions,  dependent: :destroy 
  has_many :mg_fee_registrations,  dependent: :destroy 
  has_many :mg_cbsc_exam_type_associations,  dependent: :destroy 
  has_many :mg_cbsc_co_scho_particular_class_assoc,  dependent: :destroy 
  has_many :mg_cbsc_scho_particular_class_assoc,  dependent: :destroy 

  def can_destroy?
    table_list = Array.new
    self.class.reflect_on_all_associations.each { |assoc,|
      if (assoc.macro == :has_many && self.send(assoc.name).present?) || (assoc.macro == :has_one && self.send(assoc.name).present?)
        table_list.push(assoc.name)
      end
    }
    table_list
  end

  def full_name
    "#{course_name} #{section_name}"
  end

  def active_batches
    self.mg_batches.all
  end

  def has_batch_groups_with_active_batches
    batch_groups = self.mg_batch_groups
    if batch_groups.empty?
      return false
    else
      batch_groups.each { |b,|
        if b.has_active_batches == true
          return true
        end
      }
    end
    false
  end
end
