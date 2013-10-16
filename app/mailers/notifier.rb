class Notifier < ActionMailer::Base
  default from: "no-reply@obsqure.net"

  def verify(address)
    @address = address
    mail(to: @address.to, subject: "Verify your email address for Obsqure.")
  end
end
