class LoopsController < ApplicationController
  def index
    @current_login = Login.new
    @current_login.user = "Original user"
    @current_login.key = "Original key"
    # session[:tucked_login] = @current_login
  end
  def nodes
    aString = "Node params: "
    params.each do |p| 
      aString = aString + "param #{p}\n"
    end
    
    flash[:message2] = "The params are: " + aString
    @current_login = params[:login]
    
    if params[:commit].eql?("Connections")
      redirect_to :action => "connections"
    end
  end
  def connections
    aString = "Connections params: "
    params.each do |p| 
      aString = aString + "param #{p}\n"
    end
    
    flash[:message2] = "Connections params are: " + aString
    @current_login = params[:login]  
  end
end
