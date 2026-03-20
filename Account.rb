class Account < Bank
    attr_accessor  :depositAmount, :withdrawAmount
     def initialize()
        @depositAmount= nil
        super()
     end


     def accTypeMethod()
        begin
            puts "Enter Account Type : \n1)Saving Account \n2)Current Account"
            type = Integer(gets.chomp)
            if(type==1)
                @accType = "Saving"
                userInput()
                createAccount()
            elsif(type==2)
                @accType = "Current"
                userInput()
                createAccount()
            else
                raise "Invalid Choice"
            end
        rescue => e
            puts "Error #{e}"
            retry
        end
    end

    

    def createAccount()
        begin
            puts "Enter initial Balance: "
            @Balance = Integer(gets.chomp)
            if @Balance < 100 && @accType == "Saving"
                    raise "Initial Balance for Saving Account must be 100 or above"
            elsif @Balance < 500 && @accType == "Current"
                    raise "Initial Balance for Current Account must be 500 or above"
            end
        rescue => e
            puts "Error #{e}"
            retry
        end
        @acc_no = rand(10000000..999999999)
        puts "Congratulations!!!! Account Successfully Opened"
        puts "Note down your account number: #{@acc_no}"

        begin
            puts "Create a 4 digits password (Should be on the scale of 0-9): "
            @pass = Integer(gets.chomp)
            if @pass.to_s.length != 4
                raise "Password must be of only 4 digits!!"
            end
        rescue => e
            puts "Error : #{e}"
            retry
        end      
              
        @@accountArray << {
                adharNo: @adharNo,
                mobileNo: @mobileNo,
                name: @name, 
                accType: @accType,
                acc_no: @acc_no, 
                balance: @Balance,
                pass: @pass}

        @@accountArray
        puts "#{@@accountArray}"
    end

    def depositMethod() # Deposit & Withdraw  & Balance methods ko private banakar handle kro
        accVerification()
        begin
            puts "Enter the deposit Amount"
            depositAmount = Integer(gets.chomp)
            if depositAmount <=0
               raise "Invalid Amount"
            else
               @account[:balance] = @account[:balance]  + @depositAmount
               puts "Deposit successfully Completed! "
               puts "Total Balance: #{@account[:balance]}"
            end
        rescue => e 
            puts "Error : #{e}"
            retry
        end
        @account[:balance]
    end

    def withdrawMethod
        accVerification()
        begin
            puts "Enter the amount you want to withdraw"
            @withdrawAmount = Integer(gets.chomp)
            if @withdrawAmount <=0
                raise "Invalid Amount"
            elsif @account[:balance] < 100 || @withdrawAmount > @account[:balance]
                puts "Oops!! Not Enough Balance"
            else
                @account[:balance] = @account[:balance] - @withdrawAmount
                puts "Withdraw successfully Completed! "
                puts "Total Balance: #{@account[:balance]}"
            end
        rescue => e
            puts "Error : #{e}"   
            retry 
        end
    end   
    def showBalance
        accVerification()
        puts "The total Balance : #{@account[:balance]}"
     end


end