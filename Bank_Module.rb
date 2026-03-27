require_relative './validations_module.rb'
require_relative './database.rb'

module Bank
    include User_Validations
    HDFC = "HDFC0000148"
    ICICI = "ICIC0000424"

end