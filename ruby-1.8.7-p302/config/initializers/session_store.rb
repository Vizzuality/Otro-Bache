# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ruby-1.8.7-p302_session',
  :secret      => '72a6176ad2a3ada9e9c66527a4e8cea9094c2aaf19fb1653cdadf82e480c3de1f73426801e8b2a9d3c170b1e5466b025a48971c9bcd8ad98ed5bcc3baccd8b97'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
