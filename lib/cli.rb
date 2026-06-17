require_relative "shifts"

class CLI
  # available commands
  # shifts hours me thisweek/nextweek
  # shifts hours name thisweek/nextweek
  # shifts willsee name name thisweek/nextweek
  def self.run(argv)
    command = argv.shift ## ARGV now contains remaining data 
    abort "Expected thisweek or nextweek for final argument" unless ["thisweek", "nextweek"].include?(argv.last.downcase)
    period = argv.pop.downcase
    date = define_period(period)

    client = Client.new
    employees = client.get_employees(date)
    
    case command
    when "hours"
      hours(employees, argv)
    when "willsee"
      willsee(employees, argv)
    else 
      abort "Unknown command: #{command}"
    end
    
    
    
  end

  def self.define_period(period)
    date =
    case period
    when "thisweek"
      Dates.this_week
    when "nextweek"
      Dates.next_week
    else 
      Dates.this_week
    end
    date
  end

  def self.hours(employees, argv)
    abort "Invalid format, should be shifts hours NAME thisweek/nextweek" unless argv.size == 1
    if argv[0].downcase == "me"
      shifts = Roster.shifts_for(employees, ENV["MY_NAME"])
    else
      shifts = Roster.shifts_for(employees, argv[0].downcase)
    end
    shift_data = Calculator.calc_shift_data(shifts, start_key: "startTime", end_key: "endTime")
    ShiftFormatter.format_shifts(shift_data)
  end

  def self.willsee(employees, argv)
    abort "Invalid format, format must be shifts willsee NAME NAME thisweek/nextweek" unless argv.size == 2
    p1 = argv[0].downcase
    p2 = argv[1].downcase
    p1_data = Calculator.calc_shift_data(Roster.shifts_for(employees, p1), start_key: "startTime", end_key: "endTime")
    p2_data = Calculator.calc_shift_data(Roster.shifts_for(employees, p2), start_key: "startTime", end_key: "endTime")
    Roster.find_shifts_in_common(employees, p1_data, p2_data)
  end
end