require "minitest/autorun"
require_relative "../calculator"
require "bigdecimal"
require_relative "../mock_loader"

class CalculatorTest < Minitest::Test

  def test_calc_base_hourly_wage_under_21
    employee = {
      age: 20,
      job_code: Calculator::JOB_CODES["General Staff"]
    }
    assert_equal BigDecimal("10.85"), Calculator.calc_hourly_wage(employee)
  end

  def test_calc_base_hourly_wage_over_21
    employee = {
      age: 22,
      job_code: Calculator::JOB_CODES["General Staff"]
    }

    assert_equal BigDecimal("12.71"), Calculator.calc_hourly_wage(employee)
  end

  def test_calc_hourly_wage_over_21
    employee = {
      age: 21,
      job_code: Calculator::JOB_CODES["General Staff"]
    }

    assert_equal BigDecimal("12.71"), Calculator.calc_hourly_wage(employee)
  end

  def test_role
    gen_manager = "1489343527823711206"
    duty_manager = "1489343542827589598"
    supervisor = "1489339758941806044"
    gen_staff = "1537027076506875352"
  

    assert_equal "General Manager", Calculator.role(gen_manager)
    assert_equal "Duty Manager", Calculator.role(duty_manager)
    assert_equal "Supervisor", Calculator.role(supervisor)
    assert_equal "General Staff", Calculator.role(gen_staff)
  end

  def test_calc_hourly_wage_general_staff_under_21
    general_staff = {
      age: 20,
      job_code: Calculator::JOB_CODES["General Staff"]
    }

    assert_equal BigDecimal("10.85"), Calculator.calc_hourly_wage(general_staff)
  end

  def test_calc_hourly_wage_general_staff_over_21
    general_staff = {
      age: 22,
      job_code: Calculator::JOB_CODES["General Staff"]
    }

    assert_equal BigDecimal("12.71"), Calculator.calc_hourly_wage(general_staff)
  end

  def test_calc_hourly_wage_supervisor_over_21
    sup = {
      age: 25,
      job_code: Calculator::JOB_CODES["Supervisor"]
    }

    assert_equal BigDecimal("13.11"), Calculator.calc_hourly_wage(sup)
  end
  
  def test_calc_hourly_wage_supervisor_under_21
    sup = {
      age: 20,
      job_code: Calculator::JOB_CODES["Supervisor"]
    }

    assert_equal BigDecimal("11.25"), Calculator.calc_hourly_wage(sup)
  end
  def test_calc_hourly_wage_duty_manager_over_21
    d_man = {
      age: 25,
      job_code: Calculator::JOB_CODES["Duty Manager"]
    }

    assert_equal BigDecimal("13.11"), Calculator.calc_hourly_wage(d_man)
  end

  def test_calc_hourly_wage_duty_manager_under_21
    d_man = {
      age: 20,
      job_code: Calculator::JOB_CODES["Duty Manager"]
    }

    assert_equal BigDecimal("11.25"), Calculator.calc_hourly_wage(d_man)
  end

  def test_calc_hourly_wage_manager_over_21
    g_man = {
      age: 25,
      job_code: Calculator::JOB_CODES["General Manager"]
    }

    assert_equal BigDecimal("13.11"), Calculator.calc_hourly_wage(g_man)
  end

  def test_calc_hourly_wage_duty_manager_under_21
    g_man = {
      age: 20,
      job_code: Calculator::JOB_CODES["General Manager"]
    }

    assert_equal BigDecimal("11.25"), Calculator.calc_hourly_wage(g_man)
  end

  def test_calc_shift_data_under_21
    data = {
  shifts: {
    "2026-06-30" => [
      {
        "person" => { "name" => "ALICE BROWN" },
        "shiftText" => { "time12Hr" => "10a-6:30p" },
        "startTime" => { "orderableTime" => 10.0 },
        "endTime" => { "orderableTime" => 18.5 },
        "netDuration" => { "decimal" => 8.5 }
      }
    ]
  },
  age: 20,
  job_code: Calculator::JOB_CODES["General Manager"]
}
    result = Calculator.calc_shift_data(data, start_key: "startTime", end_key: "endTime")
    shift = result[:shifts]["2026-06-30"].first
    assert_equal "ALICE BROWN", result[:name]
    assert_equal "General Manager", result[:role]
    assert_equal 11.25, result[:hourly_wage]
    assert_equal 10.0, shift[:start]
    assert_equal 18.5, shift[:finish]
    assert_equal 8.5, shift[:hours]
    assert_equal "10a-6:30p", shift[:pretty_shift]
    assert_equal 95.63, shift[:pay]
  end

  def test_calc_shift_data_over_21
    data = {
  shifts: {
    "2026-06-30" => [
      {
        "person" => { "name" => "ALICE BROWN" },
        "shiftText" => { "time12Hr" => "10a-6:30p" },
        "startTime" => { "orderableTime" => 10.0 },
        "endTime" => { "orderableTime" => 18.5 },
        "netDuration" => { "decimal" => 8.5 }
      }
    ]
  },
  age: 21,
  job_code: Calculator::JOB_CODES["General Manager"]
}
    result = Calculator.calc_shift_data(data, start_key: "startTime", end_key: "endTime")
    shift = result[:shifts]["2026-06-30"].first
    assert_equal "ALICE BROWN", result[:name]
    assert_equal "General Manager", result[:role]
    assert_equal 13.11, result[:hourly_wage]
    assert_equal 10.0, shift[:start]
    assert_equal 18.5, shift[:finish]
    assert_equal 8.5, shift[:hours]
    assert_equal "10a-6:30p", shift[:pretty_shift]
    assert_equal 111.44, shift[:pay]
  end
end