class MgHelpDocument < ApplicationRecord
  belongs_to(:mg_school)
  has_attached_file(:document)
  validates_attachment_content_type(:document, { content_type: [] })
end
