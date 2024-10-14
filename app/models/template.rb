class Template < ApplicationRecord
  belongs_to(:mg_school)
  validate(:check_validation, { on: [:create] })

  def check_validation
    unless self.vendor_name.nil?
      vendor_name = self.vendor_name
    end
    unless self.action_id.nil?
      action_id = self.action_id
    end
    if self.is_deleted == 0
      thisObj = Template.where({ vendor_name:, action_id:, is_deleted: 0, mg_school_id: self.mg_school_id })
      if thisObj.present?
        errors.add(:base, "This activity has already been taken")
      end
    end
  end
end
