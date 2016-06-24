PG Migrator
===========

* This tool provides a set of Rake tasks to apply changes on different Postgres environments.
* Every change, upgrade or rollback, is versionned.
* Each environment is described by a configuration file.
* Host, user, database name and migration SQL scripts location are defined in the configuration file.
* For example, 'config/test' is the Minitest environment used by 'rake test', 'config/uat' is a 'User Aceptance Testing' environment.
* 'config/dev' is the default environment used for development.


Installation
------------

    wget https://github.com/pyer/pg_migrator/archive/master.zip
    unzip master.zip


Getting started
---------------

rake -T

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


Configuration
-------------

See files in config folder.


Versionning
-----------

Migration SQL scripts are selected by the pattern configuration parameter, the script version, the database version and the task.
Script version is the first 3 digits of the script file name.
Database version is the version of the last database upgrade, stored in the 'migrations' table.

Script file names must be compliant with the pattern parameter and the 'xyz_comment.rb' format where xyz is the vrsion number from 000 to 999.
Several files can have the same version number.

Example: 002_add_id_3_in_tablename.rb

    @up   = "INSERT INTO tablename (id, caption) VALUES (3,'something');"
    @down = "DELETE FROM tablename WHERE id = 3;"


See 'test/migrations' files for other examples.


Options
-------

'-s' or '-q' Rake options also suppresse pg_migrator messages.

'-v' verbose is default mode


Requirements
------------

For now, database engine MUST BE Postgres.

The database MUST NOT have a table called 'migrations'.


Usage examples
--------------

Show configuration of the 'uat' environment
```
rake config env=uat
```

Migrate the 'uat' environment in silent mode
```
rake db:migrate env=uat -s
```

Show the list of migrations of the 'dev' environment
```
rake migrations
```
