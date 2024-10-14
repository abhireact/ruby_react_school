class MgAssignmentDocumentation < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_assignments,  dependent: :destroy 
  belongs_to(:mg_student)
  belongs_to(:mg_employee)
  has_attached_file(:file)
  validates_attachment_content_type(:file, { content_type: [] })
end
