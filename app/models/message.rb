class Message
  include(ActiveModel::Validations)
  include(ActiveModel::Conversion)
  extend(ActiveModel::Naming)
  attr_accessor(:to_user_id, :subject, :description, :user_check, :from_user_id, :is_deleted, :status, :mg_school_id, :student_class_id, :employee_depart_id, :teacher_depart_id, :parent_class_id)
  validates(:subject, :description, { presence: true })

  def initialize(attributes = {})
    attributes.each { |name, value|
      send("#{name}=", value)
    }
  end

  def persisted?
    false
  end
end
