# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_1.8.7@otrobache_session',
  :secret      => 'fcfe519dd929fc1d2f7c895ad312baedc0a96640cf40fe2fb00165a2315de63363eeb5f65d4f9348df9c1fb84e428b40950b83420cd60a257403618f98ea1065'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
