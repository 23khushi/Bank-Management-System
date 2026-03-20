require 'minitest/autorun'
require_relative './Bank'
require_relative './Account'
# require_relative './main'

class BankTestCase < Minitest::Test

  account = [
    {
    adharNo: 111111111111,
    mobileNo: 2222222222,
    name: "Khushi Solanki", 
    accType:"Saving",
    acc_no: 0, 
    balance:500,
    pass: 2222
},
  { adharNo: 111111111111,
    mobileNo: 2222222222,
    name: "Khushi Solanki", 
    accType:"Current",
    acc_no: 0, 
    balance:1000,
    pass: 3333 
  }
  ]

  def setup 
    obj = Account.new
    
  end


  def test_accType_saving
    puts @obj.object_id
    result = @obj.accTypeMethod()
    # puts result.class
    dummy = result.to_a
    saving_acc = dummy.find{|acc| acc[:accType] == "Saving"}
    @@account[0][:acc_no] = saving_acc[:acc_no]
   # @@account.to_a
    puts @@account
    puts dummy
    assert_equal @@account[0] , dummy[0]
  end

  def test_accType_current
    puts @obj.object_id
    result = @obj.accTypeMethod()
    # puts result.class
    dummy = result.to_a
    current_acc = dummy.find{|acc| acc[:accType] == "Current"}
    #puts @@account
    @@account[1][:acc_no] = current_acc[:acc_no]
    # puts dummy[1][:acc_no]
    # puts  @@account[1][:acc_no]
   # @@account.to_a
    puts @@account
    puts dummy
    assert_equal @@account[1] , dummy[1]
  end


  def test_deposit_saving
    puts "Saving!!"
    puts "HI"
    result = @obj.depositMethod()
    puts result
    assert_equal 1000, result
  end

  def test_deposit_current
    rupees = obj.depositAmount
    dep = account[:balance]
    puts "Current!!"
    puts "HI"
    result = @obj.depositMethod()
    puts result
    assert_equal rupees+dep, result
  end

  
end

