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
       user = User.find(:first, :conditions=>["dropbox = ?", inbound_mail.to[0].to_s.match(/(^.*)@/)[1]])
         if inbound_mail.subject.include?("?")
           question = inbound_mail.subject.gsub(/\?/,"")
           fact = user.facts.find(:first, :conditions=>["question = ?", question])
           fact.email_to_owner
         else
           user.facts.build(:question=>inbound_mail.subject, :answer=>inbound_mail.text).save
         end
     rescue Exception => error
       log << error.to_s + "\n***************************\n" + error.backtrace.join
    end
  end
  
  
  def answer(recipient, fact)
     recipients recipient
     from       "answermonkey@rendale.com"
     subject    fact.question
     body       :fact=>fact
  end
end
