class MgExpenseHead < ApplicationRecord
  belongs_to(:mg_school)
  has_many :mg_expense_items,  dependent: :destroy 
  accepts_nested_attributes_for(:mg_expense_items, { reject_if: :all_blank, allow_destroy: true })
  validates_presence_of(:name)
  validates_length_of(:name, { minimum: 1, maximum: 255, allow_blank: true })
  before_save(:strip_whitespace)

  def strip_whitespace
    unless self.name.nil?
      self.name=self.name.strip
    end
    unless self.description.nil?
      self.description=self.description.strip
    end
  end
end
