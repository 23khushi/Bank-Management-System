require_relative './database.rb'
require_relative './Queries_Module.rb'
require_relative './Account_Validation.rb'

require 'terminal-table'

class Account 
	include Account_Validation
	include Fire_Queries
	attr_accessor :otp
	attr_reader :balance, :acc_no, :ifsc_code, :uuid, :bank_id



	# SHOW BALANCE
	def show_balance
		acc = verify_acc
		if acc
			perform_balance(acc)  
		end
	end

	# DELETE ACCOUNT
	def delete_account
		acc = verify_acc
		if acc
			perform_delete(acc)
		end
	end

	# UPDATE ACCOUNT
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


   #SHOW ALL ACCOUNTS
  def show_user_accounts
	begin
		accounts = verify_user_accounts
		if accounts
			show_all_accounts(accounts)
		end
	rescue => e
		puts "Error: #{e}"
	end
end


	# PRIVATE SHOW BALANCE
	def perform_balance(acc)
	  bal = select_query(['balance'], 'accounts', {acc_no: @acc_number})
	  puts "Total Balance : #{bal.getvalue(0,0)}" 
	end

	# PRIVATE DELETE ACCOUNT
	def perform_delete(acc)
	  begin
	    delete_query
	    puts "Account deleted for account no #{@acc_number}"
	  rescue PG::Error => e
	    puts "Error: #{e.message}"
	  end
	end

	# PRIVATE UPDATE ACCOUNT
	def perform_update(acc,type)
	  begin
	    if(type == 1)
	      puts "Enter aadhar number: "
	      @adhar_no = gets.chomp
	      if @adhar_no == acc[0]['adhar_no']
	        puts "Same as existing aadhar number"
	      end
	      verify_aadhar
			  update_query('users', {adhar_no: @adhar_no}, {acc_no: @acc_number},'FROM accounts', 'users.uuid = accounts.user_id')
	      puts "Updated aadhar no successfully!"
					
	    elsif(type == 2)
	      puts "Enter mobile number"
	      @mobile_no = gets.chomp
	      if @mobile_no == acc[0]['mobile_no']
	        puts "Same as existing mobile number"
	      end
	      verify_mobile
	      update_query('users', {mobile_no: @mobile_no}, {acc_no: @acc_number},'FROM accounts', 'users.uuid = accounts.user_id')
	      puts "Updated mobile no successfully!"
	    elsif(type == 3)
	      puts "Enter which account you want to switch: 
	      \n1)Saving Account
	      \n2)Current Account"
	      switch_type = Integer(gets.chomp)
	      if(switch_type == 1)
	        if acc[0]['acc_type'] ==  "Saving"
	          puts "Same as existing account"
	        end
			    update_query('accounts', {acc_type: 'Saving'}, {acc_no: @acc_number})
	        puts "Updated to Saving Account"
	      elsif(switch_type == 2)
	        if acc[0]['acc_type'] ==  "Current"
	          puts "Same as existing account"
	        end
	        update_query('accounts', {acc_type: 'Current'}, {acc_no: @acc_number})
	        puts "Updated to Current Account"
	      end
	    end
	  rescue => e
	    puts "Error: #{e}"
	  end  
	end

	#PRIVATE USERS ALL ACCOUNTS.
	def show_all_accounts(aadhar_card)
		users_acc = CONN.exec_params(
			'SELECT users.name, accounts.acc_type, bank.bank_name FROM users JOIN accounts on users.uuid = accounts.user_id JOIN bank ON accounts.bank_id = bank.bank_id WHERE users.adhar_no = $1 AND accounts.deleted_on IS NULL',
			[@aadhar_card.getvalue(0,0)]
		)
		rows = []
		rows = users_acc.values.each do |row|
	 		rows << [row[0],row[1],row[3]]
		end
		table = Terminal::Table.new(
			headings: ["Name" , "Account type", "Bank name"],
			rows: rows
		)
		puts table
	end	
end