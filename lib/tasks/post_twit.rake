namespace :post_twit do
  desc "Post all needed twitt"
  task :run  => :environment do
    RssProvider.find_to_send
  end

  desc "Tache quotidienne de preparation des twitt"
  task :daily => :environment do
    RssProvider.daily_prepare
    RtTwitt.daily_prepare
  end
end