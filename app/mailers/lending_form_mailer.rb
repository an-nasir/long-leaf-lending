#mailer for pdf

class LendingFormMailer < ApplicationMailer
  def termsheet_email(user, pdf_content)
    attachments['termsheet.pdf'] = { mime_type: 'application/pdf', content: pdf_content }
    mail(to: user[:email], subject: 'Your Term Sheet from Longleaf Lending') do |format|
      format.text { render plain: "Dear #{user[:first_name]} #{user[:last_name]},\n\nPlease find attached your term sheet.\n\nBest regards,\nLongleaf Lending" }
    end
  end
end

