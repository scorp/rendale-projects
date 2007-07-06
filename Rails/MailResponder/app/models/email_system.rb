class EmailSystem < ActionMailer::Base
  
  class InboundMail
    attr_accessor :to, :from, :subject, :html, :text     
    def initialize(mail)
      
      @subject = mail.subject
      @to = mail.to
      @from = mail.from
      
      if mail.multipart?
        mail.parts.each do |m|
          case m.content_type
            when "text/plain"
              @text = m.body
            break
            when "text/html"
              @html = m.body
            break
          end
        end
      end

    end
  end

  def receive(mail)
    log = self.class.logger
    inbound_mail = InboundMail.new(mail)
    begin
       user = User.find(:first, :conditions=>["query_address = ?", inbound_mail.to[0].to_s.match(/(^.*)__(.*)@/)[1]])
       if user.crypted_password == user.encrypt(inbound_mail.to.to_s.match(/(^.*)__(.*)@/)[2])
         # if inbound_mail.subject.scan(/\?/)
         # keywords = inbound_mail.subject.gsub(/\?/,"")
         # facts = user.facts.find(:all, conditions=>["keywords = ?", keywords])
         # log << facts.text
         # else
         user.facts.build(:keywords=>inbound_mail.subject, :text=>inbound_mail.text).save
         # end
       end
     rescue Exception => error
       log << error.to_s + "\n***************************\n" + error.backtrace.join
    end
  end

end
