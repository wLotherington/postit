class User < ApplicationRecord
  include Sluggable

  has_many :posts
  has_many :comments
  has_many :votes

  has_secure_password validations: false

  validates :username, presence: true, uniqueness: true
  validates :password, presence: true, on: :create, length: {minimum: 5}

  sluggable_column :username

  def two_factor_auth?
    !self.phone.blank?
  end

  def generate_pin!
    self.update_column(:pin, rand(10 ** 6)) # random 6 digit number
  end

  def remove_pin!
    self.update_column(:pin, nil)
  end

  def send_pin_to_twilio
    account_sid = Rails.application.credentials.twilio[:account_sid]
    auth_token = Rails.application.credentials.twilio[:auth_token]
    client = Twilio::REST::Client.new(account_sid, auth_token)

    from = '+12518620916'
    to =  '+1' + self.phone
    msg = "Hi, please input the pin to continue login: #{self.pin}"

    client.messages.create(
    from: from,
    to: to,
    body: msg
    )
  end

  def admin?
    self.role == 'admin'
  end

  def moderator?
    self.role == 'moderator'
  end
end