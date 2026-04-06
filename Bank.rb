require_relative './bank_valid.rb'
require_relative './database.rb'
require_relative './Queries_Module.rb'
class Bank
  include BankValid
  include Fire_Queries
  def insert_bank_details
    BANK_DETAILS.each do |bank_name, ifsc_code|
      ifsc_code.each do |code|
        name = bank_name.upcase.to_s
     
        exists = CONN.exec_params(
        'SELECT EXISTS (SELECT 1 FROM bank WHERE bank_name = $1 AND ifsc_code = $2)',
        [name , code]
       )  
      
        if exists.values.flatten.first == 'f'
          insert_query('bank', ['bank_name', 'ifsc_code'], {bank_name: bank_name.upcase.to_s, ifsc_code: code})
        end
      end 
     end
  end
end