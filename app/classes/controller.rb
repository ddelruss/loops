module Loops
  class Controller
    def initialize(document)
      @client_name = document.worksheet(0).title
      @company_name = document.worksheet(1).title
      @nodes = []
      @links = []
      @reports_to = "Reports To"
      @on_project = "On Project"
      @company_person = "Company Person"
      
      #seed data with two organizations
      @nodes = @nodes + [Node.new("Organization,#{@client_name}"), Node.new("ThoughtWorks,#{@company_name}")]
      
      # these are proprietary, that is, you have to know the format
      # first worksheet is clients with format Name, Title, View of Thoughtworks, Reports To, and Notes
      # row 1 is the heading
      ws = document.worksheet(0)
      for row in 2..ws.num_rows  
        # p ws[row, 1]
        # node expects node type, name, title, notes, view
        @nodes = @nodes + [Node.new("Client Person,#{ws[row, 1]},#{ws[row, 2]},#{ws[row, 5]},#{ws[row, 3]}")]
        @links = @links + [Link.new("#{@client_name}, #{ws[row, 1]},Employee")]
      end      
      
      # second worksheet is source organization with format Name (that's it)
      ws = document.worksheet(1)
      for row in 2..ws.num_rows
        @nodes = @nodes + [Node.new("#{@company_person},#{ws[row, 1]},#{ws[row, 2]}")]
        @links = @links + [Link.new("#{@company_name}, #{ws[row, 1]},Employee")]
      end      
      # third worksheet is links from anyone to anyone
      ws = document.worksheet(2)
      for row in 2..ws.num_rows
        @links = @links + [Link.new("#{ws[row, 1]}, #{ws[row, 2]},#{ws[row, 3]}")]
      end      
      # back to the first worksheet for hierarchy
      ws = document.worksheet(0)
      for row in 2..ws.num_rows
        if ws[row,4].length > 0 && !(ws[row, 1] == ws[row, 4]) 
          @links = @links + [Link.new("#{ws[row, 1]}, #{ws[row, 4]},#{@reports_to}")]
        end
      end      
      # back to the second sheet for projects
      ws = document.worksheet(1)
      processed = []
      for row in 2..ws.num_rows
        project_name = ws[row, 3]
        if (!processed.include?(project_name))
          @nodes = @nodes + [Node.new("Project,#{project_name}")]
          processed.push(project_name)
        end
        @links = @links + [Link.new("#{ws[row, 1]},#{project_name},#{@on_project}")]  
      end      
    end
    attr_reader :nodes, :links
    def node_count()
      @nodes.length
    end
    def link_count()
      @links.length
    end
    def d3_graph_json
      output = "{\"nodes\":["
      @nodes.each {|node|
        modified_json = node.to_json #+ ",\"playcount\":#{connections_count(node.description)}}"
        output = output + modified_json + ","
      }
      output = output.chop + "],\"links\":["
      output = write_json_links(output, @nodes)
      output = output.chop + "]}"
    end

    def d3_graph_json_clients_only
      filtered_nodes = []
      @nodes.each {|node|
        if node.node_type.include? "Client"
          filtered_nodes = filtered_nodes + [node]
        end
      }
      output = "{\"nodes\":["      
      filtered_nodes.each {|node|
        modified_json = node.to_json.chop + ",\"reports\":#{reports_to_count(node.description)},\"direct_reports\":#{direct_reports_to_count(node.description)},\"bosses\":#{bosses_count(node.description)}}"
        output = output + modified_json + ","
        filtered_nodes = filtered_nodes + [node]
      }
      
      output = output.chop + "],\"links\":["
      output = write_json_links(output, filtered_nodes)
      output = output.chop + "]}"
    end

    def d3_graph_json_people_no_organizations
      filtered_nodes = []
      output = "{\"nodes\":["      
      @nodes.each {|node|
        if node.node_type.include? "Person"
          modified_json = node.to_json.chop + ",\"reports\":#{reports_to_count(node.description)},\"connections\":#{connections_count(node.description, @reports_to)},\"bosses\":#{bosses_count(node.description)}}"
          output = output + modified_json + ","
          filtered_nodes = filtered_nodes + [node]
        end
      }
      output = output.chop + "],\"links\":["
      output = write_json_links(output, filtered_nodes, @reports_to)
      output = output.chop + "]}"
    end

    def d3_graph_json_projects
      filtered_nodes = []
      output = "{\"nodes\":["      
      @nodes.each {|node|
        if ((node.node_type.include? "Project") || (node.node_type.include? @company_person))
          modified_json = node.to_json
          output = output + modified_json + ","
          filtered_nodes = filtered_nodes + [node]
        end
      }
      output = output.chop + "],\"links\":["
      output = write_json_links(output, filtered_nodes)
      output = output.chop + "]}"
    end

    def write_json_links(output, nodes, exclude="nothing to exclude")
      @links.each {|link|
        if !(link.label.include? exclude)
          target_node = node_with_description(nodes, link.source)
          source_node = node_with_description(nodes, link.target)
          if target_node && source_node
            # output = output + "{\"source\":\"#{source_node.node_id}\",\"target\":\"#{target_node.node_id}\",\"label\":\"#{link.label}\"},"
            # if you want indexes...   
            output = output + "{\"source\":#{nodes.index(source_node)},\"target\":#{nodes.index(target_node)},\"label\":\"#{link.label}\"},"
          end
        end
      }
      output
    end
    
    def node_with_description(nodes, description)
      nodes.each {|node|
        if node.description.eql?(description) 
          return node
        end
      }
      nil
    end

    def bosses_count(description)
      @visited_nodes = []
      count = 0
      @links.each {|link|
        if link.source == description && link.label == @reports_to && !@visited_nodes.index(link.target)
          count += 1 + bosses_count(link.target)
          @visited_nodes = @visited_nodes + [link.target]
        end
      }
      count
    end
    
    def reports_to_count(description)
      @visited_nodes = []
      count = 0
      @links.each {|link|
        if link.target == description && link.label == @reports_to && !@visited_nodes.index(link.source)
          count += 1 + reports_to_count(link.source)
          @visited_nodes = @visited_nodes + [link.source]
        end
      }
      count
    end
    
    def direct_reports_to_count(description)
      @visited_nodes = []
      count = 0
      @links.each {|link|
        if link.target == description && link.label == @reports_to && !@visited_nodes.index(link.source)
          count += 1
          @visited_nodes = @visited_nodes + [link.source]
        end
      }
      count
    end

    def connections_count(description, excluding="nothing to exclude")
      count = 0
      @links.each {|link|
        if !link.label.include? excluding
          if link.target == description || link.source == description
            count += 1
          end
        end
      }
      count
      
    end
    
    
    # def write_csv(filename)
    #   file = File.new(filename, "w")
    #   file.write(Node.csv_title + "\n")
    #   @nodes.each {|node|
    #     file.write(node.csv_data + "\n")
    #   }
    # end
    # def write_d3_node_summary(destination_filename, template_filename, d3_select_filename) 
    #   template = File.new(template_filename, "r")
    #   file = File.new(destination_filename, "w")
    #   while (line = template.gets)
    #     if (line.eql?("#custom_code_here\n"))
    #       file.write("var dataset = [];\n")
    #       @nodes.each {|node|
    #         file.write("dataset.push(#{node.as_array.inspect});\n")            
    #       }
    #       write_file_in_file(d3_select_filename, file)
    #     else
    #       file.write(line)
    #     end
    #   end
    #   template.close
    #   file.close
    # end
    # def write_file_in_file(input, output)
    #   file = File.new(input, "r")
    #   while (line = file.gets)
    #     output.write(line)
    #   end
    #   file.close
    # end
    
    # def write_d3_graph_json(filename)
    #   file = File.new(filename, "w")
    #   file.write(d3_graph_json)
    # end
    # def write_people_colored_by_organization_graph_json(filename)
    #   file = File.new(filename, "w")
    #   filtered_nodes = []
    #   output = "{\"nodes\":[\n"
    #   @nodes.each {|node|
    #     if node.node_type.include? "Person"
    #       modified_json = node.to_json.chop + ",\"playcount\":#{connections_count(node.description) - 1}}"
    #       output = output + modified_json + "\n,"
    #       filtered_nodes = filtered_nodes + [node]
    #     end
    #   }
    #   output = output.chop + "],\"links\":[\n"
    #   output = write_json_links(output, filtered_nodes)
    #   output = output.chop + "]}"
    #   file.write(output)      
    # end
    # def write_client_reporting_structure_graph_json(filename)
    #   file = File.new(filename, "w")
    #   filtered_nodes = []
    #   output = "{\"nodes\":[\n"
    #   @nodes.each {|node|
    #     if node.node_type.include? "Client"
    #       modified_json = node.to_json.chop + ",\"playcount\":#{reports_to_count(node.description)}}"
    #       output = output + modified_json + "\n,"
    #       filtered_nodes = filtered_nodes + [node]
    #     end
    #   }
    #   output = output.chop + "],\"links\":[\n"
    #   output = write_json_links(output, filtered_nodes)
    #   output = output.chop + "]}"
    #   file.write(output)            
    # end
  end
end











