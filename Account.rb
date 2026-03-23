class Account < Bank
    attr_accessor  :deposit_amount, :withdraw_amount
     def initialize()
        @deposit_amount= nil
        super()
     end


    #  def accTypeMethod()
    #     begin
    #         puts "Enter Account Type : \n1)Saving Account \n2)Current Account"
    #         type = Integer(gets.chomp)
    #         if(type==1)
    #             @accType = "Saving"
    #             userInput()
    #             createAccount()
    #         elsif(type==2)
    #             @accType = "Current"
    #             userInput()
    #             createAccount()
    #         else
    #             raise "Invalid Choice"
    #         end
    #     rescue => e
    #         puts "Error #{e}"
    #         retry
    #     end
    # end

    

    def create_account(user)
    
     @adhar_no = user[:adhar_no]
     verify_aadhar()
     @mobile_no = user[:mobile_no]
     verify_mobile()
     @name = user[:name]
     verify_name()
     @acc_type = user[:acc_type]
     @acc_no = user[:acc_no]
     @balance = user[:balance]
     @pass = user[:pass]


        begin
            # puts "Enter initial Balance: "
            # @Balance = Integer(gets.chomp)
            if @balance < 100 && @acc_type == "Saving"
                    raise "Initial Balance for Saving Account must be 100 or above"
            elsif @balance < 500 && @acc_type == "Current"
                    raise "Initial Balance for Current Account must be 500 or above"
            end
        rescue => e
            puts "Error #{e}"
        end
        @acc_no = rand(10000000..999999999)
        @acc_no.to_s
        puts "Congratulations!!!! Account Successfully Opened"
        puts "Note down your account number: #{@acc_no}"

        begin
            # puts "Create a 4 digits password (Should be on the scale of 0-9): "
            # @pass = Integer(gets.chomp)
            if @pass.to_s.length != 4
                raise "Password must be of only 4 digits!!"
            end
        rescue => e
            puts "Error : #{e}"
        end      
              
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
    end

    def deposit() # Deposit & Withdraw  & Balance methods ko private banakar handle kro
       verify_acc()
        begin
            puts "Enter the deposit Amount"
            deposit_amount = Integer(gets.chomp)
            if deposit_amount <=0
               raise "Invalid Amount"
            else
               @account[:balance] = @account[:balance]  + @deposit_amount
               puts "Deposit successfully Completed! "
               puts "Total Balance: #{@account[:balance]}"
            end
        rescue => e 
            puts "Error : #{e}"
            retry
        end
        @account[:balance]
    end

    def withdraw()
       verify_acc()
        begin
            puts "Enter the amount you want to withdraw"
            @withdraw_amount = Integer(gets.chomp)
            if @withdraw_amount <=0
                raise "Invalid Amount"
            elsif @account[:balance] < 100 || @withdraw_amount > @account[:balance]
                puts "Oops!! Not Enough Balance"
            else
                @account[:balance] = @account[:balance] - @withdraw_amount
                puts "Withdraw successfully Completed! "
                puts "Total Balance: #{@account[:balance]}"
            end
        rescue => e
            puts "Error : #{e}"   
            retry 
        end
    end   
    def show_balance()
        verify_acc()
        puts "The total Balance : #{@account[:balance]}"
     end


end