class MgExamAttendance < ApplicationRecord
  belongs_to(:mg_batch)
  belongs_to(:mg_cbsc_exam_type)
  belongs_to(:mg_scholastic_exam_particular)
  validates(:mg_batch_id, { uniqueness: { scope: [:mg_cbsc_exam_type_id, :mg_scholastic_exam_particular, :mg_time_table_id], conditions: lambda {
    where({ is_deleted: false })
  }, message: "already given!" }, on: :create })
  validates(:mg_batch_id, { uniqueness: { scope: [:mg_cbsc_exam_type_id, :mg_time_table_id], conditions: lambda {
    where({ is_deleted: false, mg_scholastic_exam_particular: "" })
  }, message: "already given!" }, on: :create })
end
