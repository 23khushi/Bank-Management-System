class Bank
  attr_accessor :adhar_no , :name,  :balance, :acc_type, :accounts_array, :pass, :mobile_no, :otp, :acc_no
  @@accounts_array = []
  
  def initialize()
      @balance = 0    
  end
  def verify_aadhar()
    puts "Entering addhar"
    puts
    puts "Verifying #{@adhar_no}"
    begin
      # adhr_len = @adharNo.to_s.length
      unless @adhar_no.to_s.match?("^[2-9]{1}[0-9]{3}[0-9]{4}[0-9]{4}$")
        raise "Invalid aadhar Number"
      end
      if @@accounts_array.any?{|a| a[:adhar_no] == @adhar_no  && a[:acc_type] == @acc_type }
        raise "Duplicate aadhar number"
      end
    rescue => e
      puts "Error #{e}"
      # puts "Enter Adhar no: "
      # @adharNo = gets.chomp
      # verificationAadhar()
    end
  end

  def verify_mobile()
    begin
      # mobileNo_len = @mobileNo.to_s.length
      unless @mobile_no.match?("[1-9]{1}[0-9]{9}$")
         raise "Invalid mobile number"
      end
   	  if @@accounts_array.any?{|f| f[:mobile_no] == @mobile_no  && f[:acc_type] == @acc_type}
      	raise "Duplicate Mobile no"
			end
      # puts @account&.dig(:mobile_no)
		rescue => e
      # puts "Error #{e}"
      # puts "Enter Mobile no: "
      # @mobileNo = gets.chomp
      # retry
    end
  end
 

  def verify_name()
    
    # puts "Enter Adhar no: "
    # @adharNo = gets.chomp
    # verificationAadhar()
    # puts "Enter Mobile no: "
    # @mobileNo =gets.chomp
    # mobileNoVerification()
    # @otp = rand(1000..9999)
    # puts "Pop Up : Otp = {#@otp}"
    # puts "Enter Otp: "
    # @userOtp = Integer(gets.chomp)
    # begin
    #    if(@otp == @userOtp)
    #       puts "Aadhar card is linked with mobile! Verification Successfull" 
    #   else
    #      raise"Invalid otp"
    #   end
    # rescue => e 
    #   puts "Error #{e}"
    #   puts "Enter Otp: "
    #   @userOtp = Integer(gets.chomp)
    #   retry
    # end
    begin
      # puts "Enter Full Name: "
      # @name = gets.chomp
      unless @name.match?("/\A[a-zA-Z]+( [a-zA-Z]+)*\z/")
          raise "Please Enter First Name and Last Name"
      end
    rescue => e
      puts "Error : #{e}"
      # retry
    end
  end

  def verify_acc()
    begin
      puts "Enter Account Number: "
      acc_number = Integer(gets.chomp)
      @account = @@accounts_array.find{|a| a[:acc_no] == acc_number}
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