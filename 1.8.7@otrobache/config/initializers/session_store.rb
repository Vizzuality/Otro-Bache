# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_1.8.7@otrobache_session',
  :secret      => 'fc37b046edd235a722aff243469792a23ce4aca9c268f526c616dcd80c252d22c19668f4d817fa53e453e8c3880ee0ed67443d1cfc61214450c678059cf1a781'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
