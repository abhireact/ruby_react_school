module ApplicationHelper
	def tooltip(content, options = {}, html_options = {}, *parameters_for_method_reference)
	html_options[:title] = options[:tooltip]
	html_options[:class] = html_options[:class] || 'tooltip'
	content_tag("span", content, html_options)
	end
  
	def date_format(mg_school_id)
	   @date_format=MgSchool.find_by(:id=>mg_school_id).date_format
	   return @date_format
	end

	def get_wings_or_programme
		MgWing.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:wing_name,:id)
	end

	def get_employee_position
		MgEmployeeCategory.where(:is_deleted=>0).pluck(:category_name,:id)
		
	end
	#added by mamatha starts

	def get_guardian_name_by_guardian_id(guardian_id)
		MgGuardian.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>guardian_id).pluck("CONCAT(mg_guardians.first_name,' ',COALESCE(mg_guardians.middle_name, ''),' ',COALESCE(mg_guardians.last_name,'') )").join( ' ')
	end
	#added by mamatha ends

	def get_classes_by_wing_id(wing_id)
		MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_wing_id=>wing_id).pluck(:course_name,:id)
	end

	def get_wing(wing_id)
		MgWing.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>wing_id).pluck(:wing_name)
	end

	def get_classes
		MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:course_name,:id)
	    # @academic_years  =   MgTimeTable.where("start_date < \"#{Date.today}\" && \"#{Date.today}\" < end_date").where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])

	end
	def courses_by_academic_years(mg_time_table_id)
		academic_years  =  MgTimeTable.find_by(:id=>mg_time_table_id,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])#where("start_date < \"#{Date.today}\" && \"#{Date.today}\" < end_date").where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        query = "start_date BETWEEN '#{academic_years.start_date}' AND '#{academic_years.end_date}' AND  end_date  BETWEEN '#{academic_years.start_date}' AND '#{academic_years.end_date}' "
        batch_obj = MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).where(query)
        .joins(:mg_course).pluck("CONCAT(mg_courses.course_name,'-',mg_batches.name)","id")
		return batch_obj
	end

	def get_section(course_id)
		current_date =  Date.today
		MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>course_id).pluck(:name,:id)
		# MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>course_id).where('start_date >= ? and end_date <= ?', current_date,current_date).pluck(:name,:id)
	end

	def get_course_batch_name_wing_id(wing_id)
		current_date =  Date.today
		@classes=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_wing_id=>wing_id).pluck(:id)
		@batch=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>@classes).where("'#{current_date}' BETWEEN start_date AND end_date").joins(:mg_course).pluck("CONCAT(mg_courses.course_name,'-',mg_batches.name)","id")
		return @batch
	end

	def get_course_batch_name_wing_id_time_id(wing_id,time_table_id)
		
		current_date =  Date.today
		@classes=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_wing_id=>wing_id,:mg_time_table_id=>time_table_id).pluck(:id)
		@batch=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>@classes).joins(:mg_course).pluck("CONCAT(mg_courses.course_name,'-',mg_batches.name)","id")
		return @batch
	end

	def get_course_batch_name
		current_date =  Date.today
		#MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).where("'#{current_date}' BETWEEN start_date AND end_date").joins(:mg_course).pluck("CONCAT(mg_courses.course_name,'-',mg_batches.name)","id")
		MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).joins(:mg_course).pluck("CONCAT(mg_courses.course_name,'-',mg_batches.name)","id")
	end
  
def get_class_section
  current_date = Date.today
  MgBatch.where(
    is_deleted: 0,
    mg_school_id: session[:current_user_school_id]
  ).joins(:mg_course).pluck(
    Arel.sql("CONCAT(mg_courses.course_name, '-', mg_batches.name)"),
    Arel.sql("CONCAT(mg_courses.id, '-', mg_batches.id)"),
	Arel.sql("mg_courses.mg_time_table_id")
  )
end
def get_section_class
	current_date = Date.today
	MgBatch.where(
	  is_deleted: 0,
	  mg_school_id: session[:current_user_school_id]
	).joins(:mg_course).pluck(
	  Arel.sql("CONCAT(mg_courses.course_name, '-', mg_batches.name)"),
	  Arel.sql("mg_batches.id"),
	  Arel.sql("mg_courses.mg_time_table_id"),
	
	  Arel.sql("mg_courses.id") # Add mg_course_id here
	).map do |name, mg_batch_id, mg_time_table_id, mg_course_id|
	  {
		name: name,
		mg_batch_id: mg_batch_id,
		mg_time_table_id: mg_time_table_id,
		mg_course_id: mg_course_id # Include mg_course_id in the result
	  }
	end
  end
  
  
	def get_course_batch_name_all
		#current_date =  Date.today
		MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).joins(:mg_course).pluck("CONCAT(mg_courses.course_name,'-',mg_batches.name)","id")
		# MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).joins(:mg_course).pluck("CONCAT(mg_courses.course_name,'-',mg_batches.name)","id")
	end

	def get_student_list_by_batch_for_select(batch_id)
		
	MgStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_batch_id=>batch_id).order(:first_name).pluck("CONCAT_WS(' ',mg_students.first_name,mg_students.middle_name,mg_students.last_name)",:id)
	
    end

	def get_student_list_by_batch(batch_id)
		MgStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_batch_id=>batch_id,:is_archive => 0).order(:first_name).pluck(:first_name,:id)#pluck("CONCAT(mg_students.first_name,' ',mg_students.middle_name,' ',mg_students.last_name)","id")	
	end

	def get_student_and_id_list_by_batch(batch_id)
		#MgStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_batch_id=>batch_id,:is_archive => 0).order(:first_name).pluck("CONCAT(mg_students.admission_number,' - ',mg_students.first_name,' ',COALESCE(mg_students.middle_name,''),' ',mg_students.last_name)","id")	
	        MgStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_batch_id=>batch_id,:is_archive => 0).order(:first_name).pluck("CONCAT_WS(' ',mg_students.admission_number,'-',mg_students.first_name,mg_students.middle_name,mg_students.last_name)",:id)
        end

	def get_batch_wise_student_list(batch_id)
		MgStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_batch_id=>batch_id,:is_archive => 0).order(:first_name)
	end

	def get_employee_department
		MgEmployeeDepartment.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:department_name,:id)
	end

	def get_employee_category
		MgEmployeeCategory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:category_name,:id)
	end

	#added by mamatha starts

	def get_guardian_name_by_guardian_id(guardian_id)
		MgGuardian.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>guardian_id).pluck("CONCAT(mg_guardians.first_name,' ',COALESCE(mg_guardians.middle_name, ''),' ',COALESCE(mg_guardians.last_name,'') )").join( ' ')
	end


	def get_student_list_by_batch_id(batch_id)
		MgStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_batch_id=>batch_id,:is_archive => 0).order(:first_name).pluck(:id)
	end
	 #added by mamatha ends


	def get_employee_by_department_for_select(department_id)
		MgEmployee.where(:is_archive=>0,:status=>"Working",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_department_id=>department_id).pluck("CONCAT(mg_employees.first_name,' ',COALESCE(mg_employees.middle_name,''),' ',mg_employees.last_name)","id")
	end
        
        #added by vijay
	def get_student_list_by_batch(time_table_id, batch_id, exam_type)
		batch_student_id = MgStudent.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :is_archive => 0, :mg_batch_id=>batch_id).pluck(:id)
	    promotion_students_id = MgStudentBatchHistory.where(from_academic_year:time_table_id, from_section_id:batch_id,  mg_school_id: session[:current_user_school_id], is_deleted: false).pluck(:mg_student_id)
	    student_id = (batch_student_id + promotion_students_id).uniq
	    batch_count = MgScholasticRank.where(:mg_student_id => student_id, :mg_cbsc_exam_type_id => exam_type, :mg_batch_id => batch_id, :is_deleted => 0, :mg_school_id => session[:current_user_school_id])
	    return batch_count
    end
    def get_students_list_by_batch(time_table_id, batch_id)
		batch_student_id = MgStudent.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :is_archive => 0, :mg_batch_id=>batch_id).pluck(:id)
	    promotion_students_id = MgStudentBatchHistory.where(from_academic_year:time_table_id, from_section_id:batch_id,  mg_school_id: session[:current_user_school_id], is_deleted: false).pluck(:mg_student_id)
	    student_id = (batch_student_id + promotion_students_id).uniq
	    batch_count = @scholastic_rank = MgScholasticRank.where(:mg_student_id => student_id, :rank_calculation_type => "yearly", :mg_batch_id => batch_id, :rank_type => "Section Wise",:mg_school_id=>session[:current_user_school_id])
	    return batch_count
    end
	#ended by vijay
        

	def get_employee_by_department(department_id)
		MgEmployee.where(:is_archive=>0,:status=>"Working",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_department_id=>department_id)
	end
	def get_employee_and_id_by_department_for_select(department_id)
		MgEmployee.where(:is_archive=>0,:status=>"Working",:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_employee_department_id=>department_id).pluck("CONCAT(mg_employees.employee_number,' - ',mg_employees.first_name,' ',COALESCE(mg_employees.middle_name,''),' ',mg_employees.last_name)","id")
	end
	def sortable(column, title = nil)
		faClass = ""
	  title ||= column.titleize
	  if sort_direction == "asc"
	  	faClass = "fa fa-arrow-down"
	  else
	  	faClass = "fa fa-arrow-up"
	  end
	  css_class = column == sort_column ? "current  #{faClass} #{sort_direction}" : nil
	  direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
	  link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
	end
	def find_dependency(column,id)
		puts "in Helper"
		@valuesOfDependancy = Array.new
		ActiveRecord::Base.connection.tables.each do |table|
			ActiveRecord::Base.connection.columns(table).each do |column_name| 
				if column_name.name == column
					if @valuesOfDependancy.include? table
						
					else
					@valuesOfDependancy.push(table)
						
					end
				end
			end
		end
		puts "==========================================="
		puts "==========================================="
		puts @valuesOfDependancy
		puts "==========================================="
		puts "==========================================="
		
		
	end	

	def get_academic_year
		MgTimeTable.where(:mg_school_id=>session[:current_user_school_id],:is_deleted=>0).pluck(:name,:id)
	end

	def get_course_by_academic_year(timetable_id)
		MgCourse.where(:mg_school_id=>session[:current_user_school_id],:is_deleted=>0,:mg_time_table_id => timetable_id).pluck(:course_name,:id)
	end

	def get_course_batch_by_courses(courses_ids)
		current_date = Date.today
        # binding.pry
		# MgBatch.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :mg_course_id=>courses_ids).joins(:mg_course).pluck("CONCAT(mg_courses.course_name,'-',mg_batches.name)","id")

        MgBatch.where(:is_deleted => 0, :mg_school_id => session[:current_user_school_id], :mg_course_id => courses_ids)
       .joins(:mg_course)
       .pluck(Arel.sql("CONCAT(mg_courses.course_name, '-', mg_batches.name)"), "id")


	end


	def get_current_academic_year(school_id)
		current_date = Date.today
		MgTimeTable.where("start_date < \"#{current_date}\" && \"#{current_date}\" < end_date").where(:is_deleted=>0, :mg_school_id=>school_id).pluck(:id)
	end

	def get_students_ids_by_academic_year(academic_year, batch_id, school_id)
		current_academic_year = get_current_academic_year(session[:current_user_school_id]) 
		student_list = nil
			batch_student_ids = MgStudent.where(:is_deleted=>0, :mg_school_id=>school_id, :is_archive => 0, :mg_batch_id=>batch_id).pluck(:id)
			promotion_students_ids = MgStudentBatchHistory.where(from_academic_year:academic_year, from_section_id:batch_id,  mg_school_id: school_id, is_deleted: false).pluck(:mg_student_id)
			student_ids = (batch_student_ids + promotion_students_ids).uniq
			student_list = MgStudent.where(:id=>student_ids, :is_deleted=>0, :mg_school_id=>school_id, :is_archive => 0).order(:first_name).pluck(:id, :first_name, :middle_name, :last_name, :class_roll_number, :mg_batch_id, :mg_student_catagory_id)
		
    	return student_list
  	end

  	def get_students_by_academic_year(academic_year, batch_id, school_id)

		current_academic_year = get_current_academic_year(session[:current_user_school_id]) 
		student_list = nil
		
		batch_student_ids = MgStudent.where(:is_deleted=>0, :mg_school_id=>school_id, :is_archive => 0,:mg_batch_id=>batch_id).order(:first_name).pluck(:id)
		promotion_students_ids = MgStudentBatchHistory.where(from_academic_year:academic_year, from_section_id:batch_id,  mg_school_id: school_id, is_deleted: false).pluck(:mg_student_id)
		student_ids = (batch_student_ids + promotion_students_ids).uniq
		student_list = MgStudent.where(:id=>student_ids, :is_deleted=>0, :mg_school_id=>school_id, :is_archive => 0)#.order(:first_name) 
		
    	return student_list
  	end
	def get_students_by_current_academic_year(school_id)
		# Fetch the current academic year for the given school
		current_academic_year = get_current_academic_year(school_id)
	  
		# Initialize the student list
		student_list = nil
	  
		# Retrieve students in active batches for the current academic year
		batch_student_ids = MgStudent.where(
		  is_deleted: 0,
		  mg_school_id: school_id,
		  is_archive: 0
		).order(:first_name).pluck(:id)
	  
		# Retrieve students promoted into active batches for the current academic year
		promotion_student_ids = MgStudentBatchHistory.where(
		  from_academic_year: current_academic_year,
		  mg_school_id: school_id,
		  is_deleted: false
		).pluck(:mg_student_id)
	  
		# Combine and deduplicate student IDs from both sources
		student_ids = (batch_student_ids + promotion_student_ids).uniq
	  
		# Fetch the final list of students
		student_list = MgStudent.where(
		  id: student_ids,
		  is_deleted: 0,
		  mg_school_id: school_id,
		  is_archive: 0
		)
	  
		return student_list
	end
	  
  	def get_students_detail_for_selected_student(academic_year, batch_id, school_id,student_id)

		current_academic_year = get_current_academic_year(session[:current_user_school_id]) 
		student_list = nil
		
		batch_student_ids = MgStudent.where(:is_deleted=>0, :mg_school_id=>school_id, :is_archive => 0,:mg_batch_id=>batch_id,:id=>student_id).order(:first_name).pluck(:id)
		promotion_students_ids = MgStudentBatchHistory.where(from_academic_year:academic_year, from_section_id:batch_id,  mg_school_id: school_id, is_deleted: false,:mg_student_id=>student_id).pluck(:mg_student_id)
		student_ids = (batch_student_ids + promotion_students_ids).uniq
		student_list = MgStudent.where(:id=>student_ids, :is_deleted=>0, :mg_school_id=>school_id, :is_archive => 0)#.order(:first_name) 
		
    	return student_list
  	end  	



  	def get_students_by_academic_year_with_sorting_student_name(academic_year, batch_id, school_id)

		current_academic_year = get_current_academic_year(session[:current_user_school_id]) 
		student_list = nil
		
		batch_student_ids = MgStudent.where(:is_deleted=>0, :mg_school_id=>school_id, :is_archive => 0,:mg_batch_id=>batch_id).order(:first_name).pluck(:id)
		promotion_students_ids = MgStudentBatchHistory.where(from_academic_year:academic_year, from_section_id:batch_id,  mg_school_id: school_id, is_deleted: false).pluck(:mg_student_id)
		student_ids = (batch_student_ids + promotion_students_ids).uniq
		student_list = MgStudent.where(:id=>student_ids, :is_deleted=>0, :mg_school_id=>school_id, :is_archive => 0).order(:first_name,:last_name) 
		
    	return student_list
  	end

  	def get_students_by_academic_year_with_sorting(academic_year, batch_id, school_id, sorting_value)

		current_academic_year = get_current_academic_year(session[:current_user_school_id]) 
		student_list = nil
		
		batch_student_ids = MgStudent.where(:is_deleted=>0, :mg_school_id=>school_id, :is_archive => 0,:mg_batch_id=>batch_id).order(:first_name).pluck(:id)
		promotion_students_ids = MgStudentBatchHistory.where(from_academic_year:academic_year, from_section_id:batch_id,  mg_school_id: school_id, is_deleted: false).pluck(:mg_student_id)
		student_ids = (batch_student_ids + promotion_students_ids).uniq
		student_list = MgStudent.where(:id=>student_ids, :is_deleted=>0, :mg_school_id=>school_id, :is_archive => 0).order(sorting_value) 
		
    	return student_list
  	end

  	def get_classes_by_academic_and_wing_id(wing_id, timetable_id)
		MgCourse.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :mg_wing_id=>wing_id, mg_time_table_id:timetable_id).pluck(:course_name, :id)
	end

	def get_academic_wise_batch_id(academic_year,student_id,school_id)
    	current_academic_year = get_current_academic_year(session[:current_user_school_id])
    	if current_academic_year != academic_year
    		batch_ids = MgStudentBatchHistory.where(from_academic_year:academic_year, mg_student_id:student_id,  mg_school_id: school_id, is_deleted: false).pluck(:from_section_id)
    	else
    		batch_ids = MgStudent.where(:id=>student_id, :is_deleted=>0, :mg_school_id=>school_id, :is_archive => 0).pluck(:mg_batch_id)
    	end
    	return batch_ids
    end

    def course_batch_name(batch_id)
    	current_date = Date.today
		MgBatch.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>batch_id).joins(:mg_course).pluck("CONCAT(mg_courses.course_name,'-',mg_batches.name)")
    end

    def get_classes_by_academic_and_wing_id(wing_id, timetable_id)
		MgCourse.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :mg_wing_id=>wing_id, mg_time_table_id:timetable_id).pluck(:course_name, :id)
	end

	
	def get_employee_courses_and_batches(courses_ids)

		empo = MgEmployee.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id], :mg_user_id=>session[:user_id])
		employee_batches = MgBatch.includes(:mg_course).where(:mg_course_id=>courses_ids, :mg_employee_id=>empo.id) if empo.present?

		emp_course_batches = []
		if employee_batches.present?
			employee_batches.each do |emp_batch|

				batch_hash = {}
				batch_hash["course_batch"] = emp_batch.mg_course.course_name+"-"+ emp_batch.name
				batch_hash["batch_id"] = emp_batch.id

				emp_course_batches << batch_hash
			end
		end	
		return emp_course_batches
	end

	def get_batch_from_histroy(student_id, timetable_id, school_id)
		MgStudentBatchHistory.find_by(:from_academic_year=>timetable_id, mg_student_id:student_id, mg_school_id: school_id, is_deleted: false)
	end
	
	def get_subject_code_by_batch_subject(batch_id)
  		batchSubject = MgBatchSubject.where(:mg_school_id => session[:current_user_school_id],:mg_batch_id =>batch_id,:is_deleted => 0).pluck(:mg_subject_id)

		subjects = MgSubject.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id =>batchSubject).order(:subject_name).pluck(:subject_code,:id)
		return subjects
    end

    def get_batch_by_academic_year(academic_year)
		course = MgCourse.where(:mg_school_id => session[:current_user_school_id],:mg_time_table_id => academic_year,:is_deleted=> 0).pluck(:id)
      	batch_list = MgBatch.where(mg_school_id:session[:current_user_school_id],mg_course_id:course,is_deleted:0)
      	batch_ids = batch_list.map(&:id)if batch_list.present?
      return batch_ids
    end

    def get_course_batch_name_time_table(time_table_id)
		current_date =  Date.today
		@classes=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_time_table_id=>time_table_id).pluck(:id)
		@batch=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>@classes).joins(:mg_course).pluck("CONCAT(mg_courses.course_name,'-',mg_batches.name)","id")
		return @batch
	end
	
	#added on 12/09/19 by monalisa
        def get_students_without_archive_by_academic_year(academic_year, batch_id, school_id)

		current_academic_year = get_current_academic_year(session[:current_user_school_id]) 
		student_list = nil
		
		batch_student_ids = MgStudent.where(:is_deleted=>0, :mg_school_id=>school_id,:mg_batch_id=>batch_id).order(:first_name).pluck(:id)
		promotion_students_ids = MgStudentBatchHistory.where(from_academic_year:academic_year, from_section_id:batch_id,  mg_school_id: school_id, is_deleted: false).pluck(:mg_student_id)
		student_ids = (batch_student_ids + promotion_students_ids).uniq
		student_list = MgStudent.where(:id=>student_ids, :is_deleted=>0, :mg_school_id=>school_id)#.order(:first_name) 
		
    		return student_list
  	end	

   #added on 16/12/22 by avinash
  	def get_students_without_archive_by_academic_year_withbatch_and_withoutbatch(academic_year, batch_id, school_id)
			current_academic_year = get_current_academic_year(session[:current_user_school_id]) 
			student_list = nil
			if batch_id != "" && batch_id != nil
		  	batch_student_ids = MgStudent.where(:is_deleted=>0, :mg_school_id=>school_id,:mg_batch_id=>batch_id).order(:first_name).pluck(:id)
		  	promotion_students_ids = MgStudentBatchHistory.where(from_academic_year:academic_year, from_section_id:batch_id,  mg_school_id: school_id, is_deleted: false).pluck(:mg_student_id)
		  else
	        batch_student_ids = MgStudent.where(:is_deleted=>0, :mg_school_id=>school_id).order(:first_name).pluck(:id)
			    promotion_students_ids = MgStudentBatchHistory.where(from_academic_year:academic_year,  mg_school_id: school_id, is_deleted: false).pluck(:mg_student_id)
		  end
			student_ids = (batch_student_ids + promotion_students_ids).uniq
			student_list = MgStudent.where(:id=>student_ids, :is_deleted=>0, :mg_school_id=>school_id)#.order(:first_name) 
    	return student_list
  	end	


   	def get_students_by_academic_yearwithbatch_and_withoutbatch(academic_year, batch_id, school_id)
  		current_academic_year = get_current_academic_year(session[:current_user_school_id]) 
			student_list = nil
		  if batch_id != "" && batch_id != nil
				batch_student_ids = MgStudent.where(:is_deleted=>0, :mg_school_id=>school_id, :is_archive => 0,:mg_batch_id=>batch_id).order(:first_name).pluck(:id)
				promotion_students_ids = MgStudentBatchHistory.where(from_academic_year:academic_year, from_section_id:batch_id,  mg_school_id: school_id, is_deleted: false).pluck(:mg_student_id)
		    else
		       	batch_student_ids = MgStudent.where(:is_deleted=>0, :mg_school_id=>school_id, :is_archive => 0).order(:first_name).pluck(:id)
				promotion_students_ids = MgStudentBatchHistory.where(from_academic_year:academic_year,  mg_school_id: school_id, is_deleted: false).pluck(:mg_student_id)
	    end
			student_ids = (batch_student_ids + promotion_students_ids).uniq
			student_list = MgStudent.where(:id=>student_ids, :is_deleted=>0, :mg_school_id=>school_id, :is_archive => 0)#.order(:first_name) 
    	return student_list
  	end
   #added on 16/12/22 by avinash

    #methodStart-getStudentDetails added by Avinash
    def get_student_deatils(student,time_table_id,batch_id)
		  school = MgSchool.find(session[:current_user_school_id])
		  batch = MgBatch.find(batch_id)
		  course = MgCourse.find(batch.mg_course_id)
		  academic_year = MgTimeTable.find_by(id:time_table_id,is_deleted:0)
		  student_remark = MgStudentRemarksEntry.where(:is_deleted=>0,:mg_school_id=>school.id, :mg_student_id=>student.id, mg_time_table_id:time_table_id,mg_batch_id:batch_id)
		  house_details = MgHouseDetails.find_by(:id => student.mg_house_details_id, :mg_school_id => session[:current_user_school_id], :is_deleted => 0) if student.mg_house_details_id.present?
		  student_remarks = student_remark[0]
		  student_hash = Hash.new
		  student_hash["student_id"] = student.id
		  student_hash["mg_time_table_id"] = time_table_id
		  student_hash["academic_year_name"] = academic_year.name
		  student_hash["student_name"] = student.student_proper_name
		  get_admision_number = get_student_admission_number_for_previous_academic_year(params[:mg_time_table_id],params[:mg_batch_id],session[:current_user_school_id],student.id)
			if !["",[],nil].include?(get_admision_number)
				#student_hash["admission_number"] = get_admision_number.class_roll_number
			    if student.class_roll_number.present?
				 student_hash["admission_number"] = student.class_roll_number
			    else
				 student_hash["admission_number"] = get_admision_number.class_roll_number
			    end
			else
				student_hash["admission_number"] = student.class_roll_number
			end
			student_hash["course_name"] = course.course_name
			student_hash["course_code"] = course.code
			student_hash["batch_name"] = batch.name
			student_hash["course_batch_name"] = "#{course.course_name}-#{batch.name}"
			student_hash["class_roll_number"] = student.roll_number
			student_hash["roll_no"] = student.roll_number
			student_hash["photo"] = student.avatar.url(:medium, :timestamp=>false)
			student_hash["house_name"] = house_details ? house_details.Name : ""
			student_hash["father_name"] = student.father_name ? student.father_name : ""
			student_hash["mother_name"] = student.mother_name ? student.mother_name : ""
			if school.date_format.present?
			  student_hash["date_of_birth"] = student.date_of_birth ? student.date_of_birth.strftime(school.date_format) : ""
			else
			  student_hash["date_of_birth"] = student.date_of_birth ? student.date_of_birth : ""
			end
			if student_remarks.present?
			  student_hash["t1"] =  student_remarks.term_1 ? student_remarks.term_1 : ""
			 	student_hash["t2"] =  student_remarks.term_2 ? student_remarks.term_2 : ""
			 	student_hash["t3"] =  student_remarks.term_3 ? student_remarks.term_3 : ""
			 	student_hash["remarks"] = student_remarks.remarks ? student_remarks.remarks : ""
			 	student_hash["remarks1"] = student_remarks.remarks1 ? student_remarks.remarks1 : ""
			 	student_hash["remarks3"] = student_remarks.remarks3 ? student_remarks.remarks3 : ""
			 	student_hash["periodic_test_1"] = student_remarks.periodic_test_1 ? student_remarks.periodic_test_1 : ""
			 	student_hash["periodic_test_2"] = student_remarks.periodic_test_2 ? student_remarks.periodic_test_2 : ""
			 	student_hash["periodic_test_3"] = student_remarks.periodic_test_3 ? student_remarks.periodic_test_3 : ""
			 	student_hash["periodic_test_4"] = student_remarks.periodic_test_4 ? student_remarks.periodic_test_4 : ""
			 	student_hash["periodic_test_5"] = student_remarks.periodic_test_5 ? student_remarks.periodic_test_5 : ""
			 	student_hash["result"] = student_remarks.result ? student_remarks.result : ""
			else
				student_hash["t1"] =  ""
			 	student_hash["t2"] =  ""
			 	student_hash["t2"] =  ""
			 	student_hash["remarks"] =  ""
			 	student_hash["remarks1"] =  ""
			 	student_hash["remarks3"] =  ""
			 	student_hash["periodic_test_1"] =  ""
			 	student_hash["periodic_test_2"] =  ""
			 	student_hash["periodic_test_3"] =  ""
			 	student_hash["periodic_test_4"] = ""
			 	student_hash["periodic_test_5"] = ""
			 	student_hash["result"] = ""
			end
	   return student_hash 
	  end
  #methodEnd-getStudentDetails added by Avinash


	def get_employee_courses(employee_id, time_table_id)
			employee_courses = MgBatch.where(:mg_employee_id=>employee_id, :is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_course_id) if employee_id.present?

			MgCourse.where(:mg_school_id=>session[:current_user_school_id],:is_deleted=>0, :id => employee_courses, mg_time_table_id: time_table_id).pluck(:course_name, :id)
		end

def get_expense_access_user(user_id)

        @school_id = session[:current_user_school_id]
        current_user_id = user_id
        current_user_name = MgUser.where(:id=>current_user_id,:mg_school_id=> @school_id,:is_deleted=>0).last.user_name
        @admin = MgExpenseAccess.where(:mg_school_id=> @school_id,:is_deleted=>0,:is_applicable=>1,:user_name=>current_user_name,:user_type=>"Admin")
        @principal = MgExpenseAccess.where(:mg_school_id=> @school_id,:is_deleted=>0,:is_applicable=>1,:user_name=>current_user_name,:user_type=>"Principal")
        @chairman= MgExpenseAccess.where(:mg_school_id=> @school_id,:is_deleted=>0,:is_applicable=>1,:user_name=>current_user_name,:user_type=>"Chairman")
        if @admin.present?
           return  @admin.last.user_type
        elsif @principal.present?
           return @principal.last.user_type
        elsif @chairman.present?
           return @chairman.last.user_type
        else
           return "null"
       end
    end

    def get_schools
    	schools = MgSchool.where(:is_deleted => 0).pluck(:school_name,:id)
    end
    
     def get_students_ids_by_academic_year_fee(academic_year, batch_id, school_id)
		current_academic_year = get_current_academic_year(session[:current_user_school_id]) 
		student_list = nil
			batch_student_ids = MgStudent.where(:is_deleted=>0, :mg_school_id=>school_id, :is_archive => 0, :mg_batch_id=>batch_id).pluck(:id)
			promotion_students_ids = MgStudentBatchHistory.where(from_academic_year:academic_year, from_section_id:batch_id,  mg_school_id: school_id, is_deleted: false).pluck(:mg_student_id)
			student_ids = (batch_student_ids + promotion_students_ids).uniq
			student_list = MgStudent.where(:id=>student_ids, :is_deleted=>0, :mg_school_id=>school_id, :is_archive => 0).order(:first_name).pluck(:id, :first_name, :middle_name, :last_name, :admission_number, :mg_batch_id, :mg_student_catagory_id)
		
    	return student_list
  	end

	#added by praveen 
   	def call_greeting_message
	 	@application_greeting = MgGreetingMessage.where(mg_school_id:[session[:current_user_school_id],1],is_deleted:0).where("NOW() BETWEEN start_time and end_time")
	 	  @application_greeting_messages = @application_greeting.pluck(:message) if @application_greeting
	    if  @application_greeting_messages.present? 
	        path = render :file => "#{Rails.root}/public/greeting", :layout => false 
	        return  path 
	    end
      end

          def get_financial_year_months(start_date, end_date, billing_date, month_count)
                live_date = billing_date.strftime('%b-%Y')
                start_date = start_date
                end_date = end_date
                #between_months = (start_date..end_date).map{ |m| m.strftime('%Y%m') }.uniq.map{ |m| "#{Date::ABBR_MONTHNAMES[ Date.strptime(m, '%Y%m').mon]}-#{Date.strptime(m, '%Y%m').year}" }
                #between_months = start_date.to_date.upto(end_date.to_date) { |m| m.strftime('%Y%m') }.map{ |m| "#{Date::ABBR_MONTHNAMES[ Date.strptime(m, '%Y%m').mon]}-#{Date.strptime(m, '%Y%m').year}" }

                @months = start_date.to_date.upto(end_date.to_date).map{ |m| m.strftime('%Y%m') }.uniq.map{ |m| "#{Date::ABBR_MONTHNAMES[ Date.strptime(m, '%Y%m').mon]}-#{Date.strptime(m, '%Y%m').year}" }.each_slice(month_count).to_a

                #@months = between_months.each_slice(month_count).to_a
                @months.each do |pm|
                  if pm.include?(live_date)
                      pi = @months.find_index(pm)
                      @months.shift(pi) if pi != 0
                    i = pm.find_index(live_date)
                    if i !=0
                      pm.shift(i)
                    end
                  end
                end
                return @months
        end
        def get_course_batch_name_of_employee(user_id,time_table_id)
    	employee = MgEmployee.find_by(mg_school_id:session[:current_user_school_id],is_deleted:0,mg_user_id:user_id)
		batch_id = MgBatchSubject.where(mg_school_id:session[:current_user_school_id],is_deleted:0,mg_employee_id:employee.id).pluck(:mg_batch_id).uniq
		@classes=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_time_table_id=>time_table_id).pluck(:id)
		@batch=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>@classes,id:batch_id).joins(:mg_course).pluck("CONCAT(mg_courses.course_name,'-',mg_batches.name)","id")
    end

    def get_employee_student_data(user_id,user_type)
    	if user_type == "student"
    		user_data = MgStudent.find_by(mg_school_id:session[:current_user_school_id],is_deleted:0,is_archive:0,mg_user_id:user_id)
    	elsif user_type == "employee"
    		user_data = MgEmployee.find_by(mg_school_id:session[:current_user_school_id],is_deleted:0,is_archive:0,mg_user_id:user_id)
    	end
    	return user_data
    end    

      def course_batch_name_with_batch_id(batch_id)
        current_date = Date.today
        MgBatch.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>batch_id).joins(:mg_course).pluck("CONCAT(mg_courses.course_name,'-',mg_batches.name)","id")
      end
    
      def get_subject_name_of_employee(batch_id)
    	employee = get_employee_student_data(session[:user_id],session[:user_type])
		subject_id = MgBatchSubject.joins(:mg_subject).where(mg_school_id:session[:current_user_school_id],is_deleted:0,mg_employee_id:employee.id,mg_batch_id:batch_id).pluck('mg_subjects.subject_name','mg_subjects.id')
		return subject_id
    end

  	def get_students_without_archive_by_academic_year_with_sorting(academic_year, batch_id, school_id, sorting_value)

		current_academic_year = get_current_academic_year(session[:current_user_school_id]) 
		student_list = nil
		  batch_student_ids = MgStudent.where(:is_deleted=>0, :mg_school_id=>school_id, :mg_batch_id=>batch_id).order(:first_name).pluck(:id)
		promotion_students_ids = MgStudentBatchHistory.where(from_academic_year:academic_year, from_section_id:batch_id,  mg_school_id: school_id, is_deleted: false).pluck(:mg_student_id)
		student_ids = (batch_student_ids + promotion_students_ids).uniq
		
		  student_list = MgStudent.where(:id=>student_ids, :is_deleted=>0, :mg_school_id=>school_id).order(sorting_value) 
	   
		
    	return student_list
  	end


	 def get_students_with_archive_by_academic_year_with_sorting(academic_year, batch_id, school_id, sorting_value)
		current_academic_year = get_current_academic_year(session[:current_user_school_id]) 
		student_list = nil
		  batch_student_ids = MgStudent.where(:is_deleted=>0, :mg_school_id=>school_id, :mg_batch_id=>batch_id,is_archive:false).order(:first_name).pluck(:id)
		promotion_students_ids = MgStudentBatchHistory.where(from_academic_year:academic_year, from_section_id:batch_id,  mg_school_id: school_id, is_deleted: false).pluck(:mg_student_id)
		student_ids = (batch_student_ids + promotion_students_ids).uniq
		
		  student_list = MgStudent.where(:id=>student_ids, :is_deleted=>0, :mg_school_id=>school_id).order(sorting_value) 
	   
		
		return student_list
	end

        def get_class_and_section_by_stuid_and_academicyear(student_id, academic_year, school_id)
    	course_and_batch = MgStudentBatchHistory.where(from_academic_year:academic_year, :mg_student_id => student_id, mg_school_id: school_id, is_deleted: false).pluck(:from_class_id, :from_section_id)
    	course_and_batch = MgStudent.where(:id=>student_id, :is_deleted=>0, :mg_school_id=>school_id).pluck(:mg_course_id, :mg_batch_id) if !course_and_batch.present?
    	return course_and_batch
    end
def get_course_batch_id_of_employee(user_id,time_table_id)
	  	employee = MgEmployee.find_by(mg_school_id:session[:current_user_school_id],is_deleted:0,mg_user_id:user_id)
			batch_id = MgBatchSubject.where(mg_school_id:session[:current_user_school_id],is_deleted:0,mg_employee_id:employee.id).pluck(:mg_batch_id).uniq
			@classes=MgCourse.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_time_table_id=>time_table_id).pluck(:id)
			# binding.pry
			@batch=MgBatch.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_course_id=>@classes,id:batch_id).order(:name)#.joins(:mg_course).pluck("CONCAT(mg_courses.course_name,'-',mg_batches.name)","id")
    end

    def get_subject_name_code_of_employee(batch_id)
  		employee = get_employee_student_data(session[:user_id],session[:user_type])
			# subject_id = MgBatchSubject.joins(:mg_subject).where(mg_school_id:session[:current_user_school_id],is_deleted:0,mg_employee_id:employee.id,mg_batch_id:batch_id).pluck("CONCAT(mg_subjects.subject_name,'-',mg_subjects.subject_code)",'mg_subjects.id')
			subject_id = MgBatchSubject.joins(:mg_subject).where(mg_school_id:session[:current_user_school_id],is_deleted:0,mg_employee_id:employee.id,mg_batch_id:batch_id).pluck('mg_subjects.subject_name').uniq
			return subject_id
  	end
   
   def get_test_name(subject_id,batch_id)
		@test_check_data = []
	     if subject_id && batch_id.present?
	      mg_course_id = MgBatch.find_by(id:batch_id,is_deleted:0,mg_school_id:session[:current_user_school_id])
	      test_name = MgCreateQuestionPaper.where(mg_batch_id:batch_id,mg_subject_id:subject_id,is_deleted:0,mg_school_id:session[:current_user_school_id])
	      test_name += MgCreateQuestionPaper.where(mg_course_id:mg_course_id.mg_course_id,mg_subject_id:subject_id,is_deleted:0,mg_school_id:session[:current_user_school_id])
	     test_name.map{|y|
	      test_data = []
	      test_data << y.name_of_test 
	      test_data << y.id
	      @test_check_data << test_data}
	    end
	    return @test_check_data
  	end 
  	def get_question_type_for_online_assessment(question_paper_id)
      @set_ids = MgQuestionSet.where(:mg_create_question_paper_id => question_paper_id, :mg_school_id => session[:current_user_school_id], :is_deleted => 0).pluck(:id).uniq
      set_detail_ids= MgQuestionSetDetail.where(mg_question_set_id:@set_ids,:mg_school_id => session[:current_user_school_id], :is_deleted => 0).pluck(:mg_question_bank_id).uniq
      question_type_id=MgQuestionBank.where(id:set_detail_ids,:mg_school_id => session[:current_user_school_id], :is_deleted => 0).pluck(:mg_question_type_id).uniq
      question_bank_type = MgOnlineQuestionType.where(id:question_type_id ,:is_deleted => 0).pluck(:qtype_code,:id)
      # return question_bank_type
  	end

  	def get_question_lod_for_online_assessment(question_paper_id)
      @set_ids = MgQuestionSet.where(:mg_create_question_paper_id => question_paper_id, :mg_school_id => session[:current_user_school_id], :is_deleted => 0).pluck(:id).uniq
      set_detail_ids= MgQuestionSetDetail.where(mg_question_set_id:@set_ids,:mg_school_id => session[:current_user_school_id], :is_deleted => 0).pluck(:mg_question_bank_id).uniq
      question_lod=MgQuestionBank.where(id:set_detail_ids,:mg_school_id => session[:current_user_school_id], :is_deleted => 0).pluck(:mg_difficulty_level).uniq
      # binding.pry
      # return question_lod
  	end
    def get_syllabus_for_employee(user_id,current_year_batch_ids)
      employee = MgEmployee.find_by(mg_school_id:session[:current_user_school_id],is_deleted:0,mg_user_id:user_id)
      batch = current_year_batch_ids
      if ![""].include?(batch)
        sql = "select id from mg_syllabuses where is_deleted = 0 and mg_school_id = #{session[:current_user_school_id]} and mg_batch_id IN(#{current_year_batch_ids}) and (mg_subject_id, mg_batch_id) IN ( select mg_subject_id, mg_batch_id from mg_batch_subjects where mg_employee_id = #{employee.id} and is_deleted=0);"
        sql_array = ActiveRecord::Base.connection.execute(sql)
        mg_syllabus_id = sql_array.to_a
      end
      if ![nil,[]].include?(mg_syllabus_id)
        mg_syllabus_ids = "("+mg_syllabus_id.to_a.join(',')+")"
      end
      return mg_syllabus_ids
    end
    def get_student_admission_number_for_previous_academic_year(time_table_id,batch_id,school_id,mg_student_id)
			admission_number = MgArchiveStudent.find_by(mg_student_id:mg_student_id,:mg_time_table_id=>time_table_id,:is_deleted=>0,:mg_school_id=>school_id,mg_batch_id:batch_id)#.order(:first_name) 
  	end	

  	def get_previousStudentObj_for_previous_academic_year(time_table_id,batch_id,school_id)
			previousStudentObj = MgArchiveStudent.where(:mg_time_table_id=>time_table_id,:is_deleted=>0,:mg_school_id=>school_id,mg_batch_id:batch_id)#.order(:first_name) 
  	end
       def get_wing_name_by_time_table_id(mg_school_id,mg_time_table_id)
  		MgCourse.joins(:mg_wing).where(:is_deleted=>0,:mg_school_id=>mg_school_id,mg_time_table_id:mg_time_table_id).pluck(:wing_name,"mg_wings.id").uniq
       end
      def get_second_employee_id(courses_ids)
			employee = MgEmployee.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id], :mg_user_id=>session[:user_id])
			employee_batches = MgBatch.includes(:mg_course).where(:mg_course_id=>courses_ids, mg_employee_id:employee.id) if employee.present?
			employee_batches += MgBatch.includes(:mg_course).where(:mg_course_id=>courses_ids, :second_mg_employee_id=>employee.id) if employee.present?
			emp_course_batches = []
			if employee_batches.present?
				employee_batches.each do |emp_batch|
					batch_hash = {}
					batch_hash["course_batch"] = emp_batch.mg_course.course_name+"-"+ emp_batch.name
					batch_hash["batch_id"] = emp_batch.id
					emp_course_batches << batch_hash
				end
			end	
			return emp_course_batches
		end

		def get_second_employee_courses(employee_id, time_table_id)
			employee_courses = MgBatch.where(:mg_employee_id=>employee_id, :is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_course_id) if employee_id.present?
			employee_courses += MgBatch.where(:second_mg_employee_id=>employee_id, :is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).pluck(:mg_course_id) if employee_id.present?

			MgCourse.where(:mg_school_id=>session[:current_user_school_id],:is_deleted=>0, :id => employee_courses, mg_time_table_id: time_table_id).pluck(:course_name, :id)
		end

    def get_course_batches(courses_ids)
			batches = MgBatch.includes(:mg_course).where(:mg_course_id=>courses_ids,is_deleted:0) 
			course_batches = []
			if batches.present?
				batches.each do |batch|
					batch_hash = {}
					batch_hash["course_batch"] = batch.full_name
					batch_hash["batch_id"] = batch.id
					course_batches << batch_hash
				end
			end	
			return course_batches
		end

          def get_wing_name_by_timeTableId(mg_school_id,mg_time_table_id)
                MgCourse.joins(:mg_wing).where(:is_deleted=>0,:mg_school_id=>mg_school_id,mg_time_table_id:mg_time_table_id).pluck(:wing_name,"mg_wings.id").uniq
        end

	def get_all_employee_courses(employee_id, timetable_id)
			batch_ids = MgBatchSubject.where(mg_school_id:session[:current_user_school_id], is_deleted:0, mg_employee_id:employee_id).pluck(:mg_batch_id)
			course_ids = MgBatch.where(mg_school_id:session[:current_user_school_id], is_deleted:0, id:batch_ids).pluck(:mg_course_id)
			courses = MgCourse.where(id:course_ids, mg_school_id:session[:current_user_school_id], is_deleted:0, mg_time_table_id:timetable_id).pluck(:course_name,:id)
			return courses
		end

      def get_student_list_by_batch_for_library(batch_id)
                        MgStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_batch_id=>batch_id,:is_archive => 0).order(:first_name).pluck(:first_name,:id)#pluck("CONCAT(mg_students.first_name,' ',mg_students.middle_name,' ',mg_students.last_name)","id")   
                end



				def get_course
					user = MgUser.find_by(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id], :id=>session[:user_id])
					courses = view_context.get_course_by_academic_year(params[:mg_time_table_id])
					courses_ids = []
					courses.each do |v, i| courses_ids << i end
				 
					  courses_batches = view_context.get_course_batch_by_courses(courses_ids)
					if user.present? && user.user_type == "employee"
					  employee = MgEmployee.find_by(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id], :mg_user_id=>session[:user_id])
					  courses = view_context.get_employee_courses(employee.id, params[:mg_time_table_id]) if employee.present?
					end
					employee_courses_batches = view_context.get_employee_courses_and_batches(courses_ids)
					render :json=> {courses: courses, courses_batches: courses_batches, employee_courses_batches:employee_courses_batches}, :layout => false
				  end
				
				  
				  def get_wing_course
					courses = MgCourse.where(mg_wing_id:params[:mg_wing_id],mg_time_table_id:params[:mg_time_table_id],is_deleted:0,mg_school_id:session[:current_user_school_id]).pluck(:course_name,:id) if params[:mg_wing_id].present?
					render :json => {:courses => courses}
				  end
end	
