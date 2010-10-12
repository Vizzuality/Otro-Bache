# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_1.8.7@otrobache_session',
  :secret      => '8fa5d88805842020f8efc75c02c77dd99f27dbbaebfa0a66edde47b6dd7b4a1db86c63d81a282f1b41b0c5527a487aa2997162a7437b035f65a8ae9b01a4737f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
