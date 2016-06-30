PG Migrator
===========

[![Gem Version](https://badge.fury.io/rb/pg_migrator.svg)](https://badge.fury.io/rb/pg_migrator)
[![Build Status](https://travis-ci.org/pyer/pg_migrator.svg?branch=master)](https://travis-ci.org/pyer/pg_migrator)

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

Migration SQL scripts are stored in a directory compliant with two configuration parameters, upgrade and downgrade.
Default directory is 'migrations'.
Upgrade and downgrade SQL script file names must be compliant with upgrade and downgrade parameters in the configuration file.
Version number is text between the last character '/' and next character '\_' in script file name.
An empty newly created database is in version set by version0 parameter.
Several files can have the same version number.

Version number can be 000, 0.1.1, 0.09, 1.2a or any other text.
Next version number is given by #next method of String object.
Beware, next version of 1.9 is 2.0 and next version of 1.09 is 1.10

Example: version 0.02

* Update parameter
    upgrade   = migrations/\*_up_\*.sql

* Script file: migrations/0.02_up_add_id_3_in_tablename.sql
    INSERT INTO tablename (id, caption) VALUES (3,'something');

* Downgrade parameter
    downgrade = migrations/\*_down_\*.sql

* Script file: migrations/0.02_down_add_id_3_in_tablename.sql
    DELETE FROM tablename WHERE id = 3;


Database requirements
---------------------

* For now, database engine MUST BE Postgres.
* The database MUST NOT have a table called 'migrations'.
* Database version is the version of the last database upgrade, stored in the 'migrations' table.
* Downgrade are not logged in migrations table.


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
