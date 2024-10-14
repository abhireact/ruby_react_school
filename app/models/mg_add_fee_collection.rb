class MgAddFeeCollection < ApplicationRecord
  belongs_to(:mg_school)
  validates(:student_name, { length: { in: 1..40 } })
  validates(:total_amount, :paid_amount, { length: { in: 1..10 }, numericality: true })
  validates(:receipt_number, { uniqueness: true })

  def self.search(search)
    if search
      where("admission_number LIKE ?", "%#{search}%") || where("student_name LIKE ?", "%#{search}%")
    else
      scoped
    end
  end
end
