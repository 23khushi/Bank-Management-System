require_relative './database.rb'

module User_Validations
  
   OTP = "1234" 

   # BANK NAME VERIFICATION
   def verify_bank_name
    bank_name = @bank_name.upcase
    unless bank_name == "HDFC" || bank_name == "ICICI"
      raise "Invalid Bank Name"
    end
  end

  # OTP VERIFICATION TO OPEN ACCOUNT
  def verify_otp
    unless @acc_otp == User_Validations::OTP
      raise "Invalid OTP"
    end
  end


  # AADHAR VERIFICATION
  def verify_aadhar  
    unless @adhar_no.match?(/^[2-9]\d{11}$/)
      raise "Invalid aadhar Number"
    end

    d1 = CONN.exec_params(
      'SELECT EXISTS (SELECT 1 FROM users JOIN accounts on users.uuid = accounts.user_id JOIN bank on accounts.bank_id = bank.bank_id WHERE users.adhar_no = $1 AND bank.bank_name = $2 AND accounts.acc_type = $3)',
      [@adhar_no, @bank_name, @acc_type]
    )

    if d1.values.join('') == 't'
      raise "Duplicate aadhar number"
    end
  end


  # MOBILE VERIFICATION
  def verify_mobile
    unless @mobile_no.match?(/[1-9]{1}[0-9]{9}$/)
      raise "Invalid mobile number"
    end

    d1 = CONN.exec_params(
      'SELECT EXISTS (SELECT 1 FROM users JOIN accounts on users.uuid = accounts.user_id JOIN bank on accounts.bank_id = bank.bank_id WHERE users.mobile_no = $1 AND bank.bank_name = $2 AND accounts.acc_type = $3)',
      [@mobile_no, @bank_name, @acc_type]
    )
   
    if d1.values.join('') == 't'
      raise "Duplicate mobile number"
    end
  end
 

  # NAME VERIFICATION
  def verify_name
    unless @name.match?(/\A[a-zA-Z]+\s([a-zA-Z]+)*\z/)
      raise "Please Enter First Name and Last Name #{@name}"
    end
  end


  # INITAL BALANCE VERIFIATION
  def verify_initial_balance
    if @initial_bal < 100 && @acc_type == "Saving"
      raise "Initial Balance for Saving Account must be 100 or above"
    elsif @initial_bal < 500 && @acc_type == "Current"
      raise "Initial Balance for Current Account must be 500 or above"
    end
  end

 # PASSWORD VERIFICATION
  def verify_pass
    unless @pass.match(/\A\d+\z/)
      raise "Invalid input for password"
    end
    if @pass.length != 4 
      raise "Password must be of only 4 digits!!"
    end
  end


  # ACCOUNT VERIFICATION
  def verify_acc
    begin
      puts "Enter Account Number: "
      @acc_number = gets.chomp.to_i

      @account = CONN.exec_params(
        'SELECT * FROM accounts JOIN users on accounts.user_id = users.uuid WHERE accounts.acc_no = $1 AND accounts.deleted_on IS NULL', 
        [@acc_number]
      )

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

  # VERIFICATION FOR SHOWING ALL ACCOUNTS OF SPECIFIC USER
  def verify_user_accounts
    begin
      puts "Enter aadhar no"
      adhar = gets.chomp
      unless adhar.match?(/^[2-9]\d{11}$/)
        raise "Invalid aadhar Number"
      end
    rescue => e
      puts "Error: #{e}"
      retry
    end
    @aadhar_card = select_query(['adhar_no'], 'users', {adhar_no: adhar})
    if @aadhar_card
      return @aadhar_card.getvalue(0,0)
    else
      raise "Does not exist in our database"
    end

  end
  
end    
