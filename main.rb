["net/http", "net/https", "colorize"].map { |lib| require lib }

schools = []

File.open("schools.txt", "r") do |file| # Get school ids from file (one on line)
  while (line = file.gets)
    schools << line
  end
end

addr = {
  :stats => "https://slaskie.edu.com.pl/kandydat/app/statistics.html",
  :admitted => "https://slaskie.edu.com.pl/kandydat/app/admitted_statistics.html",
}

data = "%s=%s&%s%scitySelect=&%s%sschoolSelect=%i&%s%s%s=Szukaj&javax.faces.ViewState=%s"
# data % [ids[0], ids[0], ids[0], "%3A", ids[0], "%3A", schools[idx], ids[0], "%3A", ids[1], viewstate] # Templating

uri = URI.parse("https://slaskie.edu.com.pl/kandydat/app/statistics.html")
client = Net::HTTP.new uri.host, uri.port
client.use_ssl = true

addr.each do |name, address| # Loop over the addresses
  res = client.get address
  cookie = res["Set-Cookie"] # Get cookies
  viewstate = (res.body.scan /j_id1:javax\.faces\.ViewState:0\" value=\"([0-9:-]{0,})/)[0][0].sub ":", "%3A" # javax.faces.ViewState
  ids = (res.body.scan /submit\" name=\"([a-zA-Z0-9_]{0,}):([a-zA-Z0-9_]{0,})\" value=\"Szukaj\"/)[0] # Get the form ids

  headers = {"Cookie" => cookie}

  Dir.mkdir(name.to_s) unless Dir.exist?(name.to_s) # Mkdir for outputs if it not exists

  schools.size.times do |idx| # Loop over school ids
    tmp_data = data % [ids[0], ids[0], ids[0], "%3A", ids[0], "%3A", schools[idx], ids[0], "%3A", ids[1], viewstate] # Templating
    headers["Content-Length"] = tmp_data.size.to_s
    res = client.post(address, tmp_data, headers)

    puts "Downloading %s for %s (%s of %s) |%s%s|" % [name,
      schools[idx], idx + 1, schools.size, "%" * (100 / schools.size * (idx + 1)), "-" * (100 / schools.size * (schools.size - idx))]

    f = File.new("#{name}/#{schools[idx]}", "w+")
    f.puts res.body
    f.close
  end
end