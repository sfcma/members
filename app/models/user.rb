class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :lockable, :timeoutable,
         :password_expirable, :secure_validatable, :password_archivable
  acts_as_paranoid

  has_many :ensembles, class_name: "UserEnsemble"
  has_many :instruments, class_name: "UserInstrument"

  def display_name
    if self.name
      self.name
    else
      self.email
    end
  end
end
