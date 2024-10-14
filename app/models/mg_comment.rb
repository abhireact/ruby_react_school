class MgComment < ApplicationRecord
  belongs_to :commentable,  polymorphic: true 
  has_many :mg_comments,  as: :commentable, dependent: :destroy 
end
