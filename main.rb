require_relative "./Bank.rb"
require_relative "./Account.rb"


  users = [
    {adhar_no: 985455555555,
    mobile_no: 7685940876,
    name: "Khushi Solanki", 
    acc_type:"Saving",
    acc_no: 0, 
    balance:1000,
    pass: 2222
},
  { adhar_no: 010101010101,
    mobile_no: 9869557604,
    name: "ChitraBhide", 
    acc_type:"Current",
    acc_no: 0, 
    balance:2000,
    pass: 3333 
  },

  { adhar_no: 673289013456,
    mobile_no: 8739001245,
    name: "Deshna Patwa", 
    acc_type:"Saving",
    acc_no: 0, 
    balance:1500,
    pass: 2323 
  },

  { adhar_no: 233445456576,
    mobile_no: 7685940876,
    name: "Khushi Solanki", 
    acc_type:"Current",
    acc_no: 0, 
    balance:3000,
    pass: 1111
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
           \n5)Exit"
    
        input = Integer(gets.chomp)
        case input
        when 1
            users.each do |user|
                account.create_account(user)
            end
        when 2
            account.depositMethod 
        when 3 
            account.withdrawMethod
        when 4
             account.showBalance
        when 5
            puts "Thank You !!! Exiting from the System."
            break
        else 
            raise "Invalid Option"

        end
    rescue => e
        puts "Error: #{e}"
        retry
    end
end
