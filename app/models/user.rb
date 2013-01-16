class User < ActiveRecord::Base
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  devise :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :password, :password_confirmation, :remember_me, :login, :fee
  # attr_accessible :title, :body

  attr_accessor :login
  has_many :rss_providers
  has_many :user_twitters

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def valid_password?(password)
    !provider.nil? || super(password)
  end

  def email_required?
    false
  end

  def max_twitt
    if self.fee == 2
      13
    elsif self.fee == 1
      6
    else
      2
    end
  end

  def max_retwitt
    if self.fee == 2
      51
    elsif self.fee == 1
      11
    else
      0
    end
  end

  def can_add_account
    if self.fee == 2
      true
    elsif self.fee == 1
      self.user_twitters.count < 3
    else
      false
    end
  end

  def can_add_rss_provider
    if self.fee == 2
      true
    elsif self.fee == 1
      self.rss_providers.count < 5
    else
      false
    end
  end


end
