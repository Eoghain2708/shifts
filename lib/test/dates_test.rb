require "minitest/autorun"
require_relative "../dates"


class DatesTest < Minitest::Test

  def test_this_week
    date = Dates.this_week
    assert date.friday?
  end

  def test_next_week
    date = Dates.next_week
    assert date.friday?
  end

  def test_last_week
    date = Dates.last_week
    assert date.friday?
  end

  def test_tomorrow
    assert_equal Date.today + 1, Dates.tomorrow
  end

  def test_yesterday
    assert_equal Date.today - 1, Dates.yesterday
  end

  def test_mondays
    this_m = Dates.monday
    last_m = Dates.lmonday
    next_m = Dates.nmonday

    assert this_m.monday?
    assert last_m.monday?
    assert next_m.monday?

    assert_equal last_m + 7, this_m
    assert_equal this_m + 7, next_m
    assert_equal last_m + 14, next_m
  end

  def test_tuesdays
    this_t = Dates.tuesday
    last_t = Dates.ltuesday
    next_t = Dates.ntuesday

    assert this_t.tuesday?
    assert last_t.tuesday?
    assert next_t.tuesday?

    assert_equal last_t + 7, this_t
    assert_equal this_t + 7, next_t
    assert_equal last_t + 14, next_t
  end

  def test_parse_args
    assert_equal Date.new(2026, 6, 26), Dates.parse_arg("26-06-26")
  end
end