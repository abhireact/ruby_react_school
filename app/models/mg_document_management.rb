class MgDocumentManagement < ApplicationRecord
  has_attached_file(:file)
  validates_attachment_content_type(:file, { content_type: [] })
  has_many :mg_document_trackers,  dependent: :destroy 
  has_many :mg_comments,  as: :commentable, dependent: :destroy 
  belongs_to(:mg_school)
  belongs_to(:mg_subject)
  belongs_to(:mg_course)
  belongs_to(:mg_user)
  belongs_to(:mg_inventory_item)
  belongs_to(:mg_add_report)
  belongs_to(:mg_employee_folder)
  has_many :mg_alumni_programme_attendeds,  dependent: :destroy 
  has_many :mg_batch_documents,  dependent: :destroy 
  has_many :mg_batches,  through: :mg_batch_documents, dependent: :destroy 
end
