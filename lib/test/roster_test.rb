require "minitest/autorun"
require_relative "../roster"
require_relative "../../lib/mock_loader"
require "json"

class RosterTest < Minitest::Test
  def setup
    @data = MockLoader.load("./mock_data/mock_week.json")
  end

  def test_find_employee
    employees = @data.dig("employees")
    employee = Roster.find_employee(employees, "ALIC BROW")
    assert_equal "ALICE BROWN", employee.dig("displayName")
  end

  def test_find_employee_no_matcher
    employees = @data.dig("employees")
    employee_nil = Roster.find_employee_no_match(employees, "ALIC BROW")
    assert_nil employee_nil
    employee = Roster.find_employee_no_match(employees, "ALICE BROWN")
    assert_equal "ALICE BROWN", employee.dig("displayName")
  end

  
end