require 'minitest/autorun'
require_relative './Bank'
require_relative './Account'
# require_relative './main'


class BankTestCase < Minitest::Test
 attr_accessor :accounts

  @@accounts = [
  { adhar_no: "555555555555",
    mobile_no: "2222222222",
    name: "Khushi Solanki", 
    acc_type: "Saving",
    acc_no: "0", 
    balance: 500,
    pass: "2222"
  },
  { adhar_no: "555555555555",
    mobile_no: "2222222222",
    name: "Khushi Solanki", 
    acc_type: "Current",
    acc_no: "0", 
    balance: 1000,
    pass: "3333" 
  }
] 

  def setup 
    @obj = Account.new
  end


  def test_acc_type_saving
    result = @obj.create_account(@@accounts[0])
    puts "#{result}"
    @@accounts[0][:acc_no] = result[0][:acc_no]
    puts "#{@@accounts[0]}"
    assert_equal @@accounts[0] , result[0]
  end

  def test_acc_type_current
    result = @obj.create_account(@@accounts[1])
    puts "#{result}"
    @@accounts[1][:acc_no] = result[1][:acc_no]
    puts "#{@@accounts[1]}"
    assert_equal @@accounts[1] , result[1]
  end





  # def test_deposit_current
  #   puts "#{@result}"
  #   # @acc_number = @result[1][:acc_no]
  #   # puts "#{@acc_number}"
  # end



  
end

