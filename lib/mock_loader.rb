require "json"
module MockLoader
  def self.load(file_name)
    path = File.expand_path(file_name, __dir__)
    JSON.parse(File.read(path))
  end
end