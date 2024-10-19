module BatchesHelper
	def get_dependent_models_for_batch(table_name)
		link_name = Array.new
		if table_name.to_s == "mg_students"
			link_name[0] = "students"
			link_name[1] = "Student List"
		elsif  table_name.to_s == "mg_time_table_entries"
			link_name[0] = "timetable"
			link_name[1] = "Time Table Association"
		end
		return link_name
	end
end
