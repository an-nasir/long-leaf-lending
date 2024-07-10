# app/services/pdf_generator.rb

class PdfGenerator
  def initialize(data)
    @data = data
  end

  def generate_pdf
    pdf = Prawn::Document.new do |pdf|
      pdf.font_size 12
      pdf.stroke_color 'cccccc'
      pdf.text "Term Sheet", size: 30, style: :bold
      pdf.stroke_horizontal_rule
      pdf.move_down 30

      pdf.text "Loan Details", size: 20, style: :bold
      pdf.stroke_horizontal_rule
      pdf.move_down 20

      loan_details_data.each do |label, value|
        pdf.text "#{label}:", style: :bold
        pdf.text "#{value}", align: :right
        pdf.stroke_horizontal_rule
        pdf.move_down 10
      end

      pdf.move_down 60
      pdf.text "Terms", size: 20, style: :bold
      pdf.stroke_horizontal_rule
      pdf.move_down 20
      pdf.text "#{Date.current.year} Longleaf Lending, LLC. All rights reserved"

      # Additional content formatting as needed
    end


    file_path = Rails.root.join('tmp', "termsheet_#{SecureRandom.uuid}.pdf")
    pdf.render_file(file_path)
    file_path.to_s
  end

  private

  def loan_details_data
    {
      "Address" => @data[:address],
      "Loan Term" => "#{@data[:loan_term]} months",
      "Purchase Price" => "$#{@data[:purchase_price]}",
      "Repair Budget" => "$#{@data[:repair_budget]}",
      "Repair Value" => "$#{@data[:repair_value]}",
      "Loan Amount" => "$#{@data[:loan_amount]}",
      "Interest Expense" => "$#{@data[:interest_expense]}",
      "Estimated Profit" => "$#{@data[:estimated_profit]}"
    }
  end
end
