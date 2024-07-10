# app/services/lending_form_processor.rb

class LendingFormProcessor
  def initialize(params)
    @params = params
  end

  def process_form
    return missing_params_error unless params_valid?

    loan_amount = calculate_loan_amount
    interest_expense = calculate_interest_expense(loan_amount).round(3)
    estimated_profit = calculate_estimated_profit(loan_amount, interest_expense).round(3)

    generate_response(loan_amount, interest_expense, estimated_profit)
  end

  private

  def params_valid?
    required_params = [:purchase_price, :repair_value, :loan_term]
    required_params.all? { |param| @params[param].present? }
  end


  def calculate_loan_amount
    max_loan_to_cost = Constants::MAX_LOAN_TO_COST_RATIO * @params[:purchase_price].to_f
    max_loan_to_value = Constants::MAX_LOAN_TO_VALUE_RATIO * @params[:repair_value].to_f
    [max_loan_to_cost, max_loan_to_value].min.round(3)
  end

  def calculate_interest_expense(loan_amount)
    #Interest Expense is calculated using a 13% annual rate,
    annual_rate = Constants::ANNUAL_INTEREST_RATE
    # compounded monthly for the loan term specified
    monthly_rate = annual_rate / 12

    loan_term = @params[:loan_term].to_i
    #calculating extra amount paid off the original loan amount due to interest
    # loan_term shows growth factor
    growth_factor = loan_amount * (1 + monthly_rate) ** loan_term
     # subtracting the original loan amount from the growth factor to get interest expense
    (growth_factor - loan_amount).round(3)
  end

  def calculate_estimated_profit(loan_amount, interest_expense)
    # profit as ARV minus total loan value minus total interest expense
    @params[:repair_value].to_f - loan_amount - interest_expense
  end

  def generate_response(loan_amount, interest_expense, estimated_profit)
    {
      address: @params[:address],
      loan_term: @params[:loan_term],
      purchase_price: @params[:purchase_price],
      repair_budget: @params[:repair_budget],
      repair_value: @params[:repair_value],
      first_name: @params[:first_name],
      last_name: @params[:last_name],
      phone_number: @params[:phone_number],
      email: @params[:email],
      loan_amount: loan_amount,
      interest_expense: interest_expense,
      estimated_profit: estimated_profit
    }
  end

  def missing_params_error
    { error: 'Missing required parameters: purchase_price, repair_value, loan_term' }
  end
end
