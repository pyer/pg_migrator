require 'minitest/autorun'
require './lib/config.rb'

class TestConfig < Minitest::Test
  def test_initialize
    ENV['env'] = 'test'
    conf = Config.new
    assert_equal(conf.env,      'test')
    assert_equal(conf.host,     'localhost')
    assert_equal(conf.port,     '5432')
    assert_equal(conf.username, 'pba')
    assert_equal(conf.password, 'pba')
    assert_equal(conf.database, 'pyer_test')
    assert_equal(conf.pattern,  'test/migrations/*.rb')
  end

  def test_default_env
    ENV['env'] = nil
    conf = Config.new
    assert_equal(conf.env,      'dev')
    assert_equal(conf.host,     'localhost')
    assert_equal(conf.port,     '5432')
    assert_equal(conf.username, 'pba')
    assert_equal(conf.password, 'pba')
    assert_equal(conf.database, 'pyer_dev')
    assert_equal(conf.pattern,  'migrations/*.rb')
  end

  def test_unknown_env
    # beware, config/unknown must not exist
    ENV['env'] = 'unknown'
    conf = Config.new
    assert_nil(conf.database)
  end
end
