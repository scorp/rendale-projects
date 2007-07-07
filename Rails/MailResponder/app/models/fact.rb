class Fact < ActiveRecord::Base
  belongs_to :user

  def email_to_owner
    EmailSystem.deliver_answer(self.user.email,self)
  end

end
