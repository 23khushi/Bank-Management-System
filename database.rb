require 'pg'

# Connect to PostgreSQL database
CONN = PG.connect(
  host: 'localhost',        # or your server IP
  port: 5432,
  dbname: 'bank_system_db',
  user: 'postgres',
  password: '2129'
)

 