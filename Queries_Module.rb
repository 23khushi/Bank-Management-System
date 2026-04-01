require_relative './database.rb'

module Fire_Queries
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
    
 # SELECT QUERY
  def select_query(column, table_name, condition)
	query = "SELECT #{column.join(', ')} FROM #{ table_name}" 
	values = []

	if condition.any?
		where_clause = condition.keys.each_with_index.map do |key, index|
			values << condition[key]
			"#{key} = $#{index + 1}"
		end.join(" AND ")

		query += " WHERE #{where_clause}"

		CONN.exec_params(query,values)
  	end 
  end 

  # UPDATE QUERY
  def update_query(table_name, update, condition, join_clause = nil, extra = nil)
	value = []
	set_column = update.keys.each_with_index.map do |key, index|
		value << update[key]
		"#{key} = $#{index + 1}"
	end.join(", ")
	
	query = "UPDATE #{table_name} SET #{set_column}" 


	query += " #{join_clause }" if join_clause
	if condition.any?
		where_clause = condition.keys.each_with_index.map do |key, index|
			value << condition[key]
			"#{key} = $#{update.length + index +1}"
		end.join(" AND ")
		query += " WHERE #{where_clause}"
		query += " AND #{extra}" if extra
	end
	
	CONN.exec_params(query,value)
  end


 # SOFT DELETE QUERY
  def delete_query
	# query = "UPDATE users SET deleted_on = NOW() FROM accounts WHERE users.uuid = accounts.user_id AND acc_no = $1"
	# CONN.exec_params(query, [@acc_number])
	query = "UPDATE accounts SET deleted_on = NOW() FROM users WHERE users.uuid = accounts.user_id AND acc_no = $1"
	CONN.exec_params(query, [@acc_number])
	
  end	

  # INSERT QUERY
  def insert_query(table_name, column, data)
	value = []
	query = "INSERT INTO #{table_name} (#{column.join(', ')}) "

	data_value = 
		data.keys.each_with_index.map do |key, index|
		value << data[key]
		"$#{index + 1}"
	end. join(', ')
	query += "VALUES (#{data_value})" 
	CONN.exec_params(query, value)
  end	
end