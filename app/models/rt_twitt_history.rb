class RtTwittHistory < ActiveRecord::Base
  belongs_to :rt_twitt
  attr_accessible :send_at, :to_send_at, :twitt
end
