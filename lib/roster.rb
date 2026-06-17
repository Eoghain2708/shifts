require_relative "client"
require "fuzzy_match"
module Roster
  # @param employees - the json of all employees and their shifts
  # @param {String} employee_name
  def self.shifts_for(employees, employee_name)
    employee = find_employee(employees, employee_name)
    shifts = employee&.dig("shifts")
    shifts
  end


  # @param employees
  # @param {Hash<Hash>} employee_one_shifts
  # @param {Hash<Hash>} employee_two_shifts
  def self.find_shifts_in_common(employees, employee_one_shifts, employee_two_shifts)
    emp_one_name = employee_one_shifts[:name]
    emp_two_name = employee_two_shifts[:name]
    found = false
    employee_one_shifts[:shifts].each do |k, v|
      next unless employee_two_shifts[:shifts].keys.include?(k)
      if employee_two_shifts[:shifts].keys.size == 0 && employee_one_shifts[:shifts].keys.size == 0
        return "This rota appears not to be done yet. Check back later."
      end
      found = true
      e2_shift = employee_two_shifts[:shifts][k]
      if e2_shift[:finish] > v[:finish] || e2_shift[:start] < v[:finish]
        puts "Shift in common found! Date: #{Date.parse(k).strftime("%A %d %B %Y")}"
        puts "*" * 30
        puts "#{emp_one_name}'s shift: #{v[:pretty_shift]}"
        puts "-" * 30
        puts "#{emp_two_name}'s shift: #{e2_shift[:pretty_shift]}"
        puts "-" * 30
      end
    end
    puts "#{emp_one_name} and #{emp_two_name} will not see each other this week :(" unless found
  end


  private

  # @param {Array} employees, list of employees in JSON
  # @param {String} employee_name, targeted employee
  def self.find_employee(employees, employee_name)
    matcher = FuzzyMatch.new(employees, read: "displayName")
    employee = matcher.find(employee_name)
    return nil unless employee
    employee
  end

  
end