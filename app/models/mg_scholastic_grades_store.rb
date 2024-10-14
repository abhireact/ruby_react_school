class MgScholasticGradesStore < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_time_table)
  belongs_to(:mg_batch)
  belongs_to(:mg_cbsc_exam_type)
  belongs_to(:mg_subject)

  def self.scholastic_details_store(grades, user_id)
    grades_array = []
    grades.each { |sch_ds,|
      scholasic_grade_update = self.find_by({ mg_school_id: sch_ds.[]("mg_school_id"), mg_time_table_id: sch_ds.[]("mg_time_table_id"), mg_batch_id: sch_ds.[]("mg_batch_id"), mg_cbsc_exam_type_id: sch_ds.[]("mg_cbsc_exam_type_id"), mg_subject_id: sch_ds.[]("mg_subject_id"), mg_student_id: sch_ds.[]("mg_student_id"), total_marks: sch_ds.[]("total_marks") })
      if scholasic_grade_update.present?
        scholasic_grade_update.update_attributes({ total_marks: sch_ds.[]("total_marks"), grade: sch_ds.[]("grade") })
      else
        scholasic_grade = self.new
        scholasic_grade.mg_school_id=sch_ds.[]("mg_school_id")
        scholasic_grade.mg_time_table_id=sch_ds.[]("mg_time_table_id")
        scholasic_grade.mg_batch_id=sch_ds.[]("mg_batch_id")
        scholasic_grade.mg_cbsc_exam_type_id=sch_ds.[]("mg_cbsc_exam_type_id")
        scholasic_grade.mg_subject_id=sch_ds.[]("mg_subject_id")
        scholasic_grade.mg_student_id=sch_ds.[]("mg_student_id")
        scholasic_grade.total_marks=sch_ds.[]("total_marks")
        scholasic_grade.grade=sch_ds.[]("grade")
        scholasic_grade.is_deleted=0
        scholasic_grade.created_by=user_id
        scholasic_grade.updated_by=user_id
        grades_array << scholasic_grade
      end
    }
    if grades_array.present?
      self.import(grades_array)
    end
  end
end
