



class CastesController < ApplicationController
    layout "mindcom"
  
    def index
        @caste=MgCaste.where(:is_deleted=>0,:mg_school_id=>session[:current_user_school_id])
    end
  
    def getdata
      @caste = MgCaste.where(is_deleted: 0, mg_school_id: session[:current_user_school_id]) 
      render json:@caste, status: :created
    end
  
    # POST /wings
    def create
        @caste=MgCaste.new(caste_params)
        @caste.mg_school_id = session[:current_user_school_id]
        @caste.is_deleted= 0
        @caste.created_by= session[:user_id]
        @caste.updated_by= session[:user_id]
        if @caste.save
          render json: { message: "Academic year Created"}, status: :created
        end
        # if @caste.save
        #  flash[:notice]="Sucessfully Created"
        # else 
        #  flash[:error]="Data not created sucessfully.Error occured, Please check duplicate name"
        # end
        # render json: { message: "Academic year Created"}, status: :created
        end
  
       # PATCH/PUT /academic_years/:id
          def update
            # binding.pry
            @caste = MgCaste.find(params[:id])
            if @caste.update(caste_params)
              render json: { message: "Caste Updated"}, status: :created
            end
          end
          # DELETE /academic_years/:id
          def destroy
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
          private
          def caste_params
            params.require(:castes).permit(:name,:description,:is_deleted,:mg_school_id,:updated_by,:created_by)
          end
        
  end
  