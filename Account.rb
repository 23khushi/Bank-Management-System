require_relative './database.rb'
require_relative './Bank_Module.rb'
class Account 
	include Bank
	attr_accessor :name, :pass, :mobile_no, :otp, :adhar_no, :acc_type, :acc_otp, :initial_bal
	attr_reader :balance, :acc_no, :bank_name, :ifsc_code, :uuid, :bank_id

	def create_account(user)
		begin
			@acc_type = user[:acc_type]
			@adhar_no = user[:adhar_no]
			verify_aadhar
			@mobile_no = user[:mobile_no]
			verify_mobile
			@name = user[:name]
			verify_name
			@bank_name = user[:bank_name]
			verify_bank_name
			@initial_bal = user[:initial_bal]
			verify_initial_balance
			@pass = user[:pass]
			verify_pass
			@balance = @initial_bal
			@acc_otp = user[:acc_otp]
				verify_otp
			
			if @bank_name.upcase == "HDFC"
					ifsc_code = Bank::HDFC
			elsif @bank_name.upcase == "ICICI"
					ifsc_code = Bank::ICICI
			end

			
			begin
					CONN.exec_params(
						'INSERT INTO users (adhar_no, mobile_no, name, initial_bal, pass, bank_name, acc_type) VALUES ($1, $2 , $3, $4, $5, $6, $7)',
						[@adhar_no, @mobile_no, @name, @initial_bal, @pass , @bank_name, @acc_type]
					)
					puts 'Insert successful.'

						uuid = CONN.exec_params(
        	'SELECT uuid FROM users WHERE adhar_no = $1',
        	[@adhar_no]
      	) 



				u = uuid.values.join('').to_i
					
					CONN.exec_params(
						'INSERT INTO bank (bank_name , ifsc_code) VALUES ($1, $2)',
						[@bank_name, ifsc_code]
					)
   
     		bank_id = CONN.exec_params(
        	'SELECT bank_id FROM bank WHERE bank_name = $1',
        	[@bank_name]
      	)

					v = bank_id.values.join('').to_i
		

					@acc_no = rand(10000000..99999999)
					@acc_no.to_s
					puts "Congratulations!!!! Account Successfully Opened"
					puts "Note down your account number: #{@acc_no}"

					CONN.exec_params(
							'INSERT INTO accounts( acc_type, acc_no, balance, uuid, bank_id) VALUES ($1, $2, $3, $4 , $5)',
							[@acc_type, @acc_no, @balance, u , v] 
					)

			rescue PG::Error => e
					puts "Error: #{e.message}"
			end

			rescue => e
					puts "Account creation failed: #{e}"
			end
	end

	def deposit # Deposit & Withdraw  & Balance methods ko private banakar handle kro
			acc = verify_acc
			begin
					if acc
							puts "Enter Amount"
							amount = gets.chomp.to_i
							perform_deposit(acc, amount)
					end
			rescue => e
					puts "Error: Invalid Amount"
			end
	end

	def withdraw
			acc = verify_acc
			begin
					if acc
							puts "Enter Amount"
							amount = gets.chomp.to_i
							perform_withdraw(acc , amount)
					end
			rescue => e
					puts "Error: Invalid Amount"
			end
	end   


	def show_balance
			acc = verify_acc
			if acc
				perform_balance(acc)  
			end
	end

	def delete_account
			acc = verify_acc
			if acc
					perform_delete(acc)
			end
	end

	def update_account
			acc = verify_acc
			begin
					if acc
							puts "Enter the element you want to update
							\n1)aadhar Number
							\n2)Mobile Number
							\n3)Account Type"
							type = Integer(gets.chomp)
							perform_update(acc, type)
					end
			rescue ArgumentError
					puts "Please enter valid input "
			end
	end



	private
	# def perform_deposit(acc , deposit_amount)
	#     begin
	#         amount =  @account[0]['balance']
	#         amt =  amount.to_i
	#         if deposit_amount <= 0
	#             raise "Invalid Amount"
	#         else 
	#             amt = amt  + deposit_amount
	#             puts "Deposit successfully Completed! "
							
	#             # UPDATE BALANCE 
	#             CONN.exec_params(
	#                 'UPDATE users SET balance = $1 where acc_no = $2',
	#                 [amt,@acc_number]
	#             )
	#             puts "Updated Successfully! "
	#             puts "Total Balance: #{amt}"
	#         end
	#     rescue => e
	#         puts "Error: #{e}"
	#     end
	# end

	# def perform_withdraw(acc, withdraw_amount)
	#     begin
	#          amount =  @account[0]['balance']
	#          amt =  amount.to_i
	#          if withdraw_amount <= 0
	#             raise "Invalid Amount"
	#         elsif  amt < 100 || withdraw_amount >  amt
	#             raise "Oops!! Not Enough Balance"
	#         else
	#              amt =  amt - withdraw_amount
	#            CONN.exec_params(
	#                 'UPDATE users SET balance = $1 where acc_no = $2',
	#                 [amt,@acc_number]
	#             )
	#             puts "Updated Successfully! "
	#             puts "Total Balance: #{amt}"
	#         end
	#     rescue => e
	#         puts "Error: #{e}"
	#     end
	# end

	# def perform_balance(acc)
	#     bal = CONN.exec_params(
	#         'SELECT balance FROM USERS WHERE acc_no = $1',
	#         [@acc_number]
	#     )
	#     puts bal.values
	# end

	# def perform_delete(acc)
	#     begin
	#         CONN.exec_params(
	#             'DELETE FROM users WHERE acc_no = $1',
	#             [@acc_number]
	#         )
	#         puts "Account deleted for account no #{@acc_number}"
	#     rescue PG::Error => e
	#         puts "Error: #{e.message}"
	#     end
	# end

	# def perform_update(acc,type)
	#     begin
	#         if(type == 1)
	#             puts "Enter aadhar number: "
	#             @adhar_no = gets.chomp
	#             if @adhar_no == acc[0]['adhar_no']
	#                 puts "Same as existing aadhar number"
	#             end
	#             verify_aadhar
	#             CONN.exec_params(
	#                 'UPDATE users set adhar_no = $1 where acc_no = $2',
	#                 [@adhar_no, @acc_number ]
	#             )
	#             puts "Updated aadhar no successfully!"
							
	#         elsif(type == 2)
	#             puts "Enter mobile number"
	#             @mobile_no = gets.chomp
	#             if @mobile_no == acc[0]['mobile_no']
	#                 puts "Same as existing mobile number"
	#             end
	#             verify_mobile
	#              CONN.exec_params(
	#                 'UPDATE users set mobile_no = $1 where acc_no = $2',
	#                 [@mobile_no, @acc_number]
	#             ) 
	#              puts "Updated mobile no successfully!"

	#         elsif(type == 3)
	#             puts "Enter which account you want to switch: 
	#             \n1)Saving Account
	#             \n2)Current Account"
	#             switch_type = Integer(gets.chomp)
	#             if(switch_type == 1)
	#                 if acc[0]['acc_type'] ==  "Saving"
	#                     puts "Same as existing account"
	#                 end
	#                  CONN.exec_params(
	#                 'UPDATE users set acc_type = $1 where acc_no = $2',
	#                 ["Saving", @acc_number]
	#                 ) 
	#                 puts "Updated to Saving Account"
	#             elsif(switch_type == 2)
	#                 if acc[0]['acc_type'] ==  "Current"
	#                     puts "Same as existing account"
	#                 end
	#                 CONN.exec_params(
	#                 'UPDATE users set acc_type = $1 where acc_no = $2',
	#                 ["Current", @acc_number]
	#                 )   
	#                 puts "Updated to Current Account"
	#             end
	#         end
	#     rescue => e
	#         puts "Error: #{e}"
	#     end  
	# end
end