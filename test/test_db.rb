require 'minitest/autorun'
require './lib/config.rb'
require './lib/db.rb'

class TestDB < Minitest::Test
  @config

  def setup
    ENV['env'] = 'test'
    @config = Config.new
    DB::create(@config)
  end

  def teardown
    DB::drop(@config)
  end

  def test_database_exists
    # database is created by setup
    pg = Postgres.new(@config)
    result = pg.execute("SELECT datname FROM pg_catalog.pg_database WHERE datname='#{@config.database}';")
    pg.finish
    assert_equal(result.ntuples, 1)
  end

  def test_database_already_exists
    assert_equal(DB::create(@config), false)
  end

  def test_drop_database
    assert_equal(DB::drop(@config), true)
    assert_equal(DB::drop(@config), false)
  end

  def test_database_version
    # database is created by setup
    assert_equal(DB::version(@config), '000')
  end

  def test_unknown_database_version
    ENV['env'] = 'unknown'
    config = Config.new
    assert_equal(DB::version(config), '')
  end

  def test_database_migrations
    DB::migrate(@config)
    result = DB::migrations(@config)
    assert_equal(result.ntuples, 3)
    assert_equal(result.getvalue(0,0), '000')
    assert_equal(result.getvalue(2,0), '002')
  end

  def test_unknown_database_migrations
    ENV['env'] = 'unknown'
    config = Config.new
    DB::migrate(@config)
    assert_equal(DB::migrations(config), [])
  end

  def test_migrate
    assert_equal(DB::version(@config), '000')
    DB::migrate(@config)
    assert_equal(DB::version(@config), '002')
  end

  def test_migrate_existing_database
    pg = Postgres.new(@config)
    result = pg.execute("DROP TABLE migrations;")
    pg.finish
    DB::migrate(@config)
    assert_equal(DB::version(@config), '002')
  end

  def test_migrate_wrong_script
    File.rename('test/migrations/003_wrong_script.tmp', 'test/migrations/003_wrong_script.rb')
    assert_equal(DB::version(@config), '000')
    DB::migrate(@config)
    assert_equal(DB::version(@config), '002')
    File.rename('test/migrations/003_wrong_script.rb', 'test/migrations/003_wrong_script.tmp')
  end

  def test_rollback
    assert_equal(DB::version(@config), '000')
    DB::migrate(@config)
    assert_equal(DB::version(@config), '002')
    DB::rollback(@config)
    assert_equal(DB::version(@config), '001')
  end

  def test_forward
    assert_equal(DB::version(@config), '000')
    DB::forward(@config)
    assert_equal(DB::version(@config), '001')
  end
end
