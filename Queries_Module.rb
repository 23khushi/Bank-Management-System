require_relative './database.rb'

module Fire_Queries
	
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