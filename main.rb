require_relative "./Bank.rb"
require_relative "./Account.rb"

customer = Account.new




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
           customer.accTypeMethod
        when 2
            customer.depositMethod 
        when 3 
            customer.withdrawMethod
        when 4
             customer.showBalance
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
