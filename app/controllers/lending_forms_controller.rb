# app/controllers/lending_forms_controller.rb

class LendingFormsController < ApplicationController
  def submit
    form_processor = LendingFormProcessor.new(form_params)
    result = form_processor.process_form

    if result[:error]
      render json: result, status: :unprocessable_entity
    else
      pdf_file_path = PdfGenerator.new(result).generate_pdf
      SendTermsheetEmailJob.perform_later(result, pdf_file_path)

      render json: { notice: 'Term sheet sent successfully!', redirect_url: root_url }
    end
  end

  private

  def form_params
    params.permit(:address, :loan_term, :purchase_price, :repair_budget,
                  :repair_value, :first_name, :last_name, :phone_number, :email)
  end
end
