module CbscExaminationsHelper

	def get_exam_type_by_course_and_batch(batch_id,course_id)
		MgCbscExamTypeAssociation.where(:mg_school_id=>session[:current_user_school_id],:is_deleted=>0, :mg_batch_id=>batch_id, :mg_course_id=>course_id).pluck(:mg_cbsc_exam_type_id)
	end

	def get_scholastic_particulars_by_course_and_batch(batch_id,course_id)
		MgCbscSchoParticularClassAssoc.where(:mg_school_id=>session[:current_user_school_id],:is_deleted=>0, :mg_batch_id=>batch_id).pluck(:mg_scholastic_exam_particular_id)
	end

	def get_co_scholastic_particulars_by_course_and_batch(batch_id,course_id)
    co_paticular_ids = MgCbscCoSchoParticularClassAssoc.where(:mg_school_id=>session[:current_user_school_id],:is_deleted=>0, :mg_batch_id=>batch_id).pluck(:mg_co_scholastic_exam_particular_id)
		MgCbscCoScholasticExamComponents.where(:mg_school_id=>session[:current_user_school_id],:is_deleted=>0,id:co_paticular_ids).pluck(:id)
	end

	def get_exam_component_by_particuler(particular)
		#MgScholasticExamComponent.where(:is_deleted => 0,:mg_school_id=>session[:current_user_school_id],:mg_scholastic_exam_particular_id=>particular).pluck(:name, :id)
    componenets = MgScholasticExamComponent.where(:is_deleted => 0,:mg_school_id=>session[:current_user_school_id],:mg_scholastic_exam_particular_id=>particular)
		comp_details = componenets.map{|com| ["#{com.name}(#{com.weightage})",com.id]}
		return comp_details
	end

	def get_batch_subject_by_batch_id(batchID)
		MgBatchSubject.where(:is_extra_curricular=>0,:mg_school_id=>session[:current_user_school_id],:is_deleted=>0,:mg_batch_id=>batchID)
	end

	def get_exam_type_by_association(mg_cbsc_exam_type_id)
        MgCbscExamType.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:id=>mg_cbsc_exam_type_id).pluck(:exam_type_name,:id)
	end

	def get_scholastic_particular
  	     MgScholasticExamParticular.where(:mg_school_id=>session[:current_user_school_id],:is_deleted=>0).pluck(:name,:id)
	end

	def get_co_scholastic_exam_components
		MgCbscCoScholasticExamComponents.where(:mg_school_id=>session[:current_user_school_id],:is_deleted=>0).pluck(:name, :id)
	end

	def get_co_scholastic_exam_particular_by_component(component_id)
		 MgCbscCoScholasticExamParticular.where(:mg_school_id=>session[:current_user_school_id],:is_deleted=>0, :mg_cbsc_co_scholastic_exam_component_id=>component_id).pluck(:name, :id)
	end

	def get_batch_subject_by_batch_id_for_take_sub_id(batch)
		 MgBatchSubject.where(:is_extra_curricular=>0,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_batch_id=>batch).pluck(:mg_subject_id)
	end

	def get_subject_name(batch)
		MgSubject.joins(:mg_batch_subjects).where(:mg_batch_subjects => {:mg_batch_id=>batch},:is_deleted=>0,:mg_school_id=>session[:current_user_school_id]).order(:subject_name).pluck(:subject_name,:id)
	end

	def get_student_by_batch(mg_batch_id, sorting_value)
	   MgStudent.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:mg_batch_id=>mg_batch_id,:is_archive => 0).order(sorting_value)
	end

	def get_student_by_batch_for_taking_name(batchID)
		MgStudent.where(:mg_batch_id=>batchID,:is_deleted=>0,:mg_school_id=>session[:current_user_school_id],:is_archive => 0)
	end

	def get_subject_weightage_maxmarks(batch_id, course_id, subject_id, scholastic_component, exam_type_id, scholastic_particular)
		MgCbscExamSchedule.find_by(:is_deleted=>0, :mg_batch_id=>batch_id, :mg_course_id =>course_id, :mg_school_id=>session[:current_user_school_id], :mg_cbsc_exam_type_id => exam_type_id, :mg_scholastic_exam_particular_id =>scholastic_particular, :mg_scholastic_exam_component_id =>scholastic_component, :mg_subject_id => subject_id)
	end

	def get_subject(subject)
		MgSubject.where(:id => subject).pluck(:subject_name,:id)
	end

end
