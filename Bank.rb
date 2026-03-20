class Bank
  attr_accessor :adharNo , :name,  :Balance, :accType, :accountArray, :pass, :mobileNo, :otp, :acc_no
  @@accountArray = []
  
  def initialize()
      @Balance = 0    
  end
  def verificationAadhar()
    begin
      # adhr_len = @adharNo.to_s.length
      unless @adharNo.match?("^[2-9]{1}[0-9]{3}[0-9]{4}[0-9]{4}$")
        raise "Invalid aadhar Number"
      end
      if @@accountArray.any?{|a| a[:adharNo] == @adharNo  && a[:accType] == @accType }
        raise "Duplicate aadhar number"
      end
    rescue => e
      puts "Error #{e}"
      puts "Enter Adhar no: "
      @adharNo = gets.chomp
      verificationAadhar()
    end
  end

  def mobileNoVerification()
    begin
      # mobileNo_len = @mobileNo.to_s.length
      unless @mobileNo.match?("[1-9]{1}[0-9]{9}$")
         raise "Invalid mobile number"
      end
   	  if @@accountArray.any?{|f| f[:mobileNo] == @mobileNo  && f[:accType] == @accType}
      	raise "Duplicate Mobile no"
			end
      puts @account&.dig(:mobileNo)
		rescue => e
      puts "Error #{e}"
      puts "Enter Mobile no: "
      @mobileNo = gets.chomp
      retry
    end
  end
 

  def userInput()
    
    puts "Enter Adhar no: "
    @adharNo = gets.chomp
    verificationAadhar()
    puts "Enter Mobile no: "
    @mobileNo =gets.chomp
    mobileNoVerification()
    @otp = rand(1000..9999)
    puts "Pop Up : Otp = {#@otp}"
    puts "Enter Otp: "
    @userOtp = Integer(gets.chomp)
    begin
       if(@otp == @userOtp)
          puts "Aadhar card is linked with mobile! Verification Successfull" 
      else
         raise"Invalid otp"
      end
    rescue => e 
      puts "Error #{e}"
      puts "Enter Otp: "
      @userOtp = Integer(gets.chomp)
      retry
    end
    begin
      puts "Enter Full Name: "
      @name = gets.chomp
      unless @name.match?(/\A[a-zA-Z]+\s+[a-zA-Z]+.*\z/)
          raise "Please Enter First Name and Last Name"
      end
    rescue => e
      puts "Error : #{e}"
      retry
    end
  end

  def accVerification()
    begin
      puts "Enter Account Number: "
      accNumber = Integer(gets.chomp)
      @account = @@accountArray.find{|a| a[:acc_no] == accNumber}
      unless @account
        return "Account doesnt exists"
      else
        puts "Enter password"
        password = Integer(gets.chomp)
        if ((@account[:pass]==password))
          puts "Account Verification successfull!!"
        else
          raise "Incorrect Password or Account doesnt exist!"
        end
      end
    rescue => e
      puts "Error #{e}"
      retry
    end
	end    
end