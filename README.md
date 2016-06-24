PG Migrator
===========

This tool provides a set of Rake tasks to apply changes on different Postgres environments.

Each environment is described by a configuration file.

Host, user, database name and migration SQL scripts location are defined in the configuration file.

For example, 'config/test' is the Minitest environment used by 'rake test', 'config/uat1' and 'config/uat2' are two 'User Aceptance Testing' platforms.

'config/dev' is the default environment used for development.


'rake -T' command show the list of tasks.


Installation
------------

    wget https://github.com/pyer/pg_migrator/archive/master.zip
    unzip master.zip


Getting started
---------------

rake -T
```
rake config        # Show configuration
rake databases     # Lists the databases
rake db:create     # Creates the current database
rake db:drop       # Drops the current database
rake db:forward    # Pushes the current database to the next version
rake db:migrate    # Migrate the current database to the last version
rake db:rollback   # Rolls the current database back to the previous version
rake environments  # Show environments
rake migrations    # Lists the current database migrations
rake test          # Run tests
rake version       # Retrieves the current database version number
```

Options
-------

'-s' or '-q' Rake options also suppresse pg_migrator messages.

'-v' verbose is default mode


Requirements
------------

For now, database engine MUST BE Postgres.

The database MUST NOT have a table called 'migrations'.

Sorting order of script file names is the version order. So, file names are importants.


Examples
--------

Show configuration of the 'uat2' environment
```
rake config env=uat2
```

Migrate the 'uat1' environment in silent mode
```
rake db:migrate env=uat1 -s
```

Show the list of migrations of the 'dev' environment
```
rake migrations
```




Format of environment file
--------------------------

dev example:
    database = pyer_dev
    host     = localhost
    port     = 5432
    username = pba
    password = pba
    encoding = utf8
    pattern  = migrations/*.rb


Format of migration file
------------------------

* File name: xyz_comment.rb

    path is 'migrations/xyz_comment.rb'
    xyz is the version number: '000' to '999' or '0.0a' to '9.9z'
    version number is extracted from the path name between '/' and '_' characters
    comment is a little description of the version


* Example: 002_add_id_3_in_tablename.rb

    @up   = "INSERT INTO tablename (id, caption) VALUES (3,'something');"
    @down = "DELETE FROM tablename WHERE id = 3;"

