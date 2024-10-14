class MgResourceCategory < ApplicationRecord
  before_save(:strip_whitespace)
  has_many :mg_resource_types,  dependent: :destroy 
  belongs_to(:mg_school)
  has_many :mg_resource_informations,  dependent: :destroy 
  has_many :mg_resource_inventories,  dependent: :destroy 
  belongs_to(:mg_wing)

  def strip_whitespace
    unless self.name.nil?
      self.name=self.name.strip
    end
  end

  def can_destroy?
    table_list = Array.new
    self.class.reflect_on_all_associations.each { |assoc,|
      name = assoc.name
      if assoc.macro === (:has_many || :has_one) && self.send(name).present?
        table_list.push(name)
      end
    }
    table_list
  end
end
