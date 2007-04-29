class Person < ActiveRecord::Base
  belongs_to :user
  has_many :resumes, :as => :attachable, :dependent => :destroy

end
