require "net/http"
require "json"
require "time"
require "fileutils"
require "dotenv"

class Client
  Dotenv.load
  LOGIN_URL = ENV["LOGIN_URL"]
  
  CACHE_DIR = File.join(Dir.home, ".cache", "shifts")
  CACHE_FILE = File.join(CACHE_DIR, "token.json")

  def get_employees(date)
    login_token = login_and_get_token()
    roster_url = "#{ENV["ROSTER_URL"]}date=#{date}"
    roster_uri = URI("#{roster_url}")
    
    roster_request = Net::HTTP::Get.new(roster_uri)
    roster_request["synergy-login-token"] = login_token
    roster_response = Net::HTTP.start(roster_uri.hostname, roster_uri.port, use_ssl: true) do |http|
      http.request(roster_request)
    end
    
    body = JSON.parse(roster_response.body)
    body["employees"]
  end
  
  private
  def login_and_get_token
    return cached_token if cached_token

    uri = URI(LOGIN_URL)
    request = Net::HTTP::Post.new(uri)
    request["Content-Type"] = "application/json"

    request.body = {
      loginIp: "",
      password: ENV["PASS"],
      userId: ENV["USER_ID"],
    }.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    body = JSON.parse(response.body)

    FileUtils.mkdir_p(CACHE_DIR)
    puts "writing to #{CACHE_FILE}"

    File.write(
      CACHE_FILE,
      JSON.pretty_generate(
        loginToken: body["loginToken"],
        expiryTime: body["expiryTime"]
      )
    )
    body["loginToken"]
  end

  def cached_token
    return nil unless File.exist?(CACHE_FILE)
    return nil if File.zero?(CACHE_FILE)
    cache = JSON.parse(File.read(CACHE_FILE))

    return nil if Time.now.to_i * 1000 >= cache["expiryTime"]

    cache["loginToken"]
  end
end