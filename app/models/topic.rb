class Topic < ApplicationRecord
  has_many :mg_curriculums,  dependent: :destroy 
end
