require_relative './Account.rb'

  users = [
#    { acc_type: "Saving",
#      adhar_no: "985455555555",
#      mobile_no: "7685940876",
#      name: "Khushi Solanki",
#      bank_name: "HDFC",
#      initial_bal: 500,
#      pass: "2222",
#      acc_otp: "1234"
#     },


#   {  acc_type: "Current",
#      adhar_no: "895455555555",
#      mobile_no: "4556677898",
#      name: "Disha Patel",
#      bank_name: "ICICI",
#      initial_bal: 1500,
#      pass: "1111",
#      acc_otp: "1234"
#   },

  {  acc_type: "Saving",
     adhar_no: "657483947564",
     mobile_no: "7654239090",
     name: "Trisha Deshmukh",
     bank_name: "hdfc",
     initial_bal: 400,
     pass: "3456",  
     acc_otp: "1234"
  }
  ]

account = Account.new




while (true)
    begin
        puts "Enter the Operation you want to perform
           \n1)New Customer Registration
           \n2)Deposit Money 
           \n3)Withdraw Money
           \n4)Check Balance
           \n5)Update account
           \n6)Delete account
           \n7)Exit"

        input = Integer(gets.chomp)
        case input
        when 1
            users.each do |user|
                account.create_account(user)
            end
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
