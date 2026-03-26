require_relative './database.rb'
require_relative './validations_module.rb'
class Account 
    include Validations
    attr_accessor :adhar_no , :name,  :balance, :acc_type, :accounts_array, :pass, :mobile_no, :otp, :acc_no,:deposit_amount, :withdraw_amount

    def create_account(user)
        begin
            @acc_type = user[:acc_type]
            @adhar_no = user[:adhar_no]
            verify_aadhar
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
    end



    private
    def perform_deposit(acc , deposit_amount)
        begin
            amount =  @account[0]['balance']
            amt =  amount.to_i
            if deposit_amount <= 0
                raise "Invalid Amount"
            else 
                amt = amt  + deposit_amount
                puts "Deposit successfully Completed! "
                
                # UPDATE BALANCE 
                CONN.exec_params(
                    'UPDATE users SET balance = $1 where acc_no = $2',
                    [amt,@acc_number]
                )
                puts "Updated Successfully! "
                puts "Total Balance: #{amt}"
            end
        rescue => e
            puts "Error: #{e}"
        end
    end

    def perform_withdraw(acc, withdraw_amount)
        begin
             amount =  @account[0]['balance']
             amt =  amount.to_i
             if withdraw_amount <= 0
                raise "Invalid Amount"
            elsif  amt < 100 || withdraw_amount >  amt
                raise "Oops!! Not Enough Balance"
            else
                 amt =  amt - withdraw_amount
               CONN.exec_params(
                    'UPDATE users SET balance = $1 where acc_no = $2',
                    [amt,@acc_number]
                )
                puts "Updated Successfully! "
                puts "Total Balance: #{amt}"
            end
        rescue => e
            puts "Error: #{e}"
        end
    end

    def perform_balance(acc)
        bal = CONN.exec_params(
            'SELECT balance FROM USERS WHERE acc_no = $1',
            [@acc_number]
        )
        puts bal.values
    end

    def perform_delete(acc)
        begin
            CONN.exec_params(
                'DELETE FROM users WHERE acc_no = $1',
                [@acc_number]
            )
            puts "Account deleted for account no #{@acc_number}"
        rescue PG::Error => e
            puts "Error: #{e.message}"
        end
    end

    def perform_update(acc,type)
        begin
            if(type == 1)
                puts "Enter aadhar number: "
                @adhar_no = gets.chomp
                if @adhar_no == acc[0]['adhar_no']
                    puts "Same as existing aadhar number"
                end
                verify_aadhar
                CONN.exec_params(
                    'UPDATE users set adhar_no = $1 where acc_no = $2',
                    [@adhar_no, @acc_number ]
                )
                puts "Updated aadhar no successfully!"
                
            elsif(type == 2)
                puts "Enter mobile number"
                @mobile_no = gets.chomp
                if @mobile_no == acc[0]['mobile_no']
                    puts "Same as existing mobile number"
                end
                verify_mobile
                 CONN.exec_params(
                    'UPDATE users set mobile_no = $1 where acc_no = $2',
                    [@mobile_no, @acc_number]
                ) 
                 puts "Updated mobile no successfully!"

            elsif(type == 3)
                puts "Enter which account you want to switch: 
                \n1)Saving Account
                \n2)Current Account"
                switch_type = Integer(gets.chomp)
                if(switch_type == 1)
                    if acc[0]['acc_type'] ==  "Saving"
                        puts "Same as existing account"
                    end
                     CONN.exec_params(
                    'UPDATE users set acc_type = $1 where acc_no = $2',
                    ["Saving", @acc_number]
                    ) 
                    puts "Updated to Saving Account"
                elsif(switch_type == 2)
                    if acc[0]['acc_type'] ==  "Current"
                        puts "Same as existing account"
                    end
                    CONN.exec_params(
                    'UPDATE users set acc_type = $1 where acc_no = $2',
                    ["Current", @acc_number]
                    )   
                    puts "Updated to Current Account"
                end
            end
        rescue => e
            puts "Error: #{e}"
        end  
    end
end