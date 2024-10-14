class MgExpenseItem < ApplicationRecord
  belongs_to(:mg_expense_head)
  belongs_to(:mg_school)
  validate(:has_a_item_name)
  validates_length_of(:item_name, { minimum: 1, maximum: 255, allow_blank: true })
  before_save(:strip_whitespace)

  def strip_whitespace
    unless self.item_name.nil?
      self.item_name=self.item_name.strip
    end
    unless self.description.nil?
      self.description=self.description.strip
    end
  end
end
private

def has_a_item_name
  if self.item_name.empty?
    errors.add(:base, "item_name cannot empty")
  end
end
