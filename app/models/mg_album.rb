class MgAlbum < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_employee_department)
  belongs_to(:mg_event)
  belongs_to(:mg_batch)
  has_many :mg_user_albums,  dependent: :destroy 
  has_many :mg_album_photos,  dependent: :destroy 
end
