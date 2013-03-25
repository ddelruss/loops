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

    process_google_doc(params[@current_login])
    flash[:message1] = "Node dataset: " + @node_dataset
    
    if params[:commit].eql?("Connections")
      render :action => "connections"
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
  
  def process_google_doc(login_hash)
    @nodes = [["Person", "Damien", "A note", "some tags"],["Person", "Grant", "", ""],["Person", "Kelly", "", ""]]
    @links = []
    @node_dataset = "[";
    @nodes.each do |node|
      @node_dataset = @node_dataset + node.to_s + ","
    end
    @node_dataset.chomp!(',')
    @node_dataset += "]"
  end
  
end
