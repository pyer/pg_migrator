# coding: utf-8
require 'minitest/autorun'
require './lib/config.rb'

class TestConfig < Minitest::Test
  def test_config_initialize
    ENV['env'] = 'test'
    conf = Config.new
    assert_equal(conf.env,      'test')
    assert_equal(conf.host,     'localhost')
    assert_equal(conf.port,     '5432')
    assert_equal(conf.username, 'pba')
    assert_equal(conf.password, 'pba')
    assert_equal(conf.database, 'pyer_test')
    assert_equal(conf.version0, '0.00')
  end

  def test_config_default_env
    ENV['env'] = nil
    conf = Config.new
    assert_equal(conf.env,      'dev')
    assert_equal(conf.host,     'localhost')
    assert_equal(conf.port,     '5432')
    assert_equal(conf.username, 'pba')
    assert_equal(conf.password, 'pba')
    assert_equal(conf.database, 'pyer_dev')
    assert_equal(conf.version0, '0.00')
  end

  def test_config_unknown_env
    # beware, config/unknown must not exist
    ENV['env'] = 'unknown'
    conf = Config.new
    assert_nil(conf.database)
  end

  def test_config_version_0
    conf = Config.new
    assert_equal(conf.version('path/0.0.0_up_what.sql'), '0.0.0')
  end

  def test_config_version_1
    conf = Config.new
    assert_equal(conf.version('/tmp/path/0.0.1_up_what.sql'), '0.0.1')
  end

  def test_config_version_2
    conf = Config.new
    assert_equal(conf.version('path/002_up_what.sql'), '002')
  end

  def test_config_next_version_0
    conf = Config.new
    assert_equal(conf.version('path/000_up_what.sql').next, '001')
  end

  def test_config_next_version_01
    conf = Config.new
    assert_equal(conf.version('path/0.0.1_up_what.sql').next, '0.0.2')
  end

  def test_config_next_version_1
    conf = Config.new
    assert_equal(conf.version('path/0.00_up_what.sql').next, '0.01')
  end

  def test_config_next_version_9
    conf = Config.new
    assert_equal(conf.version('path/0.9_up_what.sql').next, '1.0')
  end

  def test_config_next_version_09
    conf = Config.new
    assert_equal(conf.version('path/0.09_up_what.sql').next, '0.10')
  end

  def test_config_next_version_a
    conf = Config.new
    assert_equal(conf.version('path/abcd_up_what.sql').next, 'abce')
  end
end
