require File.join(File.dirname(__FILE__), "stopwords", "en")
require File.join(File.dirname(__FILE__), "stopwords", "ru")
require File.join(File.dirname(__FILE__), "stopwords", "fr")

module Simhash
  module Stopwords
    # TODO need to remove accent
    # TODO need to filter per language
    #ALL = RU + EN + FR
    ALL = FR
  end
end