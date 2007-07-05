class EmailSystem < ActionMailer::Base
  
  class InboundMail
    attr_accessor :to, :from, :subject, :html, :text     
    def initialize(mail)
      
      @subject = mail.subject
      @to = mail.to_addrs.to_a
      @from = mail.from_addrs
      
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
    log << inbound_mail.inspect
  end

end
