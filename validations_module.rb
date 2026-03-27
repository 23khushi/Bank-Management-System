require_relative './database.rb'

module User_Validations
  
   OTP = "1234" 

   def verify_bank_name
    bank_name = @bank_name.upcase
    unless bank_name == "HDFC" || bank_name == "ICICI"
      raise "Invalid Bank Name"
    end
  end

  def verify_otp
    unless @acc_otp == User_Validations::OTP
      raise "Invalid OTP"
    end
  end


  def verify_aadhar  
    unless @adhar_no.match?(/^[2-9]\d{11}$/)
      raise "Invalid aadhar Number"
    end

    d1 = CONN.exec_params(
      'SELECT adhar_no, acc_type FROM users where adhar_no = $1 AND acc_type = $2',
      [@adhar_no, @acc_type]
    )

    if d1.values.empty? == false
      raise "Duplicate aadhar number"
    end
  end


  def verify_mobile
    unless @mobile_no.match?(/[1-9]{1}[0-9]{9}$/)
      raise "Invalid mobile number"
    end

    d1 = CONN.exec_params(
      'SELECT mobile_no, acc_type FROM users where mobile_no = $1 AND acc_type = $2',
      [@mobile_no, @acc_type]
    )

    if d1.values.empty? == false
      raise "Duplicate mobile number"
    end
  end
 

  def verify_name
    unless @name.match?(/\A[a-zA-Z]+\s([a-zA-Z]+)*\z/)
      raise "Please Enter First Name and Last Name #{@name}"
    end
  end


  def verify_initial_balance
    if @initial_bal < 100 && @acc_type == "Saving"
      raise "Initial Balance for Saving Account must be 100 or above"
    elsif @initial_bal < 500 && @acc_type == "Current"
      raise "Initial Balance for Current Account must be 500 or above"
    end
  end


  def verify_pass
    if @pass.length != 4
      raise "Password must be of only 4 digits!!"
    end
  end


  def verify_acc
    begin
      puts "Enter Account Number: "
      @acc_number = gets.chomp.to_i

      @account = CONN.exec_params(
        'SELECT * FROM users WHERE acc_no = $1',
        [@acc_number]
      )
      puts @account.values
      if @account.values.empty? == true
        puts "Account does not exist"
        return nil
      end
    rescue ArgumentError
      puts "Please Enter valid account number"
    end

    begin
      puts "Enter password"
      password = gets.chomp
      if ((@account[0]['pass'] == password))
        puts "Account Verification successfull!!"
      else
        raise "Incorrect Password or Account doesnt exist!"
      end
      @otp = rand(1000..9999)
      puts "Pop Up : Otp = #{otp}"
      puts "Enter Otp: "

      begin
        userOtp = Integer(gets.chomp)
      rescue ArgumentError
        puts "Invalid input for otp"
      end
      
      if(userOtp == otp)
        puts "Verification Successfull"
        return @account
      else
        raise "Invalid input"
      end
      
    rescue => e
      puts "Error #{e}"
      retry
    end
  end 
end    
