module Loops
  class Link
    def initialize(link)
      link_array = link.split(',')
      if (link_array.length >= 2)
        @source = link_array[0].lstrip.rstrip
        @target = link_array[1].lstrip.rstrip
        if (link_array.length >= 3)
          @label = link_array[2].lstrip.rstrip
        else
          @label = ""
        end
      else
        @source = "Error creating link."
        @target = "Error creating link."
        @label = "Error creating link."
      end
    end
    attr_reader :source, :target, :label
    # def full_description()
    #   puts "  Type: #{@node_type}\n  Description: #{@description}\n  Notes: #{@notes}\n  Tags:#{@tags.join(", ")}\n\n"
    # end
    def self.csv_title() 
      "Source,Target,Label"
    end
    def csv_data()
      "#{@source},#{@target},#{@label}"
    end
    def as_array()
      [@source, @target, @label]
    end
    def as_json()
      "{\"source\":\"#{@source}\",\"target\":\"#{@target}\",\"label\":\"#{@label}\"}"
    end
  end
end