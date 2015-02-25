class User < ActiveRecord::Base
  acts_as_token_authenticatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def password_required?
    super && provider.blank?
  end
end
