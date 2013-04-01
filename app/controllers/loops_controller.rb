require 'json'

class LoopsController < ApplicationController
  def index
    @current_login = Login.new
  end
  def nodes
    aString = "Node params: "
    params.each do |p| 
      aString = aString + "param #{p}\n"
    end
    
    # flash[:message2] = "The params are: " + aString
    # @current_login = params[:login]

    flash[:message1] = "Start..."
    process_google_doc params[:login]
    @graph_json = @controller.d3_graph_json
    # flash[:message1] = flash[:message1] + "Graph JSON is: " + @graph_json.to_s
    
    if params[:commit].eql?("Connections")
      render :action => "connections"
    end
    if params[:commit].eql?("Diagram 1")
      render :action => "diagram1"
    end
  end
  
  def connections
    aString = "Connections params: "
    params.each do |p| 
      aString = aString + "param #{p}\n"
    end
  end
    
  def process_google_doc(login_hash)
    flash[:message1] = flash[:message1] + "Processing google doc..."    
    google_session = GoogleDrive.login(login_hash[:user], login_hash[:password])
    document = Loops::Google_Doc.new(google_session, login_hash[:key])
    # document = Loops::Google_Doc.new(google_session, "0AtOGnLq8Mf_ydGEtVFZMNDZtbHY3dHhWT3VxWjE4UFE")
    @controller = Loops::Controller.new(document)
    
  end
  
end
