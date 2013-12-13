class User < ActiveRecord::Base
  attr_accessible :email, :first_name, :key_public, :last_name, :login_salt, :password_digest, :username

  has_secure_password
  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_presence_of :username

  def renewLogin
  	self.renewLoginSalt
  	self.renewKeyPublic
  end

  def resetLogin
  	self.update_attribute(:login_salt, nil)
    self.update_attribute(:key_public, nil)
  end

  def renewLoginSalt
  	list = [('a'..'z'),('A'..'Z'),('0'..'9')].map{|i| i.to_a}.flatten
    self.update_attribute(:login_salt, (0...15).map{list[rand(list.length)]}.join)
  end

  def renewKeyPublic
  	self.update_attribute(:key_public, Digest::SHA2.hexdigest("#{self.login_salt} #{self.email.downcase}"))
  end

  def getFullName
  	return "#{self.first_name.capitalize} #{self.last_name.capitalize}"
  end

  def self.suggestUsername
    name = "#{self.first_name.capitalize}#{self.last_name.capitalize}"
    username = name
    count = 0
    while not User.isUsernameValid(username)
      count += 1
      username = "#{name}#{count}"
    end
    return username
  end

  def self.isUsernameValid(username)
  	return User.find_by_username(username).nil?
  end

  def self.isEmailValid(email)
  	return ((not (email =~ /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/).nil?) && (User.find_by_email(email).nil?))
  end

end
