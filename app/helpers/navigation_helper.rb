module NavigationHelper
    def ensure_navigation
    	
		userType = session[:user_type]
		if userType == "admin"
    	  	mineUrl = '/master_settings/'

    	elsif userType == "principal"
    	    mineUrl = '/dashboards/principal/'

    	elsif  userType == "guardian"
    		mineUrl = '/dashboards/guardian/'

    	elsif  userType == "employee"
    		mineUrl = '/dashboards/employee/'

    	elsif  userType == "student"
    		mineUrl = '/attendances/student/'
        elsif  userType == "cloudadmin"
            mineUrl = '/dashboards/cloud_admin'
    	end

        @navigation ||= [ { :title => 'Home', :url => mineUrl } ]
    end

    def navigation_add(title, url)
        ensure_navigation << { :title => title, :url => url }
    end

    def render_navigation
        render :partial => 'shared/navigation', :locals => { :nav => ensure_navigation }
    end
end