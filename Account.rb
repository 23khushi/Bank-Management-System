require_relative './database.rb'
class Account < Bank
    attr_accessor  :deposit_amount, :withdraw_amount
    def initialize()
        super()
    end
 
    def create_account(user)
        begin
            @adhar_no = user[:adhar_no]
            verify_aadhar
            @acc_type = user[:acc_type]
            @mobile_no = user[:mobile_no]
            verify_mobile
            @name = user[:name]
            verify_name
            @acc_no = user[:acc_no]
            @balance = user[:balance]
            verify_balance
            @pass = user[:pass]
            verify_pass 
            
            @acc_no = rand(10000000..99999999)
            @acc_no.to_s
            puts "Congratulations!!!! Account Successfully Opened"
            puts "Note down your account number: #{@acc_no}"

            begin
                CONN.exec_params(
                    'INSERT INTO users (adhar_no, mobile_no, name, acc_type, acc_no, balance, pass) VALUES ($1, $2 , $3, $4, $5, $6, $7)',
                    [@adhar_no, @mobile_no, @name, @acc_type, @acc_no, @balance, @pass]
                )
                puts 'Insert successful.'
            rescue PG::Error => e
                puts "Error: #{e.message}"
            end
            # @@accounts_array << {
            #     adhar_no: @adhar_no,
            #     mobile_no: @mobile_no,
            #     name: @name, 
            #     acc_type: @acc_type,
            #     acc_no: @acc_no, 
            #     balance: @balance,
            #     pass: @pass}

            # return @@accounts_array
            puts "#{@@accounts_array}"
        rescue => e
            puts "Account creation failed: #{e}"
        end
    end

    def deposit # Deposit & Withdraw  & Balance methods ko private banakar handle kro
        acc = verify_acc
        begin
            if acc
                puts "Enter Amount"
                amount = gets.chomp.to_i
                perform_deposit(acc, amount)
            end
        rescue => e
            puts "Error: Invalid Amount"
        end
    end

    def withdraw
       acc = verify_acc
        begin
           if acc
                puts "Enter Amount"
                amount = gets.chomp.to_i
                perform_withdraw(acc , amount)
           end
        rescue => e
            puts "Error: Invalid Amount"
        end
    end   


    def show_balance
        acc = verify_acc
        if acc
          perform_balance(acc)  
        end
    end

    def delete_account
        acc = verify_acc
        if acc
            perform_delete(acc)
        end
    end

    def update_account
        acc = verify_acc
        begin
            if acc
                puts "Enter the element you want to update
                \n1)aadhar Number
                \n2)Mobile Number
                \n3)Account Type"
                type = Integer(gets.chomp)
                perform_update(acc, type)
            end
        rescue ArgumentError
            puts "Please enter valid input "
        end
        puts "#{acc}"
    end



    private
    def perform_deposit(acc , deposit_amount)
        begin
            if deposit_amount <=0
                raise "Invalid Amount"
            else
                @account[:balance] = @account[:balance]  + deposit_amount
                puts "Deposit successfully Completed! "
                puts "Total Balance: #{@account[:balance]}"
            end
        rescue => e
            puts "Error: #{e}"
        end
    end

    def perform_withdraw(acc, withdraw_amount)
        begin
             if withdraw_amount <= 0
                raise "Invalid Amount"
            elsif @account[:balance] < 100 || withdraw_amount > @account[:balance]
                raise "Oops!! Not Enough Balance"
            else
                @account[:balance] = @account[:balance] - withdraw_amount
                puts "Withdraw successfully Completed! "
                puts "Total Balance: #{@account[:balance]}"
            end
        rescue => e
            puts "Error: #{e}"
        end
    end

    def perform_balance(acc)
        puts "Total Balance: #{@account[:balance]}"
    end

    def perform_delete(acc)
        begin
            account = @@accounts_array.delete_if{|a| a[:acc_no] == @acc_no}
            puts "Account deleted for account no #{@acc_no}"
            puts "#{@@accounts_array}"
        end
    end

    def perform_update(acc,type)
        begin
            if(type == 1)
                puts "Enter aadhar number: "
                @adhar_no = gets.chomp
                if @adhar_no == acc[:adhar_no]
                    puts "Same as existing aadhar number"
                end
                acc[:adhar_no] = @adhar_no
                verify_aadhar
            elsif(type == 2)
                puts "Enter mobile number"
                @mobile_no = gets.chomp
                if @mobile_no == acc[:mobile_no]
                    puts "Same as existing mobile number"
                end
                acc[:mobile_no] = @mobile_no
                verify_mobile
            elsif(type == 3)
                puts "Enter which account you want to switch: 
                \n1)Saving Account
                \n2)Current Account"
                switch_type = Integer(gets.chomp)
                if(switch_type == 1)
                    if acc[:acc_type] ==  "Saving"
                        puts "Same as existing account"
                    end
                    acc[:acc_type] = "Saving"
                elsif(switch_type == 2)
                    if acc[:acc_type] ==  "Current"
                        puts "Same as existing account"
                    end
                   acc[:acc_type] = "Current"
                end
            end
        rescue => e
            puts "Error: #{e}"
        end  
    end
end