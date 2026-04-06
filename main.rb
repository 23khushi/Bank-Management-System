require_relative './Account.rb'
require_relative './Bank.rb'
require_relative './User.rb'
require_relative './transaction.rb'


account = Account.new
bank = Bank.new
@input = User.new
transaction = Transaction.new

def users_input
  users = [
#   { acc_type: "Saving",
#     adhar_no: "985455555555",
#     mobile_no: "7685940876",
#     name: "Khushi Solanki",
#     bank_name: "HDFC",
#     initial_bal: 500,
#     pass: "2222",
#     acc_otp: "1234",
#     ifsc_code: "HDFC0000007"
#     },


  { acc_type: "Current",
    adhar_no: "895455555555",
    mobile_no: "4556677898",
    name: "Disha Patel",
    bank_name: "ICICI",
    initial_bal: 1500,
    pass: "1111",
    acc_otp: "1234",
    ifsc_code: "ICIC0001966"
  }

  # { acc_type: "Current",
  #   adhar_no: "2abcd234",
  #   mobile_no: "9309375666",
  #   name: "Harsh mehta",
  #   bank_name: "HDFC",
  #   initial_bal: 2000,
  #   pass: "2233",  
  #   acc_otp: "1234",
  #   ifsc_code: "ICIC0000338" 
  # }
  ]
  users.each do |user|
    @input.create_account(user)
  end

end

bank.insert_bank_details
while (true)
    begin
        puts "Enter the Operation you want to perform
           \n1)New Customer Registration
           \n2)Tranfer Money
           \n3)Check Balance
           \n4)Update account
           \n5)Delete account
           \n6)Users All accounts
           \n7)Exit"
           
          

        operation = Integer(gets.chomp)
        case operation
        when 1
           users_input
        when 2
            transaction.transfer(19044711, 86988099, 'HDFC0000007', 'ICIC0001966', 200)
        when 3
             account.show_balance
        when 4
             account.update_account
        when 5
            account.delete_account
        when 6
            account.show_user_accounts
        when 7
            puts "Thank You !!! Exiting from the System."
            break
        else 
            puts "Invalid Input"
        end
    rescue ArgumentError
        puts "Error: Please Enter valid input"
        retry
    end
end
