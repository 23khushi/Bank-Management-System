require_relative 'User_Validation'

class Users
    include User_Validations
    attr_accessor :name, :pass, :mobile_no,  :adhar_no, :acc_type, :acc_otp, :initial_bal
    attr_reader :bank_name, :ifsc_code
    def create_account(user)
		begin
			@acc_type = user[:acc_type]
			acc_type_verify
			@bank_name = user[:bank_name]
			verify_bank_name
			@adhar_no = user[:adhar_no]
			verify_aadhar
			@mobile_no = user[:mobile_no]
			verify_mobile
			@name = user[:name]
			verify_name
			@initial_bal = user[:initial_bal]
			verify_initial_balance
			@pass = user[:pass]
			verify_pass
			@balance = @initial_bal
			@acc_otp = user[:acc_otp]
			verify_otp
			
			insert_records
			
		rescue => e
			puts "Account creation failed: #{e}"
		end
	end

    # INSERTING RECORDS IN TABLE
  def insert_records
    begin
     	result = select_query(['adhar_no', 'uuid'], 'users', {adhar_no: @adhar_no})
		if !(result.ntuples == 0)
			bank_id = select_query(['bank_id'], 'bank', {bank_name: @bank_name})
			user_id = result.getvalue(0,1)
			bid = bank_id.getvalue(0,0)

			generate_account_number
			insert_query('accounts', ['acc_type', 'acc_no', 'balance', 'user_id', 'bank_id'], {acc_type: @acc_type, acc_no: @acc_no, balance: @balance, user_id: user_id, bank_id: bid} )
			puts "Congratulations!!!! Account Successfully Opened"
			puts "Note down your account number: #{@acc_no}"
		else
			insert_query('users' , ['adhar_no', 'mobile_no', 'name', 'initial_bal', 'pass', 'bank_name'], {adhar_no: @adhar_no, mobile_no: @mobile_no, name: @name, initial_bal: @initial_bal, pass: @pass , bank_name: @bank_name})
			puts 'User Inserted Successfully.'
			user_id = select_query(['uuid'], 'users' , {adhar_no: @adhar_no})
     		bank_id = select_query(['bank_id'], 'bank', {bank_name: @bank_name})
			generate_account_number
			insert_query('accounts',['acc_type', 'acc_no', 'balance', 'user_id', 'bank_id'], {acc_type: @acc_type, acc_no: @acc_no, balance: @balance, user_id: user_id.getvalue(0,0) , bank_id: bank_id.getvalue(0,0)})
			puts "Congratulations!!!! Account Successfully Opened"
			puts "Note down your account number: #{@acc_no}"
		end
	rescue PG::Error => e
				puts "Error: #{e.message}"
	end
  end
end    