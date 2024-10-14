class MgFeeRegistration < ApplicationRecord
  belongs_to(:mg_wing, lambda {
    where({ is_deleted: 0 })
  })
  belongs_to(:mg_course, lambda {
    where({ is_deleted: 0 })
  })
  belongs_to(:mg_school, lambda {
    where({ is_deleted: 0 })
  })
  belongs_to(:mg_time_table, lambda {
    where({ is_deleted: 0 })
  })
  has_many :mg_regsitration_fee_collections,  dependent: :destroy 
  validates_presence_of(:amount, :name, :mg_time_table_id)
  validate(:check_validation, { on: [:create] })

  def check_validation
    if self.mg_wing_id.present?
      mg_fee_reg_wing = MgFeeRegistration.where({ mg_wing_id: self.mg_wing_id, is_deleted: 0, mg_school_id: self.mg_school_id, mg_time_table_id: self.mg_time_table_id })
      mg_course_ids = MgCourse.where({ mg_wing_id: self.mg_wing_id, is_deleted: 0, mg_school_id: self.mg_school_id, mg_time_table_id: self.mg_time_table_id }).pluck(:id)
      mg_fee_reg_course = MgFeeRegistration.where({ mg_course_id: mg_course_ids, is_deleted: 0, mg_school_id: self.mg_school_id })
      if mg_fee_reg_wing.present?
        errors.add(:base, "#{self.mg_wing.wing_name} registration fee already created")
      else
        if mg_fee_reg_course.present?
          course_names = []
          mg_fee_reg_course.each { |course,|
            course_names << course.mg_course.course_name
          }
          errors.add(:base, "#{course_names.join(",")} registration fee already created")
        end
      end
    else
      mg_fee_reg_course = MgFeeRegistration.where({ mg_course_id: self.mg_course_id, is_deleted: 0, mg_school_id: self.mg_school_id, mg_time_table_id: self.mg_time_table_id })
      wing_id = MgCourse.find_by({ id: self.mg_course_id, is_deleted: 0, mg_school_id: self.mg_school_id, mg_time_table_id: self.mg_time_table_id })
      mg_fee_reg_wing = MgFeeRegistration.where({ mg_wing_id: wing_id.mg_wing_id, is_deleted: 0, mg_school_id: self.mg_school_id, mg_time_table_id: self.mg_time_table_id })
      if mg_fee_reg_course.present?
        errors.add(:base, "#{self.mg_course.course_name} registration fee already created")
      else
        if mg_fee_reg_wing.present?
          errors.add(:base, "#{self.mg_course.course_name} registration fee already created in wing wise")
        end
      end
    end
  end
end
