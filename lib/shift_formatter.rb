require "date"

module ShiftFormatter
  # @param {Hash} shift_data - must contain keys :name, :shifts, :pay_before_tax
  def self.format_shifts(shift_data)
    puts "-" * 40
    puts "Shifts for #{shift_data[:name]}"
    shift_data[:shifts].each_with_index do |(shift, info), i|
      print_pretty_shift(shift, info)
    end
    puts "Total hours: #{shift_data[:total_hours]}"
    puts "Total pay before tax: £#{shift_data[:pay_before_tax]}"
    puts "-" * 40
  end

  private 
  def self.print_pretty_shift(shift, info)
    puts "*" * 40
      puts "-" * 10
      puts "date: #{Date.parse(shift).strftime("%A %d %B %Y")}"
     info.each do |k, v|
       puts "#{k}: #{v}"
     end
  end
end