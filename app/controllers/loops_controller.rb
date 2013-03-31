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

    process_google_doc params[:login]
    # flash[:message1] = "Node dataset: " + @node_dataset
    
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
    # 
    # flash[:message2] = "Connections params are: " + aString
    # @current_login = params[:login]  
  end
  
  def diagram1
    process_google_doc params[:login]
  end
  
  def process_google_doc(login_hash)
    @node_array = [["Person", "Damien", "A note", "some tags"],["Person", "Grant", "", ""],["Person", "Kelly", "", ""]]
    # @nodes = @node_array
    node1 = {:node_type => "Person",:name => "Damien",:id => "damien_person"}
    # node2 = Loops::Node.new(" Person , Kelly")
    # node3 = Loops::Node.new(" Person , Grant")
    # n_array = [node1, node2, node3]
    # @node_json = n_array.to_json
    @node_json = [node1].to_json
    @link_json = [].to_json
    
    
    # @node_hash = [{"node_type" => "Person","name" => "Damien","id" => "damien_person"},
    #           {"node_type" => "Person","name" => "Kelly","id" => "kelly_person"},
    #           {"node_type" => "Person","name" => "Grant","id" => "grant_person"},
    #           {"node_type" => "Organization","name" => "ThoughtWorks","id" => "thoughtworks_organization"},
    #           {"node_type" => "Organization","name" => "Client","id" => "client_organization"}]
    # @link_hash = [{"source" => "damien_person","target" => "thoughtworks_organization","label" => "Employee"},
    #               {"source" => "grant_person","target" => "thoughtworks_organization","label" => "Employee"},
    #               {"source" => "kelly_person","target" => "thoughtworks_organization","label" => "Employee"}]
    # flash[:message1] = "process google doc has input: " + login_hash.to_s
    # 
    # google_session = GoogleDrive.login(login_hash[:user], login_hash[:password])
    # flash[:message1] = flash[:message1] + "...session created..."
    # 
    # document = Loops::Google_Doc.new(google_session, "0AtOGnLq8Mf_ydGEtVFZMNDZtbHY3dHhWT3VxWjE4UFE")
    # flash[:message1] = flash[:message1] + "...document created..."
    # 
    # controller = Loops::Controller.new(document)
    # flash[:message1] = flash[:message1] + "...controller created..."    
    # @nodes = controller.nodes
    
    # @node_dataset = "[";
    # @nodes.each do |node|
    #   @node_dataset = @node_dataset + node.to_s + ","
    # end
    # @node_dataset.chomp!(',')
    # @node_dataset += "]"
    
    # @node_dataset = "[";
    #     @nodes.each do |node|
    #       @node_dataset = @node_dataset + node.to_s + ","
    #     end
    #     @node_dataset.chomp!(',')
    #     @node_dataset += "]"
    #     
    
    
    
  end
  
end
