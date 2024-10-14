class MgExpenseBudget < ApplicationRecord
  belongs_to(:mg_time_table)
  belongs_to(:mg_expense_head)
  belongs_to(:mg_school)
  validates(:mg_time_table_id, :amount, :budget_name, { presence: true })
  validates(:amount, { numericality: true })
  validates(:budget_name, { uniqueness: { scope: [:mg_school_id, :mg_time_table_id, :mg_expense_head_id] } })
end
