require 'json'

class LoopsController < ApplicationController
  def index
    @current_login = Login.new
  end
  def nodes
    aString = "Node params: "
        
    process_google_doc params[:login]
    @graph_json = @controller.d3_graph_json
    @graph_json_clients = @controller.d3_graph_json_clients_only
    @graph_json_people = @controller.d3_graph_json_people_no_organizations
    @graph_json_projects = @controller.d3_graph_json_projects
              
    if params[:commit].eql?("Hierarchy")
      render :action => "hierarchy"
    end
    if params[:commit].eql?("Relationships")
      render :action => "people"
    end
    if params[:commit].eql?("Connections")
      render :action => "connections"
    end
    if params[:commit].eql?("Projects")
      render :action => "projects"
    end
  end
  
  def connections
  end
    
  def process_google_doc(login_hash)
    google_session = GoogleDrive.login(login_hash[:user], login_hash[:password])
    document = Loops::Google_Doc.new(google_session, login_hash[:key])
    # document = Loops::Google_Doc.new(google_session, "0AtOGnLq8Mf_ydGEtVFZMNDZtbHY3dHhWT3VxWjE4UFE")
    @controller = Loops::Controller.new(document)
    
  end
  
end
