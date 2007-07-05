#!/usr/bin/env ruby
require 'net/pop'

require File.dirname(__FILE__) + "/../../config/environment"

@config = YAML.load(IO.read("#{RAILS_ROOT}/config/mail.yml"))
ENV["RAILS_ENV"] ||= "production"

log = ActiveRecord::Base.logger
log << "starting mail_check daemon at #{Time.now.strftime('%d/%m/%y')} in the #{RAILS_ENV} environment\n"

$running = true;
Signal.trap("TERM") do 
   $running = false
end

while($running) do    
  Net::POP3.new(@config[RAILS_ENV]['server']).start(@config[RAILS_ENV]['username'], @config[RAILS_ENV]['password']) do |pop|
      pop.each_mail do |email|
      begin
        EmailSystem.receive(email.pop)        
        email.delete
      rescue Exception => error
        log << "*******************************\n #{error.backtrace.join("\n")}\n *******************************\n"
      end
      end
  end
  sleep 10
end