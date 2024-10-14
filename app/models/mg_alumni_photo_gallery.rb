class MgAlumniPhotoGallery < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_user)
  belongs_to(:mg_alumni)
  has_many :mg_images,  dependent: :destroy 
  has_attached_file(:image, { styles: { thumb: "100x100>", square: "200x200#", medium: "300x300>" } })
end
