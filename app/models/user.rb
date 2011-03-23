class User < ActiveRecord::Base
# attr_accessible :access_token, :access_token_secret, :last_login

  validates :access_token,
    :presence => true,
    :uniqueness => true,
    :length => {:minimum => 32, :maximum => 64},
    :format => {:with => /[A-Za-z0-9]+/} # Alphanumeric
  validates :access_token_secret,
    :presence => true,
    :uniqueness => true,
    :length => {:minimum => 32, :maximum => 64},
    :format => {:with => /[A-Za-z0-9]+/} # Alphanumeric

  before_save :set_salt, :set_last_login

  def set_salt
    self.salt = Digest::SHA2.hexdigest(Time.now.utc.to_s) if new_record?
  end

  def set_last_login
    self.last_login = Time.now.utc
  end

end
