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
			puts 'User Inserted Successfully.'
			user_id = select_query(['uuid'], 'users' , {adhar_no: @adhar_no})
     		bank_id = select_query(['bank_id'], 'bank', {bank_name: @bank_name})

			@acc_no = rand(10000000..99999999)
			@acc_no.to_s
			puts "Note down your account number: #{@acc_no}"
			CONN.exec_params(
				'INSERT INTO accounts( acc_type, acc_no, balance, user_id, bank_id) VALUES ($1, $2, $3, $4 , $5)',
				[@acc_type, @acc_no, @balance, user_id.getvalue(0,0) , bank_id.getvalue(0,0)] 
			)
			puts "Accounts record Inserted Successfully"
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
end