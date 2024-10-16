
class CategoryController < ApplicationController
    layout "mindcom"
  
    def index
        @castecategory=MgCasteCategory.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    end
  
    def getdata
      @castecategory = MgCasteCategory.where(is_deleted: 0, mg_school_id: session[:current_user_school_id]) 
      render json:@castecategory, status: :created
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



            @castecategory = MgCasteCategory.find(params[:id])
          boolVal = MgDependancyClass.casteCategory_dependancy("mg_caste_category_id", params[:id])
          
          if boolVal
            flash[:error] = "Cannot Delete this Wing is Having Dependencies"
          else
            @wings.update(is_deleted: 1)
            flash[:notice] = "Deleted Successfully"
          end
      
          render json: { message: "Academic year Created"}, status: :created


          
          end
          private
          def castecategory_new_params
            params.require(:category).permit(:name,:description,:is_deleted,:mg_school_id,:updated_by,:created_by)
          end
        
  end
  