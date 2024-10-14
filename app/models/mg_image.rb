class MgImage < ApplicationRecord
  mount_uploader(:image, ImageUploader)
  mount_uploader(:video, ImageUploader)
  belongs_to(:mg_school)
  belongs_to(:mg_alumni_photo_gallery)
end
