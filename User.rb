 require_relative './bank_valid.rb'
# require_relative '/home/user/Documents/BankingSystem main/BankingSystem/BankingSystem/bankvalid/Bank_Validation.rb'
require_relative './User_Validation.rb'
require_relative './Queries_Module.rb'
require_relative './Account_Validation.rb'

class User
    include User_Validations
	include BankValid
	include Account_Validation
	# include ::Bank_Validation
	include Fire_Queries
    attr_accessor :name, :pass, :mobile_no,  :adhar_no, :acc_type, :acc_otp, :initial_bal
    attr_reader :bank_name, :ifsc_code
    def create_account(user)
		begin
			@acc_type = user[:acc_type]
			acc_type_verify
			puts "hi account verify"
			@bank_name = user[:bank_name]
			puts " hi banklifgnd"
			verify_bank_name
			puts "Hi bank_name"
			@ifsc_code = user[:ifsc_code]
			verify_ifsc_code
			puts "Hi ifsc_code"
			@adhar_no = user[:adhar_no]
			verify_aadhar
			puts "Hi addhar"
			@mobile_no = user[:mobile_no]
			verify_mobile
			puts "Hi mobile"
			@name = user[:name]
			verify_name
			puts "Hi name"
			@initial_bal = user[:initial_bal]
			verify_initial_balance
			puts "Hi initial bal"
			@pass = user[:pass]
			verify_pass
			puts "Hi pass"
			@balance = @initial_bal
			@acc_otp = user[:acc_otp]
			verify_otp
			puts "Hi otp"
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
			ifsc = select_query(['ifsc_code'], 'bank', {ifsc_code: @ifsc_code})
			user_id = result.getvalue(0,1)
			code = ifsc.getvalue(0,0)

			generate_account_number
			insert_query('accounts', ['acc_type', 'acc_no', 'balance', 'user_id', 'ifsc_code'], {acc_type: @acc_type, acc_no: @acc_no, balance: @balance, user_id: user_id, ifsc_code: code} )
			puts "Congratulations!!!! Account Successfully Opened"
			puts "Note down your account number: #{@acc_no}"
		else
			insert_query('users' , ['adhar_no', 'mobile_no', 'name', 'initial_bal', 'pass', 'bank_name'], {adhar_no: @adhar_no, mobile_no: @mobile_no, name: @name, initial_bal: @initial_bal, pass: @pass , bank_name: @bank_name})
			puts 'User Inserted Successfully.'
			user_id = select_query(['uuid'], 'users' , {adhar_no: @adhar_no})
     		ifsc = select_query(['ifsc_code'], 'bank', {ifsc: @ifsc_code})
			generate_account_number
			insert_query('accounts',['acc_type', 'acc_no', 'balance', 'user_id', 'bank_id'], {acc_type: @acc_type, acc_no: @acc_no, balance: @balance, user_id: user_id.getvalue(0,0) , bank_id: ifsc.getvalue(0,0)})
			puts "Congratulations!!!! Account Successfully Opened"
			puts "Note down your account number: #{@acc_no}"
		end
	rescue PG::Error => e
		puts "Error: #{e.message}"
	end
  end
end    