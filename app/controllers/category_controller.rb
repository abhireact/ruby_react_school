
class CategoryController < ApplicationController
    layout "mindcom"
  
    def index
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
  
    # POST /wings
    def create
        @castecategory=MgCasteCategory.new(castecategory_new_params)
        @castecategory.mg_school_id = session[:current_user_school_id]
        @castecategory.is_deleted= 0
        @castecategory.created_by= session[:user_id]
        @castecategory.updated_by= session[:user_id]
        if @castecategory.save
          render json: { message: "Academic year Created"}, status: :created
        end
        end
  
       # PATCH/PUT /academic_years/:id
          def update
            # binding.pry
            @castecategory = MgCasteCategory.find(params[:id])
            if @castecategory.update(castecategory_new_params)
              render json: { message: "Caste Updated"}, status: :created
            end
          end


          # DELETE /academic_years/:id
          def destroy

            @castecategory=MgCasteCategory.find(params[:id])
              # res = view_context.find_dependency("mg_caste_id",params[:id])
       
           boolVal = MgDependancyClass.caste_dependancy("mg_caste_category_id",params[:id])
           if boolVal == true
             flash[:error]  = "Cannot Delete this Caste is Having Dependencies"
           else
              @castecategory.update(:is_deleted=>1)
               flash[:notice] = "Deleted Successfully"
           end
        
           render json: { message: "Academic year Created"}, status: :created


          
          end
          private
          def castecategory_new_params
            params.require(:category).permit(:name,:description,:is_deleted,:mg_school_id,:updated_by,:created_by)
          end
        
  end
  