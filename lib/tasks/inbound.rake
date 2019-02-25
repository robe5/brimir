namespace :inbound do
  desc "Process inbound emails"
  task process: :environment do
    logger = Logger.new(Rails.root.join("log/inbound.log"))

    begin
      logger.info "Processing: #{Time.zone.now}"

      Mail.defaults do
        retriever_method(
          :imap,
          address: Rails.application.secrets.inbound[:server],
          port: Rails.application.secrets.inbound[:port],
          enable_ssl: true,
          user_name: Rails.application.secrets.inbound[:username],
          password: Rails.application.secrets.inbound[:password]
        )
      end

      Mail.find_and_delete(count: 100).each do |message|
        puts "mensaje: #{message}"
        MailReceiver.receive(message)
      end
      # gmail = Gmail.connect(Rails.application.secrets.inbound[:username], Rails.application.secrets.inbound[:password])
      # gmail.inbox.find(:unread).each do |email|
      #   puts "mensaje: #{message}"
      #   MailReceiver.receive(message)
      # end
    rescue => e
      logger.error e
      puts "Error #{e.inspect}"
      # ExceptionNotifier.notify_exception(e)
    end
  end
end