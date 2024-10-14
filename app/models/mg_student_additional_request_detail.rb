class MgStudentAdditionalRequestDetail < ApplicationRecord
  has_attached_file(:photo)
  validates_attachment_content_type(:photo, { content_type: [] })
  has_attached_file(:signature)
  validates_attachment_content_type(:signature, { content_type: [] })
  has_attached_file(:high_school_marks_sheet)
  validates_attachment_content_type(:high_school_marks_sheet, { content_type: [] })
  has_attached_file(:intermediate_marks_sheet)
  validates_attachment_content_type(:intermediate_marks_sheet, { content_type: [] })
  has_attached_file(:adhar)
  validates_attachment_content_type(:adhar, { content_type: [] })
end
