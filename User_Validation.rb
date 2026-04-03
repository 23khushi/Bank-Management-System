require_relative './database.rb'
require_relative './User.rb'
module User_Validations
  
  # OTP VERIFICATION TO OPEN ACCOUNT
  def verify_otp
    account_otp = "1234"
    unless @acc_otp == account_otp
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
    if d1.values.flatten.first == 't'
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
  
    if d1.values.flatten.first == 't'
      raise 'Duplicate mobile number'
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
 
end    
