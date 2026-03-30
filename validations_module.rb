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
      'SELECT EXISTS (SELECT 1, bank_name, acc_type FROM users JOIN accounts on users.uuid = accounts.user_id where adhar_no = $1 AND bank_name = $2 AND acc_type = $3)',
      [@adhar_no, @bank_name, @acc_type]
    )

    if d1.values.join('') == 't'
      raise "Duplicate aadhar number"
    end
  end


  def verify_mobile
    unless @mobile_no.match?(/[1-9]{1}[0-9]{9}$/)
      raise "Invalid mobile number"
    end

    d1 = CONN.exec_params(
      'SELECT EXISTS (SELECT 1 FROM users JOIN accounts on users.uuid = accounts.user_id where mobile_no = $1 AND bank_name = $2 AND acc_type = $3)',
      [@mobile_no, @bank_name, @acc_type]
    )
   
    if d1.values.join('') == 't'
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
        'SELECT * FROM accounts JOIN users on accounts.user_id = users.uuid WHERE acc_no = $1', 
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

  def insert_records
    begin
			result = CONN.exec(
				'SELECT * FROM users where adhar_no = $1',
				[@adhar_no]
			)
			if result.values.empty? == false

				bank_id =  CONN.exec(
					'SELECT bank_id FROM bank WHERE bank_name = $1',
					[@bank_name.upcase]
				)
				user_id = result[0]['uuid']
				puts user_id
				bid = bank_id.values.join('').to_i
				@acc_no = rand(10000000..99999999)
				@acc_no.to_s
				puts "Congratulations!!!! Account Successfully Opened"
				puts "Note down your account number: #{@acc_no}"
				CONN.exec_params(
					'INSERT INTO accounts( acc_type, acc_no, balance, user_id, bank_id) VALUES ($1, $2, $3, $4 , $5)',
					[@acc_type, @acc_no, @balance, user_id ,bid ] 
				)

			else

				CONN.exec_params(
					'INSERT INTO users (adhar_no, mobile_no, name, initial_bal, pass, bank_name) VALUES ($1, $2 , $3, $4, $5, $6)',
					[@adhar_no, @mobile_no, @name, @initial_bal, @pass , @bank_name]
				)
				puts 'Insert successful.'
				user_id = CONN.exec_params(
      		'SELECT uuid FROM users WHERE adhar_no = $1',
      			[@adhar_no]
      		) 
				uid = user_id.values.join('')

     		bank_id = CONN.exec_params(
      		'SELECT bank_id FROM bank WHERE bank_name = $1',
      		[@bank_name.upcase]
      		)
			  bid = bank_id.values.join('').to_i
				@acc_no = rand(10000000..99999999)
				@acc_no.to_s
				puts "Congratulations!!!! Account Successfully Opened"
				puts "Note down your account number: #{@acc_no}"

				CONN.exec_params(
					'INSERT INTO accounts( acc_type, acc_no, balance, user_id, bank_id) VALUES ($1, $2, $3, $4 , $5)',
					[@acc_type, @acc_no, @balance, uid , bid] 
				)
			end
		rescue PG::Error => e
				puts "Error: #{e.message}"
		end


  end
end    
