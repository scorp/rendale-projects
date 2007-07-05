namespace :mail do
  desc "forward email to rails for processing"
  task(:forward => :environment) do
    EmailSystem.receive(STDIN.read)
    puts "run"
  end

  desc "check email using getmail"
  task(:check => :environment) do
    `~/rails/MailFetch/vendor/getmail/getmail`
  end
end
