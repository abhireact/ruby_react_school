class OtherParticularController < ApplicationController
    layout "mindcom"

    def index
        @current_academic_year = view_context.get_current_academic_year(session[:current_user_school_id])
        @current_academic_year_id = @current_academic_year.last
        @current_academic_year_id = params[:mg_time_table_id] if params[:mg_time_table_id].present?

        @co_scholastic = MgCbscCoScholasticExamComponents.where(:is_deleted => 0,:mg_school_id=>session[:current_user_school_id], mg_time_table_id: @current_academic_year_id)
        @classes = MgCourse.where(mg_school_id: session[:current_user_school_id], is_deleted: 0,
                                  mg_time_table_id: @current_academic_year_id).order(:id)
        @batches = MgBatch.find_by(mg_school_id: session[:current_user_school_id], is_deleted: 0)
    
        @exam_types = MgCbscExamType.where(is_deleted: false, mg_school_id: session[:current_user_school_id], mg_time_table_id: @current_academic_year_id)
        @classSection = view_context.get_class_section
        @academicYearsData= MgTimeTable.where(mg_school_id:session[:current_user_school_id],is_deleted:0)
        @examtypes_associations = MgCbscExamTypeAssociation.where(is_deleted: false, mg_school_id: session[:current_user_school_id]).order(:mg_course_id)
        @co_scholastics_component = MgCbscCoScholasticExamParticular.where(:is_deleted => 0,:mg_school_id=>session[:current_user_school_id])
        @particular_class_section=MgCbscCoSchoParticularClassAssoc.where(:is_deleted=>0, :mg_school_id=>session[:current_user_school_id]).order(:mg_co_scholastic_exam_particular_id)
        @react_data = {
          academic_year_data: @current_academic_year,
          examtype_data: @exam_types,
          classes: @classes,
          batches: @batches,
          class_section:@classSection,
          academicYearsData:@academicYearsData,
          exam_associationData:@examtypes_associations,
          other_particular: @co_scholastic,
          other_component:@co_scholastics_component,
          other_particular_class_section:@particular_class_section
          
        }
    
    end

    def create_component
    end 


    def co_scholastic_create
      @co_scholastics = MgCbscCoScholasticExamComponents.new(co_scholastics_params)
     
      if @co_scholastics.save
        begin
          # Extract the particulars and create them
          params[:particulars].each do |particular|
            @co_scholastic_particular = MgCbscCoScholasticExamParticular.new(
              mg_cbsc_co_scholastic_exam_component_id: @co_scholastics.id,
              name: particular[:name],
              description: particular[:description],
              scoring_type: particular[:scoring_type],
              created_by: session[:user_id],
              updated_by: session[:user_id],
              is_deleted: 0,
              mg_school_id: session[:current_user_school_id]
            )
     
            if @co_scholastic_particular.save
              # Handle selected class associations
              params[:selected_class]&.each do |selectedClass|
                course_batch_id = selectedClass.split("-")
                
                particular_association = MgCbscCoSchoParticularClassAssoc.new(
                  mg_course_id: course_batch_id[0],
                  mg_batch_id: course_batch_id[1],
                  mg_co_scholastic_exam_particular_id: @co_scholastics.id,
                  created_by: session[:user_id],
                  updated_by: session[:user_id],
                  is_deleted: 0,
                  mg_school_id: session[:current_user_school_id]
                )
                # binding.pry
     
                unless particular_association.save
                  raise "Error saving MgCbscCoSchoParticularClassAssoc: #{particular_association.errors.full_messages.join(', ')}"
                end
              end
            else
              raise "Error saving MgCbscCoScholasticExamParticular: #{@co_scholastic_particular.errors.full_messages.join(', ')}"
            end
          end
     
          # Return a success JSON response
          render json: { 
            message: "Other Particular and Components Created Successfully", 
            status: "success",
            data: @co_scholastics
          }, status: :created
     
        rescue => e
          # Handle errors and respond with the specific error message
          render json: { 
            message: "Error Occurred: #{e.message}", 
            status: "error" 
          }, status: :unprocessable_entity
        end
     
      else
        # If there's an error during save, return a failure JSON response with errors
        render json: { 
          message: "Error saving MgCbscCoScholasticExamComponents: #{@co_scholastics.errors.full_messages.join(', ')}", 
          status: "error" 
        }, status: :unprocessable_entity
      end
    end
    def co_scholastic_update
      @co_scholastics = MgCbscCoScholasticExamComponents.find(params[:id])
      
    
      if @co_scholastics.update(co_scholastics_params)
        begin
          # Handle deletion of associations
          @deleteClass = params[:delete_class]
          if @deleteClass.present?
            @deleteClass.each do |deleteClass|
              arr = deleteClass.split("-")
              course = MgCourse.find_by(is_deleted: 0, mg_school_id: session[:current_user_school_id], id: arr[0])
              batch = MgBatch.find_by(is_deleted: 0, mg_school_id: session[:current_user_school_id], mg_course_id: course.id, id: arr[1])
    
              @exam_association = MgCbscCoSchoParticularClassAssoc.find_by(
                mg_co_scholastic_exam_particular_id: @co_scholastics.id,
                is_deleted: 0,
                mg_school_id: session[:current_user_school_id],
                mg_course_id: course.id,
                mg_batch_id: batch.id
              )
    
              @exam_association.update(is_deleted: 1) if @exam_association.present?
            end
          end
    
          # Handle updating/adding new associations
          @updateClass = params[:selected_class]
          if @updateClass.present?
            @updateClass.each do |updateClass|
              arr = updateClass.split("-")
              course = MgCourse.find_by(is_deleted: 0, mg_school_id: session[:current_user_school_id], id: arr[0])
              batch = MgBatch.find_by(is_deleted: 0, mg_school_id: session[:current_user_school_id], mg_course_id: course.id, id: arr[1])
    
              @exam_association = MgCbscCoSchoParticularClassAssoc.find_by(
                mg_co_scholastic_exam_particular_id: @co_scholastics.id,
                is_deleted: 0,
                mg_school_id: session[:current_user_school_id],
                mg_course_id: course.id,
                mg_batch_id: batch.id
              )
    
              unless @exam_association.present?
                @exam_type_association = MgCbscCoSchoParticularClassAssoc.new(
                  mg_course_id: course.id,
                  mg_batch_id: batch.id,
                  mg_co_scholastic_exam_particular_id: @co_scholastics.id,
                  created_by: session[:user_id],
                  updated_by: session[:user_id],
                  is_deleted: 0,
                  mg_school_id: session[:current_user_school_id]
                )
                @exam_type_association.save
              end
            end
          end
    
          # Return success JSON response
          render json: {
            message: "Co-Scholastic updated successfully!",
            status: "success",
            data: @co_scholastics
          }, status: :ok
    
        rescue => e
          # Handle errors during update and return as JSON
          render json: {
            message: "Error occurred while updating associations: #{e.message}",
            status: "error"
          }, status: :unprocessable_entity
        end
      else
        # If the update fails, return a failure response with errors
        render json: {
          message: "Error updating Co-Scholastic: #{@co_scholastics.errors.full_messages.join(', ')}",
          status: "error"
        }, status: :unprocessable_entity
      end
    end
    
    def co_scholastics_params
      params.require(:mg_cbsc_co_scholastic_exam_components)
            .permit(:name, :description, :index, :mg_time_table_id)
            .merge(
              mg_school_id: session[:current_user_school_id],
              created_by: session[:user_id],
              updated_by: session[:user_id],
              is_deleted:0
            )
    end



    def co_scholastic_component_create
      @co_scholastics_component = MgCbscCoScholasticExamParticular.new(co_scholastics_component_params)
    
      if @co_scholastics_component.save
        render json: {
          status: 'success',
          message: 'Successfully Created',
          data: @co_scholastics_component.as_json
        }, status: :created
      else
        render json: {
          status: 'error',
          message: 'Error Occurred',
          errors: @co_scholastics_component.errors.full_messages
        }, status: :unprocessable_entity
      end
    end
    
    def co_scholastics_component_params
      params.require(:mg_cbsc_co_scholastic_exam_particular).permit(
        :mg_cbsc_co_scholastic_exam_component_id,
        :name,
        :description,
        :scoring_type
      ).tap do |component_params|
        component_params[:mg_school_id] = session[:current_user_school_id]
        component_params[:created_by] = session[:user_id]
        component_params[:updated_by] = session[:user_id]
        component_params[:is_deleted] = 0
      end
    end

    def co_scholastic_component_update
      @co_scholastics_particular = MgCbscCoScholasticExamParticular.find(params[:id])
      if @co_scholastics_particular.update(co_scholastics_component_params)
        render json: { message: "Other Exam Particular updated successfully!", 
                       particular: @co_scholastics_particular }, status: :ok
      else
        render json: { error: "Failed to update Other Exam Particular", 
                       details: @co_scholastics_particular.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
    def delete_particular
      @exam_type = MgCbscCoScholasticExamComponents.find(params[:id])
    
      boolVal = MgDependancyClass.coScholasticExamsType_dependancy("mg_cbsc_co_scholastic_exam_component_id", params[:id])
      
      if boolVal == true
        # Instead of flash[:error], render a JSON response with an error message
        render json: { success: false, message: "Cannot delete this particular item as it has dependencies" }, status: :unprocessable_entity
      else
        # Instead of updating with is_deleted and flash[:notice], directly render the success message
        @exam_type.update(is_deleted: 1)
        render json: { success: true, message: "Deleted successfully" }, status: :ok
      end
    end
    def delete_component
      @co_scholastics_particular = MgCbscCoScholasticExamParticular.find(params[:id])
    
      # Perform the update to mark the record as deleted
      if @co_scholastics_particular.update(is_deleted: 1)
        render json: { success: true, message: "Deleted successfully" }, status: :ok
      else
        render json: { success: false, message: "Failed to delete the record" }, status: :unprocessable_entity
      end
    end
    
    

  end
    

