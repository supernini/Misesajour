module RssReader
  require 'sax-machine'
  require 'open-uri'

  class RSSEntry
    include SAXMachine

    element :title
    element :link

    element :"dc:creator", :as => :author
    element :author, :as => :author
    element :"content:encoded", :as => :content
    element :description
    element :enclosure, :as => :encloseimage, :value => :url, :with => {:type => "image/jpeg"}

    element :pubDate, :as => :published
    element :pubdate, :as => :published
    element :image, :as => :image
    element :"dc:date", :as => :published
    element :"dc:Date", :as => :published
    element :"dcterms:created", :as => :published


    element :"dcterms:modified", :as => :updated
    element :issued, :as => :published
    elements :category, :as => :categories

    element :guid

  end

  class RSS
    include SAXMachine
    element :title
    element :description
    element :link
    element :lastBuildDate
    element :language
    elements :item, :as => :entries, :class => RSSEntry

    attr_accessor :feed_url

    def self.able_to_parse?(xml) #:nodoc:
      (/\<rss|\<rdf/ =~ xml) && !(/feedburner/ =~ xml)
    end
  end

  class Item
    attr_reader :pubDate, :title, :link, :description, :guid, :image

    def initialize(entry)
      @pubDate = entry.published
      @title = entry.title
      @link = entry.link
      @description = entry.description
      @guid = entry.guid
      if entry.encloseimage
        @image = entry.encloseimage
      else
        @image = entry.image
      end

    end

  end

  class Reader
    attr_reader :title, :description, :lastBuildDate, :link, :language, :entries, :is_rss

    def initialize(filename)
      @is_rss = true
      @content = open(URI.escape(filename))
      @feed = RSS.parse(@content)
      if !@feed.title
        not_xml
        return
      end
      @title = @feed.title
      @description = @feed.description
      @lastBuildDate = @feed.lastBuildDate
      @link = @feed.link
      @language = @feed.language

      @entries = []
      @feed.entries.each do |entry|
        @entries << Item.new(entry)
      end
    end

    def not_xml
      @is_rss = false
    end
  end
end

#rss = RssReader::Reader.new('http://www.recettesdefamille.com/sitemap')
#rss = RssReader::Reader.new('http://rss.seriousarea.com/upd_link.php?site=asiangfsex&id=supernini')
#rss = RssReader::Reader.new('http://www.sextronix.com/webmasters/stream_gallery.php?type=rss_feed&galtype=&site=2&thumbsize=110x150&wmid=111532&nprogram=1')

#puts rss.title
#puts rss.is_rss
#puts rss.language

#rss.entries.each do |entry|
#  p entry
#end