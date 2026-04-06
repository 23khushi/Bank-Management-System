require_relative './Account_Validation.rb'
require_relative './Account.rb'
require_relative './Queries_Module.rb'
require_relative './transaction.rb'


class Transaction
  include Fire_Queries
  def transfer(source_accno, destination_accno, source_ifsc_code, destination_ifsc_code, transfer_amount)
    begin
     
      @source_account = CONN.exec_params(
      'SELECT accounts.acc_no, accounts.ifsc_code, users.name, accounts.balance FROM accounts JOIN users on  accounts.user_id = users.uuid WHERE accounts.acc_no = $1 AND accounts.ifsc_code = $2 AND accounts.deleted_on IS NULL', 
      [source_accno, source_ifsc_code]
      )


      if @source_account.values.empty?
        raise " Source Account does not exist"
      end
     

      @destination_account = CONN.exec_params(
        'SELECT accounts.acc_no, accounts.ifsc_code, users.name, accounts.balance FROM accounts JOIN users on  accounts.user_id = users.uuid WHERE accounts.acc_no = $1 AND accounts.ifsc_code = $2 AND accounts.deleted_on IS NULL', 
        [destination_accno, destination_ifsc_code]
      )


      if @destination_account.values.empty?
        raise "Destination Account does not exist"
      end

      raise "Cannot transfer to self" if source_accno == destination_accno

      raise "Invalid amount" if transfer_amount < 0 || transfer_amount > @source_account[0]['balance'].to_i

      debit = @source_account[0]['balance'].to_i
      debit -= transfer_amount 
      update_query('accounts', {balance: debit}, {acc_no: source_accno})

      credit = @destination_account[0]['balance'].to_i
      credit += transfer_amount
      update_query('accounts', {balance: credit}, {acc_no: destination_accno})

    rescue => e
      puts "Error #{e}" 
    end
    
    insert_transaction_details
    puts "Transaction Successful"
  end

private
  def insert_transaction_details
    begin
      source_details =   @source_account.values.flatten
      destination_details = @destination_account.values.flatten
      transaction_id = rand(100000000000..999999999999)

      unless @source_account.values.empty? || @destination_account.values.empty?
        insert_query('transactions', ['id', 'source_accno', 'source_ifsc', 'source_name', 'destination_accno', 'destination_ifsc', 'destination_name', 'timings'], 
        {id: transaction_id, source_accno: source_details[0], source_ifsc: source_details[1], source_name: source_details[2], destination_accno: destination_details[0], destination_ifsc: destination_details[1], destination_name: destination_details[2], timings: 'NOW()'})
      end
    rescue => e
      puts "Error #{e}"
    end  

  end 
end
