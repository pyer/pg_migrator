PG Migrator
===========

* This tool provides a set of Rake tasks to apply changes on different Postgres environments.
* Every change, upgrade or rollback, is versionned.
* Each environment is described by a configuration file.
* Host, user, database name and migration SQL scripts location are defined in the configuration file.
* For example, 'config/uat' is a 'User Aceptance Testing' environment.
* 'config/dev' is the default environment used for development.


Installation
------------

* gem install pg_migrator


Getting started
---------------

* Create a minimal Rakefile as below, in an empty directory
* 'rake -T' displays the available tasks
* 'rake config' displays current configuration and creates minimal 'config' file if none
* Fill in correct values in 'config/dev' file
* Add other 'config' files as you need


Minimal Rakefile
----------------

        require 'pg_migrator'
        PGMigrator.new


Configuration
-------------

* See 'config/dev' file.
* Every environment configuration file is built on the same template.
* The name of each environment is its configuration file name.
* Environment is select by the option 'env=name'. See examples below.


Migrations script files
-----------------------

Migration SQL scripts are stored in a directory compliant with the pattern configuration parameter.
Default directory is 'migrations'.
Each file initialize two variables '@up' and '@down' used to upgrade and rollback the database.
Version number is the first 3 digits of the script file name.
Script file names must be compliant with the pattern parameter and the 'xyz_comment.rb' format where xyz is the version number from '001' to '999'.
An empty newly created database is in version '000'.
Several files can have the same version number.

Example: 'migrations/002_add_id_3_in_tablename.rb'

    @up   = "INSERT INTO tablename (id, caption) VALUES (3,'something');"
    @down = "DELETE FROM tablename WHERE id = 3;"


Database requirements
---------------------

* For now, database engine MUST BE Postgres.
* The database MUST NOT have a table called 'migrations'.
* Database version is the version of the last database upgrade, stored in the 'migrations' table.
* An empty database is in version '000'.

Options
-------

* '-s' or '-q' Rake options also suppresse pg_migrator messages.
* '-v' verbose is default mode


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
