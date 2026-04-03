require_relative './Account.rb'
require_relative './Bank.rb'
require_relative './User.rb'



account = Account.new
bank = Bank.new
@input = User.new

def users_input
  users = [
  { acc_type: "Saving",
    adhar_no: "985455555555",
    mobile_no: "7685940876",
    name: "Khushi Solanki",
    bank_name: "HDFC",
    initial_bal: 500,
    pass: "2222",
    acc_otp: "1234",
    ifsc_code: "HDFC0000007"
    }


  # { acc_type: "Current",
  #   adhar_no: "895455555555",
  #   mobile_no: "4556677898",
  #   name: "Disha Patel",
  #   bank_name: "ICICI",
  #   initial_bal: 1500,
  #   pass: "1111",
  #   acc_otp: "1234",
  #   ifsc_code: "3456"
  # },

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

while (true)
    begin
        puts "Enter the Operation you want to perform
           \n1)New Customer Registration
           \n2)Deposit Money 
           \n3)Withdraw Money
           \n4)Check Balance
           \n5)Update account
           \n6)Delete account
           \n7)Users All accounts
           \n8)Exit"

        input = Integer(gets.chomp)
        case input
        when 1
           users_input
        when 2
            account.deposit
        when 3 
            account.withdraw
        when 4
             account.show_balance
        when 5
             account.update_account
        when 6
            account.delete_account
        when 7
            account.show_user_accounts
        when 8
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
