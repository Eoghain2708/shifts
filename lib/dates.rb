require "date"
module Dates
  def self.this_week
    today = Date.today

    friday = if today.friday?
      today
    else
      today - ((today.wday - 5) % 7)
    end
    friday
  end

  def self.next_week
    this_week + 7
  end
end