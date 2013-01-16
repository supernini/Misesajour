class RssProvider < ActiveRecord::Base
  belongs_to :user
  has_many :rss_items
  has_many :rss_twitts
  has_many :rt_twitts, :dependent => :delete_all
  belongs_to :user_twitter
  attr_accessible :frequence, :last_run, :name, :run_count, :twitt_prefix, :twitt_suffix, :lastdownload, :failcount, :url, :guid, :is_rss, :priority, :user_twitter_id, :user_twitter

  validates :url, :presence => true, :uniqueness => {:scope => :user_id}, :format => URI::regexp(%w(http https))
  validates :name, :presence => true, :uniqueness => {:scope => :user_id}
  validates :frequence, :numericality => { :only_integer => true }
  validates :user_twitter_id, :presence => true
  validate :flux_exist?

  before_save :unset_failcount

  def unset_failcount
    self.failcount = 0
  end

  #check si le flux existe, dans le cas contraire ajouter une erreur au modele. Cette methode est appellé avant de sauvegarder le modele
  def flux_exist?
    begin
      raw_content = open URI.escape(self.url)
      return true
    rescue
      errors.add(:url, "Le fichier n'existe pas")
      return false
    end
  end

  # Lorsque le cron s'execute, cette methode check si le flux existe, et si l'entente retourner est correcte
  def self.remote_file_exists?(url)
    puts "Checking if file exist : #{URI.escape(url)}"
    require 'open-uri'
    require 'net/http'
    url = URI.parse(URI.escape(url))
    Net::HTTP.start(url.host, 80) do |http|
      puts "file exist : #{http.head(url.request_uri).code == "200"} (#{http.head(url.request_uri).code})"
      return (http.head(url.request_uri).code == "200" or http.head(url.request_uri).code == "301")
    end
  end

  #Si le flux a eté checker il y a plus que 30 minutes, le recharge et analyse si nous avons à faire a un flux XML ou un RSS. En fonction de l'un ou de l'autre ajoute les infos dans la DB
  def load_and_update
    # pas de refresh moins de 30 minutes
    return if self.lastdownload and self.lastdownload > Time.now.advance(:minutes => -30)

    if !self.valid? or !RssProvider.remote_file_exists? self.url
      self.update_attribute('failcount', self.failcount + 1)
      return false
    end
    self.run_count += 1
    require 'rubygems'
    #require 'simple-rss'
    require 'open-uri'
    require 'hpricot'
    require 'rss_reader'
    begin
      rss = RssReader::Reader.new(self.url)
    rescue

    end
    if rss.is_rss
      self.title = rss.title
      self.last_build_date = Time.now
      self.is_rss       = true
      rss.entries.each do |item|
        self.rss_items.where(:title => item.title).first_or_create do |rss_item|
          puts "*****"
          puts YAML::dump(rss_item)
          rss_item.link         = item.link
          rss_item.description  = ApplicationController.helpers.strip_tags(item.description)
          rss_item.pubdate      = item.pubDate
          rss_item.guid         = item.guid
          rss_item.image        = item.image
        end
      end
    else
      content = open(URI.escape(self.url))
      self.is_rss           = false
      self.last_build_date  = Time.now
      self.title = 'SITEMAP'
      doc = Hpricot(content)
      doc.search("//url").each do |item|
        loc = item.search("//loc").first.inner_html
        pub_date = item.search("//lastmod").first.inner_html if item.search("//lastmod").first
        priority = item.search("//priority").first.inner_html  if item.search("//priority").first

        self.rss_items.where(:link => loc).first_or_create do |rss_item|
          rss_item.link         = loc
          rss_item.pubdate      = pub_date
          rss_item.guid         = Digest::SHA1.hexdigest(loc)
          rss_item.priority     = priority
        end
      end
    end
    self.save
  end

  #Declenche le tweet, si la page utilise un micro-format, il tweet le title de la page, avec l'image en doc attaché
  def tweet_me
    puts self.user_twitter.username
    to_tweet = self.rss_items.order('twitt_count ASC, pubdate ASC').first
    if to_tweet and !self.is_rss and to_tweet.link and RssProvider.remote_file_exists?(to_tweet.link)
      puts "trying to download from : #{URI.escape(to_tweet.link)}"
      require 'rubygems'
      require 'simple-rss'
      require 'open-uri'
      require 'hpricot'
      doc = Hpricot(open(URI.escape(to_tweet.link)))
      to_tweet.title = doc.at("title").inner_html.strip
      to_tweet.image = doc.at('/html/head/meta[@property="og:image"]')['content'] if doc.at('/html/head/meta[@property="og:image"]')
      to_tweet.save

      puts YAML::dump(to_tweet.errors)
    end

    if to_tweet and to_tweet.link
      @client = Twitter::Client.new(
        :oauth_token => self.user_twitter.twitter_token,
        :oauth_token_secret => self.user_twitter.twitter_secret_token
      )
      to_tweet.twitt_count += 1
      to_tweet.save
      self.last_run = Time.now.to_i
      self.run_count += 1
      self.save

      short_url = Googl.shorten(to_tweet.link).short_url
      max_length = 136-self.twitt_prefix.length-self.twitt_suffix.length-short_url.length
      message =  "#{self.twitt_prefix} #{ApplicationController.helpers.truncate(to_tweet.title, :length => max_length)} #{short_url} #{self.twitt_suffix}"
      begin
        if to_tweet.image
          @client.update_with_media(message,
                                  open(URI.escape(to_tweet.image))
          )
        else
          @client.update(message)
        end
      rescue
      end
      [message, to_tweet.id]
    end
  end

  #Due au limitation commercial du produit, une fois par jour, cette methode créer les tweet a lancer (data vide just l'horaire), il randomize l'heure du lancement

  def self.daily_prepare
    RssProvider.all.each do |rss_provider|
      hour = 23
      sum_rand = 0
      rss_provider.frequence.times do |t|
        my_limit = hour / (rss_provider.frequence-t+1)
        rand = rand(my_limit)+1
        sum_rand += rand
        #puts "*****limit: #{my_limit} / rand :#{rand} / sum_rand#{sum_rand}"
        hour -= rand
        rss_provider.rss_twitts.build(:to_send_at => DateTime.tomorrow.at_beginning_of_day.advance(:hours => sum_rand, :minutes => rand(60)))
      end
      rss_provider.save
    end

  end

  # cherche si il est temps de lancer un twitt, si oui... il le lance
  def self.find_to_send
    RssTwitt.where("to_send_at<? and ISNULL(send_at)", Time.now).each do |rss_twitt|
      rss_twitt.rss_provider.load_and_update
      rss_twitt.twitt, rss_twitt.rss_item_id = rss_twitt.rss_provider.tweet_me
      rss_twitt.send_at = Time.now
      rss_twitt.save
    end

    RtTwittHistory.where("to_send_at<? and ISNULL(send_at)", Time.now).each do |rt_twitt_history|
      to_twitt = rt_twitt_history.rt_twitt.rss_provider.rss_twitts.where('NOT ISNULL(send_at)').order('rt_count asc').first
      if to_twitt
        prefix = "RT #{to_twitt.rss_provider.user_twitter.username} : "
        message = "#{prefix} #{ApplicationController.helpers.truncate(to_twitt.twitt, :length => 140-prefix.length)}"
        begin
          @client = Twitter::Client.new(
            :oauth_token => rt_twitt_history.rt_twitt.user_twitter.twitter_token,
            :oauth_token_secret => rt_twitt_history.rt_twitt.user_twitter.twitter_secret_token
          )
          @client.update(message)
          to_twitt.rt_count +=1
        rescue
        end
        rt_twitt_history.twitt = message
        rt_twitt_history.send_at = Time.now
        rt_twitt_history.save
        to_twitt.save
      end
    end
  end
end
