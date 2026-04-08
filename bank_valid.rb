# require_relative './User.rb'

module BankValid
   # BANK NAME VERIFICATION
  BANK_DETAILS = {hdfc: ['HDFC0000007', 'HDFC0000029', 'HDFC0000148', 'HDFC0000001', 'HDFC0000002'], icici: [ 'ICIC0000338', 'ICIC0001966', 	'ICIC0006493', 'ICIC0000985', 'ICIC0000039']}
 
  def verify_bank_name(bank)
    bank_name = bank.downcase.to_sym
    unless BANK_DETAILS.keys.include?(bank_name)
      raise "Invalid Bank Name"
    end
  end

  def verify_ifsc_code(bank,ifsc)
    bank_name = bank.downcase.to_sym
    if BANK_DETAILS.keys.include?(bank_name)
     unless BANK_DETAILS[bank_name].include?(ifsc)
        raise "Invalid IFSC code for bank #{bank_name}"
      end
    else
      raise "Invalid Bank Name"
    end
  end
end