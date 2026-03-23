require_relative "./Bank.rb"
require_relative "./Account.rb"

class CustomException < StandardError
    def initialize(message = "Invalid Input")
        super(message)
    end
end

  users = [
    {adhar_no: "985455555555",
    mobile_no: "7685940876",
    name: "Khushi Solanki", 
    acc_type: "Saving",
    acc_no: "0", 
    balance:500,
    pass: "2222"
},
  { adhar_no: "343434343434",
    mobile_no: "9869557604",
    name: "Chitra Bhide", 
    acc_type: "Current",
    acc_no: "0", 
    balance:2000,
    pass: "3333" 
  },

  { adhar_no: "673289013456",
    mobile_no: "8739001245",
    name: "Deshna Patwa", 
    acc_type: "Saving",
    acc_no: "0", 
    balance:1500,
    pass: "2323" 
  },

  { adhar_no: "233445456576",
    mobile_no: "7685940876",
    name: "Khushi Solanki", 
    acc_type: "Current",
    acc_no: "0", 
    balance:3000,
    pass: "1111"
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
            account.deposit()
        when 3 
            account.withdraw()
        when 4
             account.show_balance()
        when 5
            puts "Feature incoming"
        when 6
            account.delete_account()
        when 7
            puts "Thank You !!! Exiting from the System."
            break
        else 
            raise ("Invalid Input")
        end
    rescue ArgumentError
        puts "Error: Please Enter valid input"
        retry
    end
end
