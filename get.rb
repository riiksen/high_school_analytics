["net/http", "colorize", "net/https", "uri"].map { |lib| require lib }

schools = []

File.open("schools.txt", "r") do |file|
  while (line = file.gets)
    schools << line
  end
end

addr = {
  :stats => "https://slaskie.edu.com.pl/kandydat/app/statistics.html",
  :admitted => "https://slaskie.edu.com.pl/kandydat/app/admitted_statistics.html",
  :free => "https://slaskie.edu.com.pl/kandydat/app/free_places.html"
}

uri = URI.parse("https://slaskie.edu.com.pl/kandydat/app/statistics.html")
client = Net::HTTP.new uri.host, uri.port
client.use_ssl = true

res = client.get uri.to_s
# cookie = (client.get uri.to_s)["Set-Cookie"]
cookie = res["Set-Cookie"]
viewstate = (res.body.scan /j_id1:javax\.faces\.ViewState:0\" value=\"([0-9:-]{0,})/)[0][0].sub ":", "%3A" # javax.faces.ViewState

headers = {
  #"Host" => "slaskie.edu.com.pl",
  # "Content-Type" => "application/x-www-form-urlencoded",
  "Cookie" => cookie
}

# # Download statistics
# # data = "j_idt46=j_idt46&j_idt46%3AcitySelect=&j_idt46%3AschoolSelect=#{schools[idx]}&j_idt46%3Aj_idt58=Szukaj&javax.faces.ViewState=#{viewstate}"
# data = "j_idt46=j_idt46&j_idt46%scitySelect=&j_idt46%sschoolSelect=%i&j_idt46%sj_idt58=Szukaj&javax.faces.ViewState=%s"
# # data % ["%3A", "%3A", schools[idx], "%3A", viewstate]
# 
# Dir.mkdir("stats") unless Dir.exist?("stats")
# 
# schools.size.times do |idx|
#   tmp_data = data % ["%3A", "%3A", schools[idx], "%3A", viewstate]
#   headers["Content-Length"] = tmp_data.size.to_s
#   res = client.post(addr[:stats], tmp_data, headers)
#   # require "debug"
#   # puts "#{schools[idx]}: #{res.code} -> #{res.body}"
# 
#   puts "Downloading statistics for %s (%s of %s) |%s%s|" % [
#     schools[idx], idx + 1, schools.size, "%" * (100 / schools.size * (idx + 1)), "-" * (100 / schools.size * (schools.size - idx))]
# 
#   f = File.new("stats/#{schools[idx]}.html", "w+")
#   f.puts res.body
# end

res = client.get addr[:admitted]
viewstate = (res.body.scan /j_id1:javax\.faces\.ViewState:0\" value=\"([0-9:-]{0,})/)[0][0].sub ":", "%3A" # javax.faces.ViewState
cookie = res["Set-Cookie"]

headers = {
  "Cookie" => cookie
}

# Download admitted statistics
data = "j_idt171=j_idt171&j_idt171%scitySelect=&j_idt171%sschoolSelect=%i&j_idt171%sj_idt188=Szukaj&javax.faces.ViewState=%s"
Dir.mkdir("admitted") unless Dir.exist?("admitted")

schools.size.times do |idx|
  tmp_data = data % ["%3A", "%3A", schools[idx], "%3A", viewstate]
  headers["Content-Length"] = tmp_data.size.to_s
  res = client.post(addr[:admitted], tmp_data, headers)
  # require "debug"
  # puts "#{schools[idx]}: #{res.code} -> #{res.body}"

  puts "Downloading admitted statistics for %s (%s of %s) |%s%s|" % [
    schools[idx], idx + 1, schools.size, "%" * (100 / schools.size * (idx + 1)), "-" * (100 / schools.size * (schools.size - idx))]

  f = File.new("admitted/#{schools[idx]}.html", "w+")
  f.puts res.body
  f.close
end

# Download free places
# data = "j_idt46=j_idt46&j_idt46%scitySelect=&j_idt46%sschoolSelect=%i&j_idt46%sj_idt58=Szukaj&javax.faces.ViewState=%s"
# Dir.mkdir("free")
# 
# schools.size.times do |idx|
#   tmp_data = data % [data % ["%3A", "%3A", schools[idx], "%3A", viewstate]
#   headers["Content-Length"] = tmp_data.size.to_s
#   res = client.post(addr[:free], tmp_data, headers)
#   # require "debug"
#   puts "#{schools[idx]}: #{res.code} -> #{res.body}"
# end