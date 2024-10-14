class MgBooksInventory < ApplicationRecord
  belongs_to(:mg_school)
  belongs_to(:mg_course)
  has_many :mg_books_transactions,  dependent: :destroy 
  has_many :students,  through: :mg_books_transactions, dependent: :destroy 
end
