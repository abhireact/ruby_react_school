module MgEmployeePositionsHelper
	def get_employee_position
		puts "helper methods"
		MgEmployeeCategory.where(is_deleted:0).pluck(:category_name,:id)
	end
end
