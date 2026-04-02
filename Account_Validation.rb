require_relative './database.rb'
require_relative './Account.rb'

module Account_Validation
 TYPE = ['saving' , 'current']

# Account Type Verification
  def acc_type_verify
    type = @acc_type.downcase
    unless TYPE.include?(type)
      raise "Invalid account type"
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


  # GENERATE ACCOUNT NUMBER
  def generate_account_number
    begin
		@acc_no = rand(10000000..99999999)
        duplicate_account_no?(acc_no)
		@acc_no.to_s
	rescue => e
		puts "Error: #{e}"
	retry	
	end
  end

   # VALIDATION FOR ACCOUNT NO
  def duplicate_account_no?(acc_no)
    data = select_query(['acc_no'], 'accounts', {acc_no: @acc_no})
    puts data.values
    if !data.values.empty?
      raise "Duplicate account number"
    end 
  end   
end