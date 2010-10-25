OTRO-BACHE
----------

Requirements
------------

- Ruby 1.8.7
- PostgreSQL 8.4 or higher.
- [Postgis 1.5.2][1]
- [Bundler][2] gem

Installation
------------
First of all, rename the file config/database.yml.sample

    mv config/database.yml.sample config/database.yml

and then, update it with your database connection parameters.

You will need to create a postgis template database. [Here][3] explain how to do it.

After that, you can proceed with the rest of the installation steps:

    bundle install
    rake db:setup

This will take a while, since 1.4 million records must be inserted in the database.

Running the app!
----------------
To run the application in your development machine, just start the server

    rails server

and load the app in your browser:

    http://localhost:3000
    
Now, time to hack and send some pull requests!


[1]: http://postgis.refractions.net/
[2]: http://github.com/carlhuda/bundler
[3]: http://www.lincolnritter.com/blog/2007/12/04/installing-postgresql-postgis-and-more-on-os-x-leopard/