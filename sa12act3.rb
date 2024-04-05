require "httparty"


# results = HTTParty.get(url, format: :json, :headers => { 'X-AIO-Key': '#{api_key}' })

def get_weather_data(location, date)
  results = {}
  api_key = "14e79b7a71e27b2505689453f88fd3d7"
  location_api = "http://api.openweathermap.org/geo/1.0/direct?q=#{location}&limit=1&appid=#{api_key}"
  location_results = HTTParty.get(location_api, format: :json)

  lat = location_results[0]["lat"]
  lon = location_results[0]["lon"]

  weather_api = "https://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&appid=#{api_key}"
  results["wather_data"] = HTTParty.get(weather_api, format: :json)

  api_key_history = "b4167869d17747d0a1930304240504"
  history_api = "https://api.weatherapi.com/v1/history.json?q=#{location}&dt=#{date}&key=#{api_key_history}"
  results["history_data"] = HTTParty.get(history_api, format: :json)

  # puts results["history_data"]["forecast"]["forecastday"][0]["hour"].inject(0){|sum,e| sum + e["temp_f"]}

  return results
end

def task_1
  location = "london"
  date = "2024-04-01"
  results = get_weather_data(location, date)

  puts "temperature: #{results["wather_data"]["main"]["temp"]}"
  puts "humidity: #{results["wather_data"]["main"]["humidity"]}"
  puts "weather condition: #{results["wather_data"]["weather"][0]["main"]}"

  total_temp = results["history_data"]["forecast"]["forecastday"][0]["hour"].inject(0){|sum,e| sum + e["temp_f"]}
  average = (total_temp/24).round(2)
  puts "average temperature of #{date} is #{average}"

end

def get_exchange_rate_data(source, destination)
  exchange_rate = 0
  api_key = "a1388899cacecefdad9bcfb3"
  weather_api = "https://v6.exchangerate-api.com/v6/#{api_key}/latest/#{source}"
  results = HTTParty.get(weather_api, format: :json)
  exchange_rate = results["conversion_rates"][destination]

  return exchange_rate
end

def convert_currency(source, destination, amount)
  exchange_rate = get_exchange_rate_data(source, destination)
  result = exchange_rate.to_f * amount.to_f
  return result
end

def task_2
  source = "USD"
  destination = "BDT"
  amount = 12
  result = convert_currency(source, destination, amount).round(2)

  puts "#{amount} #{source} to #{destination} is #{result} "
end

def get_event_data(country)
  api_key = "bkKef0klSGXebpNv2paHhWksOAWrwPQS"
  event_api ="https://app.ticketmaster.com/discovery/v2/events.json?countryCode=#{country}&apikey=#{api_key}"
  result = HTTParty.get(event_api, format: :json)
  # puts result["_embedded"]["events"][0]["name"]
  # exchange_rate = results["conversion_rates"][destination]

  return result
end

def task_3
  country = "US"
  result = get_event_data(country)

  # puts "#{amount} #{source} to #{destination} is #{result} "
  events = result["_embedded"]["events"]
  # puts events[0]

  events.each do |event|
    puts "event name: #{event["_embedded"]["venues"][0]["name"]}"
    puts "event venue: #{event["_embedded"]["venues"][0]["address"]["line1"]}, #{event["_embedded"]["venues"][0]["city"]["name"]}, #{event["_embedded"]["venues"][0]["state"]["name"]}, #{event["_embedded"]["venues"][0]["postalCode"]}, #{event["_embedded"]["venues"][0]["country"]["name"]},"
    puts "event date: #{event["dates"]["start"]["localDate"]}"
    puts "event time: #{event["dates"]["start"]["localTime"]}"
    puts

    # puts "event name: #{event["_links"]["_embedded"]}"
    # puts "event name: #{event["name"]}"
    # puts "event name: #{event["name"]}"
    # puts "event name: #{event["name"]}"
  end
end


puts "-----task 1 start------"
puts
task_1
puts
puts "-----task 1 end------"
puts "-----task 2 start------"
puts
task_2
puts
puts "-----task 2 end------"
puts "-----task 3 start------"
puts
task_3
puts "-----task  end------"
