require 'json'

module Loops
  class Node
    def initialize(node)
      node_array = node.split(',')
      if (node_array.length >= 2)
        @node_type = node_array[0].lstrip.rstrip
        @description = node_array[1].lstrip.rstrip
        if (node_array.length >= 3)
          @title = @notes = node_array[2].lstrip.rstrip
          if (node_array.length >= 4)
            @notes = node_array[3].lstrip.rstrip
            if (node_array.length >= 5)
              @view = node_array[4].lstrip.rstrip
            else
              @view = ""
            end
          else
            @notes = ""
            @view = ""
          end
        else
          @title = ""
          @notes = ""
          @view = ""
        end
        @name = @description
      else
        @node_type = "Error creating node."
        @description = "Error creating node."
        @title = "Error creating node."
        @notes = "Error creating node."
        @view = "Error creating node."
      end
    end
    attr_reader :node_type, :description, :title, :notes, :view, :name
    def node_id()
      (@description + "_" + @node_type).gsub(" ","_").downcase
    end
    def full_description()
      puts "  Type: #{@node_type}\n  Description: #{@description}\n  Title: #{@title}\n  Notes: #{@notes}\n  View:#{@view}\n\n"
    end
    def as_array()
      [@node_type, @description, @title, @notes, @view]
    end
    # def as_json()
    #   "{\"node_type\":\"#{@node_type}\",\"name\":\"#{@description}\",\"title\":\"#{@title}\",\"id\":\"#{self.node_id}\"}"
    #   # old version: "{\"node_type\":\"#{@node_type}\",\"name\":\"#{@description}\"}"
    # end
  end
end