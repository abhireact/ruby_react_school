
class CategoryController < ApplicationController
    layout "mindcom"

  #CRUD Operations for category 
    def castecategory
        @castecategory=MgCasteCategory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        respond_to do |format|
            format.html # renders the default index.html.erb
            format.json do
              if params[:api_request].present?
                render json: @castecategory, status: :created
              else
                render json: { error: "API request parameter missing" }, status: :bad_request
              end
            end
          end
    end

    def castecategory_new
      @action = 'new'
      @castecategory = MgCasteCategory.new
    end

    def castecategory_edit
      @castecategory = MgCasteCategory.find(params[:id])
      @id = params[:id]
    end

    def castecategory_show
      @castecategory = MgCasteCategory.find(params[:id])
      @id = params[:id]
    end
  
    def castecategory_create
        @castecategory=MgCasteCategory.new(castecategory_new_params)
        @castecategory.mg_school_id = session[:current_user_school_id]
        @castecategory.is_deleted= 0
        @castecategory.created_by= session[:user_id]
        @castecategory.updated_by= session[:user_id]
        if @castecategory.save
          render json: { message: "Academic year Created"}, status: :created
        end
    end
  
    def castecategory_update
            # binding.pry
            @castecategory = MgCasteCategory.find(params[:id])
            if @castecategory.update(castecategory_new_params)
              render json: { message: "Caste Updated"}, status: :created
            end
    end

    def castecategory_delete

            @castecategory=MgCasteCategory.find(params[:id])
              # res = view_context.find_dependency("mg_caste_id",params[:id])
       
           boolVal = MgDependancyClass.caste_dependancy("mg_caste_category_id",params[:id])
           if boolVal == true
             flash[:error]  = "Cannot Delete this Caste is Having Dependencies"
           else
              @castecategory.update(:is_deleted=>1)
               flash[:notice] = "Deleted Successfully"
            end
        
            render json: { message: "Category Deleted Successfully" }, status: :ok
    end

  #CRUD Operations for caste 

      def caste
        @caste=MgCaste.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
        respond_to do |format|
            format.html # renders the default index.html.erb
            format.json do
              if params[:api_request].present?
                render json: @caste, status: :created
              else
                render json: { error: "API request parameter missing" }, status: :bad_request
              end
            end
          end
      end

      def caste_new
        @action = 'new'
        @caste = MgCaste.new
      end

      def caste_edit
        @action = 'edit'
        @caste = MgCaste.find(params[:id])
        @id = params[:id]
      end

      def create
        @caste=MgCaste.new(caste_params)
        @caste.mg_school_id = session[:current_user_school_id]
        @caste.is_deleted= 0
        @caste.created_by= session[:user_id]
        @caste.updated_by= session[:user_id]
        if @caste.save
          render json: { message: "Academic year Created"}, status: :created
        end
      end

      def caste_show
        @caste = MgCaste.find(params[:id])
        render json: @caste
        rescue ActiveRecord::RecordNotFound
        render json: { error: "Caste not found" }, status: :not_found
      end

      def caste_update
        @caste = MgCaste.find(params[:id])
        if @caste.update(caste_params)
          render json: { message: "Caste Updated"}, status: :created
        end
      end

      def caste_delete
        @caste=MgCaste.find(params[:id])
          # res = view_context.find_dependency("mg_caste_id",params[:id])

           boolVal = MgDependancyClass.caste_dependancy("mg_caste_id",params[:id])
         if boolVal == true
        flash[:error]  = "Cannot Delete this Caste is Having Dependencies"
         else
          @caste.update(:is_deleted=>1)
          flash[:notice] = "Deleted Successfully"
           end

            render json: { message: "Academic year Created"}, status: :created
      end 


  #CRUD Operations for Sport 
      def sport
        @sports = MgSport.where(is_deleted: false, mg_school_id: session[:current_user_school_id])
        respond_to do |format|
            format.html # renders the default index.html.erb
            format.json do
              if params[:api_request].present?
                render json: @sports, status: :created
              else
                render json: { error: "API request parameter missing" }, status: :bad_request
              end
            end
          end
      end

      def sport_new
        @sports = MgSport.new
        @action = "new"
      end

      def sport_edit
        @sports = MgSport.find(params[:id])
        @action = "edit"
        @id = params[:id]
      end

      def sport_create
        @sports=MgSport.new(sport_params)
        @sports.mg_school_id = session[:current_user_school_id]
        @sports.is_deleted= 0
        @sports.created_by= session[:user_id]
        @sports.updated_by= session[:user_id]
        if @sports.save
          render json: { message: "Sports Created"}, status: :created
        end

      end


      def sport_update
        @sports = MgSport.find(params[:id])
        if @sports.update(sport_params)
          render json: { message: "Sports Updated"}, status: :created
        end
      end


      def sport_delete

                @sports=MgSport.find(params[:id])
          
              boolVal = MgDependancyClass.student_sports_dependancy("mg_sport_id",params[:id])
              if boolVal == true
                flash[:error]  = "Cannot Delete this Sports is Having Dependencies"
              else
                  @sports.update(:is_deleted=>1)
                  flash[:notice] = "Deleted Successfully"
                end
            
              render json: { message: "Sports "}, status: :created  
      end


 #CRUD Operations for Student Hobbies 

    def student_hobbies
        @hobby = MgHobby.where(is_deleted: false, mg_school_id: session[:current_user_school_id])
        respond_to do |format|
            format.html # renders the default index.html.erb
            format.json do
              if params[:api_request].present?
                render json: @hobby, status: :created
              else
                render json: { error: "API request parameter missing" }, status: :bad_request
              end
            end
          end
    end

    def student_hobbies_new
      @stud_hobby = MgHobby.new
      @action = 'new'
    end

    def student_hobbies_edit
      @stud_hobby = MgHobby.find(params[:id])
      @id = params[:id]
      @action = "edit"
    end

    def student_hobbies_create
        @hobby=MgHobby.new(stud_hobby_params)
        @hobby.mg_school_id = session[:current_user_school_id]
        @hobby.is_deleted= 0
        @hobby.created_by= session[:user_id]
        @hobby.updated_by= session[:user_id]
        if @hobby.save
          render json: { message: "Academic year Created"}, status: :created
        end

    end
  
    def student_hobbies_update
            # binding.pry
            @stud_hobby = MgHobby.find(params[:id])
            if @stud_hobby.update(stud_hobby_params)
              render json: { message: "Hobby updated successfully!"}, status: :created
            end
    end
    
    def student_hobbies_delete

            @hobby=MgHobby.find(params[:id])
              # res = view_context.find_dependency("mg_caste_id",params[:id])
       
           boolVal = MgDependancyClass.student_hobby_dependancy("mg_hobby_id",params[:id])
           if boolVal == true
             flash[:error]  = "Cannot Delete this Caste is Having Dependencies"
           else
              @hobby.update(:is_deleted=>1)
               flash[:notice] = "Deleted Successfully"
            end
        
           render json: { message: "Academic year Created"}, status: :created  
    end

 #CRUD Operations for House Details
    def house_details
        @house_details = MgHouseDetails.where(is_deleted: false, mg_school_id: session[:current_user_school_id])
        respond_to do |format|
            format.html # renders the default index.html.erb
            format.json do
              if params[:api_request].present?
                render json: @house_details, status: :created
              else
                render json: { error: "API request parameter missing" }, status: :bad_request
              end
            end
          end
    end

    def house_details_new
      @action = 'new'
    end

    def house_details_edit
      @house_details = MgHouseDetails.find(params[:id])
    end

    def house_details_create
      @house_details=MgHouseDetails.new(house_details_params)
      @house_details.mg_school_id = session[:current_user_school_id]
      @house_details.is_deleted= 0
      @house_details.created_by= session[:user_id]
      @house_details.updated_by= session[:user_id]
      if @house_details.save
        render json: { message: "Academic year Created"}, status: :created
      end

    end

    def house_details_update
      # binding.pry
      @house_details = MgHouseDetails.find(params[:id])
      if @house_details.update(house_details_params)
        render json: { message: "House Name Updated"}, status: :created
      end
    end


    def house_details_delete

      @house_details = MgHouseDetails.find(params[:id])
      @house_details.update(is_deleted: true)
      
        render json: { message: "Academic year Created"}, status: :created  
    end

#CRUD Operations for Extra Curricular 
      def extra_curricular_index
        @extra_curricular = MgExtraCurricular.where(is_deleted: false, mg_school_id: session[:current_user_school_id])
        respond_to do |format|
          format.html # renders the default index.html.erb
          format.json do
            if params[:api_request].present?
              render json: @extra_curricular, status: :created
            else
              render json: { error: "API request parameter missing" }, status: :bad_request
            end
          end
        end
      end

      def extra_curricular_new
        @extra_curricular = MgExtraCurricular.new
        @action = "new"
      end

      def extra_curricular_edit
        @extra_curricular = MgExtraCurricular.find(params[:id])
        @action = "edit"
        @id = params[:id]
      end

      
      def extra_curricular_create
        @extra_curricular = MgExtraCurricular.new(extra_curricular_params)
        @extra_curricular.mg_school_id = session[:current_user_school_id]
        @extra_curricular.is_deleted= 0
        @extra_curricular.created_by= session[:user_id]
        @extra_curricular.updated_by= session[:user_id]
        if @extra_curricular.save
          render json: { message: "Academic year Created"}, status: :created
        end
      end

      def extra_curricular_update
        @extra_curricular = MgExtraCurricular.find(params[:id])
        if @extra_curricular.update(extra_curricular_params)
          flash[:notice] = "Extra Curricular updated successfully!"
        else
          flash[:error] = "Error updating extra-curricular activity"
        end
        render json: { message: "Extra Curricular updated successfully"}, status: :created
        
      end


      def extra_curricular_delete
        @extra_curricular=MgExtraCurricular.find(params[:id])
                
        boolVal = MgDependancyClass.student_extra_curricular_dependancy("mg_extra_curricular_id",params[:id])
        if boolVal == true
        flash[:error] = "Cannot delete, this extra-curricular activity has dependencies"
        else
            @extra_curricular.update(:is_deleted=>1)
            flash[:notice] = "Deleted Successfully"
          end

        render json: { message: "Deleted Successfully "}, status: :ok  


      end


          private
          def castecategory_new_params
            params.require(:category).permit(:name,:description,:is_deleted,:mg_school_id,:updated_by,:created_by)
          end

          def caste_params
            params.require(:caste).permit(:name,:description,:is_deleted,:mg_school_id,:updated_by,:created_by)
          end

          def sport_params
            params.require(:sports).permit(:name,:description,:is_deleted,:mg_school_id,:updated_by,:created_by)
          end

          def stud_hobby_params
            params.require(:student_hobbies).permit(:name,:description,:is_deleted,:mg_school_id,:updated_by,:created_by)
          end

          def house_details_params
            params.require(:house).permit(:Name,:Description,:is_deleted,:mg_school_id,:updated_by,:created_by)
          end


          def extra_curricular_params
            params.require(:mg_extra_curricular).permit(:name,:description,:is_deleted,:mg_school_id,:updated_by,:created_by)
          end
  end
  