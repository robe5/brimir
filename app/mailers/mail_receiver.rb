class MailReceiver < ActionMailer::Base
  def receive(email)
    #
    # Do your thing with inbound emails here... :)
    #
    TicketMailer.receive(email)
  rescue => e
    logger.error e
    # ExceptionNotifier.notify_exception(e)
  end

  private

  def logger
    @logger ||= Logger.new(Rails.root.join("log/mail_receiver.log"))
  end
end