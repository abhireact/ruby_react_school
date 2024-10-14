class MgUser < ApplicationRecord
  attr_accessor(:password)
  before_save(:encrypt_password)
  before_update(:encrypt_password)
  validates_confirmation_of(:password)
  validates_presence_of(:password, { on: :create })
  validates_presence_of(:user_name)
  validates(:user_name, { uniqueness: { scope: :mg_school_id, conditions: lambda {
    where({ is_deleted: false })
  } } })
  belongs_to(:mg_school)
  has_many :mg_addresses,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_addresses)
  has_many :mg_emails,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_emails)
  has_many :mg_phones,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_phones)
  has_many :mg_guardians,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_guardians)
  has_many :mg_employees,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_employees)
  has_many :mg_user_roles,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_user_roles)
  has_many :mg_students,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_students)
  has_one :mg_account_central_incharge,  dependent: :destroy 
  has_one :mg_alumni,  dependent: :destroy 
  has_many :mg_hostel_detail,  through: :mg_allocate_rooms, dependent: :destroy 
  has_many :mg_hostel_detail,  through: :mg_hostel_warden, dependent: :destroy 
  has_many :mg_hobbies,  through: :mg_hobby_associations, dependent: :destroy 
  has_many :mg_sports,  through: :mg_sports_association, dependent: :destroy 
  has_many :mg_inventory_store_managements,  through: :mg_inventory_store_manager, dependent: :destroy 
  has_one :mg_employee,  dependent: :destroy 
  has_one :mg_employee_children,  dependent: :destroy 
  has_one :mg_laboratory_incharge,  dependent: :destroy 
  has_one :mg_management_quota,  dependent: :destroy 
  has_one :mg_sibling,  dependent: :destroy 
  has_one :mg_student_scholarship,  dependent: :destroy 
  has_one :mg_student,  dependent: :destroy 
  has_many :mg_allergies,  dependent: :destroy 
  has_many :mg_alumni_get_togethers,  dependent: :destroy 
  has_many :mg_alumni_item_sale_details,  dependent: :destroy 
  has_many :mg_alumnis,  through: :mg_alumni_photo_galleries, dependent: :destroy 
  has_many :mg_canteen_bill_details,  dependent: :destroy 
  has_many :mg_custom_fields_data,  dependent: :destroy 
  has_many :mg_document_managements,  dependent: :destroy 
  has_many :mg_hostel_detail,  through: :mg_hostel_floors, dependent: :destroy 
  has_many :mg_hostel_room_types,  dependent: :destroy 
  has_many :mg_inventory_projections,  dependent: :destroy 
  has_many :mg_inventory_proposals,  dependent: :destroy 
  has_many :mg_languages,  dependent: :destroy 
  has_many :refresh_tokens,  dependent: :delete_all 
  has_many :whitelisted_tokens,  dependent: :delete_all 
  has_many :blacklisted_tokens,  dependent: :delete_all 

  def self.authenticate(user_name, password)
    user = find_by_user_name(user_name)
    if user && user.hashed_password == BCrypt::Engine.hash_secret(password, user.salt)
      user
    else
      nil
    end
  end

  def self.authenticateUser(user_name, password, school_id)
    user = find_by_user_name(user_name)
    if user && user.hashed_password == BCrypt::Engine.hash_secret(password, user.salt) && user.mg_school_id == school_id
      user
    else
      nil
    end
  end

  def self.authenticateUsers(user_name, password, is_deleted)
    user = find_by_user_name(user_name)
    if user && user.hashed_password == BCrypt::Engine.hash_secret(password, user.salt) && is_deleted == false
      user
    else
      nil
    end
  end

  def self.authenticateUsersWithSchool(user_name, password, is_deleted, mg_school_id)
    user = find_by({ user_name:, is_deleted: 0 })
    puts(user_name)
    if user && user.hashed_password == BCrypt::Engine.hash_secret(password, user.salt) && user.is_deleted == false && user.mg_school_id == mg_school_id
      user
    else
      nil
    end
  end

  def encrypt_password
    if password.present?
      self.salt=BCrypt::Engine.generate_salt
      self.hashed_password=BCrypt::Engine.hash_secret(password, salt)
    end
  end

  def user_full_name
    if middle_name != nil
      middle_name_striped = middle_name.strip
    end
    if last_name != nil
      last_name_striped = last_name.strip
    end
    if ["-", "", nil].include?(middle_name_striped)
      "#{first_name.strip} #{last_name_striped}"
    else
      if ["-", "", nil].include?(last_name_striped)
        "#{first_name.strip}"
      else
        "#{first_name.strip} #{middle_name_striped} #{last_name_striped}"
      end
    end
  end
end
