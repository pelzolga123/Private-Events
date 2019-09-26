class User < ApplicationRecord
  has_many :created_events, class_name: 'Event', foreign_key: 'creator_id'
  has_many :event_attendees, foreign_key: 'attendee_id'
  has_many :attended_events, through: :event_attendees
  attr_accessor :remember_token

  validates :name, presence: true, length: 4..20
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(remember_token)
    return false if remember_digest.nil?

    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def upcoming_events
    self.attended_events.upcoming
  end

  def previous_events
    self.attended_events.past
  end

  def attending?(event)
    event.attendees.include?(self)
  end

  def attend!(event)
    self.event_attendees.create!(attended_event_id: event.id)
  end

  def cancel!(event)
    self.event_attendees.find_by(attended_event_id: event.id).destroy
  end
end
