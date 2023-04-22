module PurchasesHelper
  def formatted_date(date)
    date.strftime("%d/%m/%Y")
  end
end
