class SendTermsheetEmailJob < ApplicationJob
  queue_as :default

  def perform(user, pdf_file_path)
    pdf = File.read(pdf_file_path)
    LendingFormMailer.termsheet_email(user, pdf).deliver_now
  ensure
    File.delete(pdf_file_path) if File.exist?(pdf_file_path)
  end
end