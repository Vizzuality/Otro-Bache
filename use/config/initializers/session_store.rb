# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_use_session',
  :secret      => '21b5543322c1498f5b3a8ab24b716ed5bfee25629a6911cc1425850d72eb7d7acd90af3d50f0d4478406692e9d35f9115dfdbec36eaaaa09b7577f0dd2e2dc39'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
