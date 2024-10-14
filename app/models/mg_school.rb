class MgSchool < ApplicationRecord
  validates(:school_name, :school_code, :address_line1, :city, :state, :pin_code, :country, :mobile_number, :email_id, :fax_number, :date_format, :currency_type, :affilicated_to, :grading_system, { presence: true })
  validates(:school_code, { uniqueness: { conditions: lambda {
    where({ is_deleted: false })
  } } })
  validates(:pin_code, { numericality: { only_integer: true } })
  validates(:email_id, { format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create } })
  has_attached_file(:logo, { styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "logo.jpg" })
  validates_attachment_content_type(:logo, { content_type: /\Aimage\/.*\Z/ })

  def schedule_command
    puts("It is for schedule job")
  end
  has_many :mg_fee_reciept_settings,  dependent: :destroy 

  def randomize_image_file_name
    puts("School image editing is going to call ")
  end
end
