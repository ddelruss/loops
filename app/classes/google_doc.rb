require "rubygems"
require "bundler/setup"

require "google_drive"
require "highline"

module Loops
  class Google_Doc
    def initialize(doc_session, key)
      @key = key
      @doc_session = doc_session
    end
    attr_reader :doc_session
    
    def worksheet(index=0)
      @doc_session.spreadsheet_by_key(@key).worksheets[index]
    end
  end
end