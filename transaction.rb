require_relative './Account_Validation.rb'
require_relative './Account.rb'
require_relative './Queries_Module.rb'
require_relative './transaction.rb'
require 'securerandom'

class Transaction

  include Fire_Queries
  def transfer(source_accno: ,destination_accno: , transfer_amount:) 
      @transfer_amount = transfer_amount.to_i
      CONN.transaction do
        raise "Cannot transfer to self" if source_accno == destination_accno

        @source_account = CONN.exec_params(
        'SELECT accounts.acc_no, accounts.ifsc_code, users.name, accounts.balance FROM accounts JOIN users on 
         accounts.user_id = users.uuid WHERE accounts.acc_no = $1 AND accounts.deleted_on IS NULL', 
        [source_accno]
        )
         if @source_account.values.empty?
          raise "Source Account does not exist for account number:  #{source_accno}"
        end


        raise "Not Enough Balance! for account number : #{source_accno}" if (@transfer_amount <= 0) || (@transfer_amount > @source_account[0]['balance'].to_i)
         
        @destination_account = CONN.exec_params(
          'SELECT accounts.acc_no, accounts.ifsc_code, users.name, accounts.balance FROM accounts JOIN users on  accounts.user_id = users.uuid
           WHERE accounts.acc_no = $1 AND accounts.deleted_on IS NULL', 
          [destination_accno]
        )
      
      
        if @destination_account.values.empty?
          raise "Destination Account does not exist for account number: #{destination_accno}"
        end
      
        source_balance = @source_account[0]['balance'].to_i
        source_balance -= @transfer_amount 
        update_query('accounts', {balance: source_balance}, {acc_no: source_accno})
      
        destination_balance = @destination_account[0]['balance'].to_i
        destination_balance += @transfer_amount
        update_query('accounts', {balance: destination_balance}, {acc_no: destination_accno})
        # CONN.exec_params("BEGIN")
        insert_transaction_details
        # CONN.exec_params("COMMIT")
        puts "Transaction Successful!"
    end 
  end



private
  def insert_transaction_details
    begin
      source_details =   @source_account.values.flatten
      destination_details = @destination_account.values.flatten
      #p @transfer_amount
      unless @source_account.values.empty? || @destination_account.values.empty?
        insert_query('transactions', ['source_accno', 'source_ifsc', 'source_name', 'destination_accno', 'destination_ifsc', 'destination_name', 'amount',  'transaction_timing'], 
        {source_accno: source_details[0], source_ifsc: source_details[1], source_name: source_details[2], destination_accno: destination_details[0], destination_ifsc: destination_details[1], destination_name: destination_details[2], amount: @transfer_amount, transaction_timing: 'NOW()'})
       end
      end
    rescue => e
      puts "Error #{e}"
    end  

  end 
