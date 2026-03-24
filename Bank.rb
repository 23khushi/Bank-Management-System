class Bank
  attr_accessor :adhar_no , :name,  :balance, :acc_type, :accounts_array, :pass, :mobile_no, :otp, :acc_no
  @@accounts_array = []
  
  def initialize()
      @balance = 0 
  end

  def verify_aadhar
    puts "Verifying #{@adhar_no}"
      # adhr_len = @adharNo.to_s.length
    unless @adhar_no.match?(/^[2-9]\d{11}$/)
      raise "Invalid aadhar Number"
    end
    if @@accounts_array.any?{|a| a[:adhar_no] == @adhar_no  && a[:acc_type] == @acc_type }
      raise "Duplicate aadhar number"
    end
      # puts "Enter Adhar no: "
      # @adharNo = gets.chomp
      # verificationAadhar()
  end

  def verify_mobile
      # mobileNo_len = @mobileNo.to_s.length
    unless @mobile_no.match?(/[1-9]{1}[0-9]{9}$/)
      raise "Invalid mobile number"
    end
   	if @@accounts_array.any?{|f| f[:mobile_no] == @mobile_no  && f[:acc_type] == @acc_type}
      puts @accType
      puts @mobile_no
    	raise "Duplicate Mobile no"
		end
      # puts @account&.dig(:mobile_no)
      # puts "Enter Mobile no: "
      # @mobileNo = gets.chomp
  end
 

  def verify_name
    unless @name.match?(/\A[a-zA-Z]+\s([a-zA-Z]+)*\z/)
      raise "Please Enter First Name and Last Name #{@name}"
    end
  end

  def verify_balance
    if @balance < 100 && @acc_type == "Saving"
      raise "Initial Balance for Saving Account must be 100 or above"
    elsif @balance < 500 && @acc_type == "Current"
      raise "Initial Balance for Current Account must be 500 or above"
    end
  end

 def verify_pass
    if @pass.length != 4
      raise "Password must be of only 4 digits!!"
    end
 end

  def verify_acc
    puts "Enter Account Number: "
    acc_number = gets.chomp.to_i
    @account = @@accounts_array.find{|a| a[:acc_no] == acc_number}
    unless @account
      puts "Account does not exist"
      return nil
    end
    
    begin
      puts "Enter password"
      password = gets.chomp
      if ((@account[:pass] == password))
        puts "Account Verification successfull!!"
      else
        raise "Incorrect Password or Account doesnt exist!"
      end
      otp = rand(1000..9999)
      puts "Pop Up : Otp = #{otp}"
      puts "Enter Otp: "

      begin
        userOtp = Integer(gets.chomp)
      rescue ArgumentError
      end
      
      if(userOtp == otp)
        puts "Verification Successfull"
        return @account
      else
        raise CustomException.new("Invalid input")
      end
      # rescue => e
      #   puts "Error #{e}"
      # end
    rescue => e
      puts "Error #{e}"
      retry
    end
  end 
end    
