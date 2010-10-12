# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_1.8.7_session',
  :secret      => '30dc1769669d08ae352f2e1c5edfc9105a5f9286e03e890f7465874386282ec17ed04ba5d9dd6b40c3adc5f8e206b8756492edbd8a47f7df427e0e21e44b071b'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
