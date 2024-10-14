class HomeController < ApplicationController
  def index
    @user = { name: 'Debendra', age: 28 }
  end
end
