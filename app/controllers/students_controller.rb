class StudentsController < ApplicationController

    layout "mindcom"
    def index
      @student = { academic_year: ["2022-2023","2023-2024"], class: ["I","II","III"] }
      end

      def show
        # @student = Student.find(params[:id])
      end
      

      def caste
      end

      def create_caste
      end
  
    def create
    end
end
