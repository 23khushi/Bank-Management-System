class Account < Bank
    attr_accessor  :deposit_amount, :withdraw_amount
    def initialize()
        super()
    end
 
    def create_account(user)
        begin
            @adhar_no = user[:adhar_no]
            verify_aadhar()
            @acc_type = user[:acc_type]
            @mobile_no = user[:mobile_no]
            verify_mobile()
            @name = user[:name]
            verify_name()
            @acc_no = user[:acc_no]
            @balance = user[:balance]
            verify_balance()
            @pass = user[:pass]
            verify_pass()  
            
            @acc_no = rand(10000000..99999999)
            @acc_no.to_s
            puts "Congratulations!!!! Account Successfully Opened"
            puts "Note down your account number: #{@acc_no}"

            @@accounts_array << {
                adhar_no: @adhar_no,
                mobile_no: @mobile_no,
                name: @name, 
                acc_type: @acc_type,
                acc_no: @acc_no, 
                balance: @balance,
                pass: @pass}

            @@accounts_array
            puts "#{@@accounts_array}"
        rescue => e
            puts "Account creation failed: #{e}"
        end
    end

    def deposit() # Deposit & Withdraw  & Balance methods ko private banakar handle kro
        acc = verify_acc()
        begin
            if acc
                puts "Enter Amount"
                amount = gets.chomp.to_i
                perform_deposit(acc, amount)
            end
        rescue => e
            puts "Error: #{CustomException.new}"
        end
    end

    def withdraw()
       acc = verify_acc()
        begin
           if acc
                puts "Enter Amount"
                amount = gets.chomp.to_i
                perform_withdraw(acc , amount)
           end
        rescue => e
            puts "Error : #{CustomException.new}"  
        end
    end   


    def show_balance()
        acc = verify_acc()
        if acc
          perform_balance(acc)  
        end
    end

    def delete_account()
        acc = verify_acc()
        if acc
            perform_delete(acc)
        end
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
             if withdraw_amount <=0
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
end